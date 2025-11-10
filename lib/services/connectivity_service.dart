import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController = StreamController<bool>.broadcast();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Stream<bool> get onlineStream => _onlineController.stream;

  Future<void> initialize() async {
    // On some web runtimes, connectivity_plus may not be registered.
    // Provide a safe fallback that treats the app as online to avoid crashes.
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline = result != ConnectivityResult.none;
      _onlineController.add(_isOnline);

      // connectivity_plus v5+ can emit a list of results on some platforms.
      // Normalize both List<ConnectivityResult> and ConnectivityResult.
      _connectivity.onConnectivityChanged.listen((dynamic results) {
        bool hasAny;
        if (results is List<ConnectivityResult>) {
          hasAny = results.isNotEmpty && !results.contains(ConnectivityResult.none);
        } else if (results is ConnectivityResult) {
          hasAny = results != ConnectivityResult.none;
        } else {
          hasAny = true; // default to online if unknown shape
        }

        if (hasAny != _isOnline) {
          _isOnline = hasAny;
          _onlineController.add(_isOnline);
        }
      });
    } on MissingPluginException catch (_) {
      // Web (or test) environment without plugin registration: default to online
      _isOnline = true;
      _onlineController.add(_isOnline);
    } catch (_) {
      // Any other unexpected error: fail open (online) to keep the app usable
      _isOnline = true;
      _onlineController.add(_isOnline);
    }
  }

  void dispose() {
    _onlineController.close();
  }
}
