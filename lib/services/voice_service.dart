import 'dart:async';
import 'package:safegirl_pro/services/storage_service.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum VoiceTone { normal, distressed, panicked }

class VoiceService {
  final StorageService _storage = StorageService();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isEnabled = false;
  VoiceTone _currentTone = VoiceTone.normal;

  final _commandController = StreamController<String>.broadcast();
  final _toneController = StreamController<VoiceTone>.broadcast();

  Stream<String> get commandStream => _commandController.stream;
  Stream<VoiceTone> get toneStream => _toneController.stream;

  bool get isListening => _isListening;
  bool get isEnabled => _isEnabled;
  VoiceTone get currentTone => _currentTone;

  Future<void> initialize() async {
    _isEnabled = await _storage.getBool(_storage.voiceCommandsEnabledKey,
        defaultValue: false);
    await _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<bool> checkPermission() async {
    return await _speechToText.initialize();
  }

  Future<void> startListening() async {
    if (!_isEnabled) return;

    if (!_speechToText.isAvailable) {
      await _speechToText.initialize();
    }

    if (_speechToText.isAvailable && !_isListening) {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _processVoiceCommand(result.recognizedWords);
          }
          _analyzeTone(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  void _processVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('help') ||
        lowerCommand.contains('emergency') ||
        lowerCommand.contains('danger')) {
      _commandController.add('emergency');
    } else if (lowerCommand.contains('cancel') ||
        lowerCommand.contains('stop')) {
      _commandController.add('cancel');
    } else if (lowerCommand.contains('location')) {
      _commandController.add('location');
    } else if (lowerCommand.contains('call')) {
      _commandController.add('call');
    }
  }

  void _analyzeTone(String text) {
    final distressWords = [
      'help',
      'stop',
      'no',
      'please',
      'scared',
      'afraid',
      'danger'
    ];
    final panicWords = ['emergency', 'attack', 'hurry', 'quick', 'now'];

    final lowerText = text.toLowerCase();
    int distressCount =
        distressWords.where((word) => lowerText.contains(word)).length;
    int panicCount =
        panicWords.where((word) => lowerText.contains(word)).length;

    VoiceTone newTone;
    if (panicCount > 0 || distressCount > 2) {
      newTone = VoiceTone.panicked;
    } else if (distressCount > 0) {
      newTone = VoiceTone.distressed;
    } else {
      newTone = VoiceTone.normal;
    }

    if (newTone != _currentTone) {
      _currentTone = newTone;
      _toneController.add(_currentTone);
    }
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _storage.saveBool(_storage.voiceCommandsEnabledKey, enabled);
    if (enabled) {
      await startListening();
    } else {
      await stopListening();
    }
  }

  void dispose() {
    stopListening();
    _commandController.close();
    _toneController.close();
  }
}
