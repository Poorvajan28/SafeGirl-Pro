import 'dart:convert';
import 'package:safegirl_pro/models/user.dart';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final StorageService _storage = StorageService();
  final LocalAuthentication _localAuth = LocalAuthentication();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    await _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await _storage.getData(_storage.userKey);
    if (userData != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userData));
      } catch (e) {
        _currentUser = null;
      }
    }
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
        localizedReason: 'Authenticate to access Haven Ally',
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

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    String? pin,
    bool useBiometric = false,
  }) async {
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
  }

  Future<void> updateUser(User user) async {
    _currentUser = user;
    await _saveUser();
  }

  Future<void> _saveUser() async {
    if (_currentUser != null) {
      await _storage.saveData(
          _storage.userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  Future<void> logout() async {
    await _storage.remove(_storage.userKey);
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
