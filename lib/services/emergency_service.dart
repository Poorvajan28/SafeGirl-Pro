import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safegirl_pro/models/emergency_contact.dart';
import 'package:safegirl_pro/models/emergency_session.dart';
import 'package:safegirl_pro/models/scheduled_message.dart';
import 'package:safegirl_pro/services/guardian_service.dart';
import 'package:safegirl_pro/services/location_service.dart';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:safegirl_pro/services/telephony_service.dart';
import 'package:safegirl_pro/services/offline_queue_service.dart';
import 'package:safegirl_pro/services/notification_service.dart';
import 'package:safegirl_pro/services/connectivity_service.dart';
import 'package:vibration/vibration.dart';

class EmergencyService {
  final StorageService _storage = StorageService();
  final GuardianService _guardianService;
  final LocationService _locationService;
  final TelephonyService _telephony;
  final OfflineQueueService _offlineQueue;
  final NotificationService _notification;
  final ConnectivityService _connectivity;

  EmergencySession? _activeSession;
  List<EmergencyContact> _emergencyContacts = [];
  List<ScheduledMessage> _scheduledMessages = [];

  EmergencyService({
    required GuardianService guardian,
    required LocationService location,
    required TelephonyService telephony,
    required OfflineQueueService offlineQueue,
    required NotificationService notification,
    required ConnectivityService connectivity,
  })  : _guardianService = guardian,
        _locationService = location,
        _telephony = telephony,
        _offlineQueue = offlineQueue,
        _notification = notification,
        _connectivity = connectivity;

  Future<void> initialize() async {
    await _loadEmergencyContacts();
    await _loadScheduledMessages();
    await _loadSampleData();
  }

  Future<void> _loadEmergencyContacts() async {
    final data = await _storage.getList(_storage.emergencyContactsKey);
    _emergencyContacts = [];
    for (final item in data) {
      try {
        _emergencyContacts.add(EmergencyContact.fromJson(jsonDecode(item)));
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _loadScheduledMessages() async {
    final data = await _storage.getList(_storage.scheduledMessagesKey);
    _scheduledMessages = [];
    for (final item in data) {
      try {
        _scheduledMessages.add(ScheduledMessage.fromJson(jsonDecode(item)));
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _loadSampleData() async {
    if (_emergencyContacts.isEmpty) {
      final now = DateTime.now();
      _emergencyContacts = [
        EmergencyContact(
          id: '1',
          name: 'Emergency Services',
          phone: '911',
          type: 'Emergency',
          createdAt: now,
          updatedAt: now,
        ),
        EmergencyContact(
          id: '2',
          name: 'Women\'s Helpline',
          phone: '1091',
          type: 'Helpline',
          createdAt: now,
          updatedAt: now,
        ),
      ];
      await _saveEmergencyContacts();
    }

    if (_scheduledMessages.isEmpty) {
      final now = DateTime.now();
      _scheduledMessages = [
        ScheduledMessage(
          id: '1',
          userId: 'current_user',
          message: 'Emergency! I need help. Please check my location.',
          includeLocation: true,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];
      await _saveScheduledMessages();
    }
  }

  Future<void> _saveEmergencyContacts() async {
    final data = _emergencyContacts.map((e) => jsonEncode(e.toJson())).toList();
    await _storage.saveList(_storage.emergencyContactsKey, data);
  }

  Future<void> _saveScheduledMessages() async {
    final data = _scheduledMessages.map((m) => jsonEncode(m.toJson())).toList();
    await _storage.saveList(_storage.scheduledMessagesKey, data);
  }

  Future<EmergencySession?> triggerEmergency() async {
    if (_activeSession != null) return _activeSession;

    final position = await _locationService.getCurrentLocation();
    if (position == null) return null;

    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 1000, pattern: [500, 1000, 500, 2000]);
      }
    } catch (e) {
      debugPrint('Vibration error: $e');
    }

    final now = DateTime.now();
    _activeSession = EmergencySession(
      id: now.millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      status: EmergencyStatus.active,
      latitude: position.latitude,
      longitude: position.longitude,
      startedAt: now,
      updatedAt: now,
    );

    await _notifyGuardians();
    return _activeSession;
  }

  Future<void> _notifyGuardians() async {
    final guardians = _guardianService.getGuardiansByPriority();
    for (final guardian in guardians) {
      await _sendSMS(guardian.phone);
      // Skip auto-call on web to prevent tab redirects
      // await _makeCall(guardian.phone);
      _activeSession = _activeSession?.copyWith(
        notifiedGuardians: [..._activeSession!.notifiedGuardians, guardian.id],
      );
      // Reduced delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (guardians.isEmpty || guardians.every((g) => !g.isVerified)) {
      // Skip police call on web to prevent tab redirects
      // await _notifyPolice();
    }
  }

  Future<void> _sendSMS(String phone) async {
    final message = _scheduledMessages.firstWhere(
      (m) => m.isActive,
      orElse: () => ScheduledMessage(
        id: '0',
        userId: 'current_user',
        message: 'Emergency! I need help.',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    String smsBody = message.message;
    if (message.includeLocation && _activeSession != null) {
      smsBody +=
          ' Location: https://maps.google.com/?q=${_activeSession!.latitude},${_activeSession!.longitude}';
    }

    final sent = await _telephony.sendSms(phone: phone, body: smsBody);
    if (!sent) {
      // Queue for later and notify user
      await _offlineQueue.enqueueSms(phone: phone, body: smsBody);
      await _notification.showSafetyNotification(
        title: 'Offline: Message queued',
        body: 'We will retry sending your SOS to $phone when online.',
      );
    }
  }

  Future<void> _makeCall(String phone) async {
    final placed = await _telephony.makeCall(phone: phone);
    if (!placed) {
      await _offlineQueue.enqueueCall(phone: phone);
      await _notification.showSafetyNotification(
        title: 'Offline: Call queued',
        body: 'We will prompt to call $phone when online.',
      );
    }
  }

  Future<void> _notifyPolice() async {
    final policeContact = _emergencyContacts.firstWhere(
      (c) => c.type == 'Emergency',
      orElse: () => EmergencyContact(
        id: '0',
        name: 'Emergency',
        phone: '911',
        type: 'Emergency',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await _makeCall(policeContact.phone);
    _activeSession = _activeSession?.copyWith(policeNotified: true);
  }

  Future<void> cancelEmergency() async {
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(
        status: EmergencyStatus.cancelled,
        endedAt: DateTime.now(),
      );
      _activeSession = null;
    }
  }

  Future<void> resolveEmergency() async {
    if (_activeSession != null) {
      _activeSession = _activeSession!.copyWith(
        status: EmergencyStatus.resolved,
        endedAt: DateTime.now(),
      );
      _activeSession = null;
    }
  }

  EmergencySession? get activeSession => _activeSession;
  List<EmergencyContact> get emergencyContacts =>
      List.unmodifiable(_emergencyContacts);
  List<ScheduledMessage> get scheduledMessages =>
      List.unmodifiable(_scheduledMessages);

  Future<void> addScheduledMessage(ScheduledMessage message) async {
    _scheduledMessages.add(message);
    await _saveScheduledMessages();
  }

  Future<void> updateScheduledMessage(ScheduledMessage message) async {
    final index = _scheduledMessages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _scheduledMessages[index] = message;
      await _saveScheduledMessages();
    }
  }

  Future<void> deleteScheduledMessage(String id) async {
    _scheduledMessages.removeWhere((m) => m.id == id);
    await _saveScheduledMessages();
  }
}
