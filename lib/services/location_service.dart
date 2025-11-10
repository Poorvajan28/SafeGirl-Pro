import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:safegirl_pro/models/location_record.dart';
import 'package:safegirl_pro/services/storage_service.dart';

class LocationService {
  final StorageService _storage = StorageService();
  List<LocationRecord> _locationHistory = [];
  StreamController<Position>? _positionStreamController;
  StreamSubscription<Position>? _positionSubscription;

  Future<void> initialize() async {
    await _loadLocationHistory();
  }

  Future<void> _loadLocationHistory() async {
    final data = await _storage.getList(_storage.locationHistoryKey);
    _locationHistory = [];
    for (final item in data) {
      try {
        _locationHistory.add(LocationRecord.fromJson(jsonDecode(item)));
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _saveLocationHistory() async {
    final recentHistory = _locationHistory.length > 100
        ? _locationHistory.sublist(_locationHistory.length - 100)
        : _locationHistory;
    final data = recentHistory.map((l) => jsonEncode(l.toJson())).toList();
    await _storage.saveList(_storage.locationHistoryKey, data);
  }

  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentLocation() async {
    if (!await checkPermission()) return null;
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Stream<Position> startLocationTracking() {
    _positionStreamController = StreamController<Position>.broadcast();
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _positionStreamController?.add(position);
      _recordLocation(position);
    });
    return _positionStreamController!.stream;
  }

  void stopLocationTracking() {
    _positionSubscription?.cancel();
    _positionStreamController?.close();
  }

  Future<void> _recordLocation(Position position) async {
    final record = LocationRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: DateTime.now(),
    );
    _locationHistory.add(record);
    await _saveLocationHistory();
  }

  List<LocationRecord> getLocationHistory() =>
      List.unmodifiable(_locationHistory);

  void dispose() {
    stopLocationTracking();
  }
}
