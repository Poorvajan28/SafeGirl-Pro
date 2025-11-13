import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safegirl_pro/config/api_config.dart';
import 'package:safegirl_pro/models/user.dart';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final StorageService _storage = StorageService();
  final LocalAuthentication _localAuth = LocalAuthentication();

  User? _currentUser;
  String? _authToken;

  User? get currentUser => _currentUser;
  String? get authToken => _authToken;

  Future<void> initialize() async {
    await _loadUser();
    await _loadToken();
  }

  Future<void> _loadUser() async {
    final userData = await _storage.getData(_storage.userKey);
    if (userData != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userData));
      } catch (e) {
        print('Error loading user: $e');
        _currentUser = null;
      }
    }
  }

  Future<void> _loadToken() async {
    _authToken = await _storage.getData('auth_token');
  }

  Future<bool> checkBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access SafeGirl Pro',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithPin(String pin) async {
    if (_currentUser == null) return false;
    return _currentUser!.pin == pin;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    String? pin,
    bool useBiometric = false,
  }) async {
    try {
      // Call backend API to register user
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'pin': pin,
          'useBiometric': useBiometric,
        }),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token
        if (data['token'] != null) {
          _authToken = data['token'];
          await _storage.saveData('auth_token', _authToken!);
        }

        // Save user locally
        _currentUser = User.fromJson(data['user']);
        await _saveUser();

        return {'success': true, 'message': 'Registration successful'};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['error'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      print('Register error: $e');
      // Fallback to local storage if backend fails
      final now = DateTime.now();
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        pin: pin,
        useBiometric: useBiometric,
        createdAt: now,
        updatedAt: now,
      );
      await _saveUser();
      return {'success': true, 'message': 'Registered locally (offline mode)'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String pin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token
        if (data['token'] != null) {
          _authToken = data['token'];
          await _storage.saveData('auth_token', _authToken!);
        }

        // Save user
        _currentUser = User.fromJson(data['user']);
        await _saveUser();

        return {'success': true, 'message': 'Login successful'};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['error'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Connection failed. Please try again.'
      };
    }
  }

  Future<void> updateUser(User user) async {
    _currentUser = user;
    await _saveUser();

    // Update on backend if online
    try {
      if (_authToken != null) {
        await http.put(
          Uri.parse('${ApiConfig.baseUrl}/user/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken',
          },
          body: jsonEncode(user.toJson()),
        );
      }
    } catch (e) {
      print('Update user error: $e');
    }
  }

  Future<void> _saveUser() async {
    if (_currentUser != null) {
      await _storage.saveData(
          _storage.userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  Future<void> logout() async {
    await _storage.remove(_storage.userKey);
    await _storage.remove('auth_token');
    _currentUser = null;
    _authToken = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
