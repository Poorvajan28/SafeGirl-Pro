import 'dart:convert';
import 'package:safegirl_pro/models/guardian.dart';
import 'package:safegirl_pro/services/storage_service.dart';

class GuardianService {
  final StorageService _storage = StorageService();
  List<Guardian> _guardians = [];

  Future<void> initialize() async {
    await _loadGuardians();
  }

  Future<void> _loadGuardians() async {
    final data = await _storage.getList(_storage.guardiansKey);
    _guardians = [];
    for (final item in data) {
      try {
        _guardians.add(Guardian.fromJson(jsonDecode(item)));
      } catch (e) {
        continue;
      }
    }
    _guardians.sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> _saveGuardians() async {
    final data = _guardians.map((g) => jsonEncode(g.toJson())).toList();
    await _storage.saveList(_storage.guardiansKey, data);
  }

  List<Guardian> getGuardians() => List.unmodifiable(_guardians);

  Future<void> addGuardian(Guardian guardian) async {
    if (_guardians.length >= 3) {
      throw Exception('Maximum 3 guardians allowed');
    }
    _guardians.add(guardian);
    await _saveGuardians();
  }

  Future<void> updateGuardian(Guardian guardian) async {
    final index = _guardians.indexWhere((g) => g.id == guardian.id);
    if (index != -1) {
      _guardians[index] = guardian;
      await _saveGuardians();
    }
  }

  Future<void> deleteGuardian(String id) async {
    _guardians.removeWhere((g) => g.id == id);
    await _saveGuardians();
  }

  Guardian? getGuardianById(String id) {
    try {
      return _guardians.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Guardian> getGuardiansByPriority() {
    final sorted = List<Guardian>.from(_guardians);
    sorted.sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }
}
