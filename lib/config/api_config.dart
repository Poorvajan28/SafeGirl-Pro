/// API Configuration for SafeGirl Pro Backend
class ApiConfig {
  // Server Configuration
  // For development:
  // static const String baseUrl = 'http://localhost:5000/api';

  // For production (Vercel):
  static const String baseUrl =
      'https://backend-130ioyfbc-poorvajan-g-s-projects.vercel.app/api';

  // API Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authVerify = '/auth/verify';

  static const String userProfile = '/user/profile';
  static const String userPreferences = '/user/preferences';

  static const String guardianAdd = '/guardian/add';
  static const String guardianList = '/guardian/list';
  static const String guardianUpdate = '/guardian';
  static const String guardianDelete = '/guardian';

  static const String emergencyTrigger = '/emergency/trigger';
  static const String emergencyHistory = '/emergency/history';
  static const String emergencyActive = '/emergency/active';
  static const String emergencyResolve = '/emergency';
  static const String emergencyCancel = '/emergency';

  static const String locationSave = '/location/save';
  static const String locationHistory = '/location/history';
  static const String locationLast = '/location/last';
  static const String locationRange = '/location/range';

  static const String healthCheck = '/health';

  // Timeout Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
