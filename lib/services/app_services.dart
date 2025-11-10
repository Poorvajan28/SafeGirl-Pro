import 'package:safegirl_pro/services/auth_service.dart';
import 'package:safegirl_pro/services/emergency_service.dart';
import 'package:safegirl_pro/services/guardian_service.dart';
import 'package:safegirl_pro/services/location_service.dart';
import 'package:safegirl_pro/services/notification_service.dart';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:safegirl_pro/services/voice_service.dart';
import 'package:safegirl_pro/services/connectivity_service.dart';
import 'package:safegirl_pro/services/offline_queue_service.dart';
import 'package:safegirl_pro/services/telephony_service.dart';

class AppServices {
  static final AppServices _instance = AppServices._internal();
  factory AppServices() => _instance;
  AppServices._internal();

  late final StorageService storage;
  late final AuthService auth;
  late final GuardianService guardian;
  late final LocationService location;
  late final EmergencyService emergency;
  late final VoiceService voice;
  late final NotificationService notification;
  late final ConnectivityService connectivity;
  late final OfflineQueueService offlineQueue;
  late final TelephonyService telephony;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    storage = StorageService();
    auth = AuthService();
    guardian = GuardianService();
    location = LocationService();
    telephony = TelephonyService();
    offlineQueue = OfflineQueueService(telephony);
    connectivity = ConnectivityService();
    notification = NotificationService();
    emergency = EmergencyService(
      guardian: guardian,
      location: location,
      telephony: telephony,
      offlineQueue: offlineQueue,
      notification: notification,
      connectivity: connectivity,
    );
    voice = VoiceService();

    await auth.initialize();
    await guardian.initialize();
    await location.initialize();
    await notification.initialize();
    await connectivity.initialize();
    await offlineQueue.initialize();
    await emergency.initialize();
    await voice.initialize();

    // Process queued actions whenever connectivity is restored; also try on startup.
    connectivity.onlineStream.listen((isOnline) async {
      if (isOnline) {
        await offlineQueue.processQueue();
      }
    });
    await offlineQueue.processQueue();

    _initialized = true;
  }
}
