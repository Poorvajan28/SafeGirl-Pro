import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:safegirl_pro/models/pending_action.dart';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:safegirl_pro/services/telephony_service.dart';

class OfflineQueueService {
  final StorageService _storage = StorageService();
  final TelephonyService _telephony;
  List<PendingAction> _queue = [];

  OfflineQueueService(this._telephony);

  Future<void> initialize() async {
    await _load();
  }

  Future<void> _load() async {
    final list = await _storage.getList(_storage.offlineQueueKey);
    _queue = [];
    for (final item in list) {
      try {
        _queue.add(PendingAction.fromJson(jsonDecode(item)));
      } catch (_) {
        continue;
      }
    }
  }

  Future<void> _save() async {
    final data = _queue.map((e) => jsonEncode(e.toJson())).toList();
    await _storage.saveList(_storage.offlineQueueKey, data);
  }

  Future<void> enqueueSms({required String phone, required String body}) async {
    _queue.add(PendingAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PendingActionType.sms,
      phone: phone,
      message: body,
      createdAt: DateTime.now(),
    ));
    await _save();
  }

  Future<void> enqueueCall({required String phone}) async {
    _queue.add(PendingAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PendingActionType.call,
      phone: phone,
      createdAt: DateTime.now(),
    ));
    await _save();
  }

  List<PendingAction> get items => List.unmodifiable(_queue);

  Future<void> processQueue() async {
    if (_queue.isEmpty) return;
    final toRemove = <String>[];
    for (final action in _queue) {
      bool success = false;
      try {
        switch (action.type) {
          case PendingActionType.sms:
            success = await _telephony.sendSms(
                phone: action.phone, body: action.message ?? '');
            break;
          case PendingActionType.call:
            success = await _telephony.makeCall(phone: action.phone);
            break;
        }
      } catch (e) {
        debugPrint('OfflineQueue process error: $e');
      }

      if (success) {
        toRemove.add(action.id);
      } else {
        final idx = _queue.indexWhere((q) => q.id == action.id);
        if (idx != -1) {
          _queue[idx] = action.copyWith(
            attempts: action.attempts + 1,
            lastAttemptAt: DateTime.now(),
          );
        }
      }
    }
    if (toRemove.isNotEmpty) {
      _queue.removeWhere((a) => toRemove.contains(a.id));
    }
    await _save();
  }
}
