import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user';
  static const String _guardiansKey = 'guardians';
  static const String _emergencyContactsKey = 'emergency_contacts';
  static const String _locationHistoryKey = 'location_history';
  static const String _emergencySessionsKey = 'emergency_sessions';
  static const String _safeZonesKey = 'safe_zones';
  static const String _scheduledMessagesKey = 'scheduled_messages';
  static const String _voiceCommandsEnabledKey = 'voice_commands_enabled';
  static const String _isOnboardedKey = 'is_onboarded';
  static const String _offlineQueueKey = 'offline_queue_actions';

  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveList(String key, List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values);
  }

  Future<List<String>> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  String get userKey => _userKey;
  String get guardiansKey => _guardiansKey;
  String get emergencyContactsKey => _emergencyContactsKey;
  String get locationHistoryKey => _locationHistoryKey;
  String get emergencySessionsKey => _emergencySessionsKey;
  String get safeZonesKey => _safeZonesKey;
  String get scheduledMessagesKey => _scheduledMessagesKey;
  String get voiceCommandsEnabledKey => _voiceCommandsEnabledKey;
  String get isOnboardedKey => _isOnboardedKey;
  String get offlineQueueKey => _offlineQueueKey;
}
