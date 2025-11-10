import 'package:flutter/material.dart';
import 'package:safegirl_pro/services/app_services.dart';
import 'package:safegirl_pro/services/voice_service.dart';

class VoiceIndicator extends StatefulWidget {
  const VoiceIndicator({super.key});

  @override
  State<VoiceIndicator> createState() => _VoiceIndicatorState();
}

class _VoiceIndicatorState extends State<VoiceIndicator> {
  final _services = AppServices();
  VoiceTone _currentTone = VoiceTone.normal;

  @override
  void initState() {
    super.initState();
    _services.voice.toneStream.listen((tone) {
      setState(() => _currentTone = tone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!_services.voice.isEnabled) return const SizedBox.shrink();

    Color indicatorColor;
    IconData indicatorIcon;
    String statusText;

    switch (_currentTone) {
      case VoiceTone.panicked:
        indicatorColor = colorScheme.error;
        indicatorIcon = Icons.warning;
        statusText = 'Distress Detected';
        break;
      case VoiceTone.distressed:
        indicatorColor = colorScheme.tertiary;
        indicatorIcon = Icons.info;
        statusText = 'Voice Analysis Active';
        break;
      case VoiceTone.normal:
        indicatorColor = colorScheme.primary;
        indicatorIcon = Icons.mic;
        statusText = 'Voice Monitoring';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: indicatorColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            indicatorIcon,
            color: indicatorColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_services.voice.isListening)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
            ),
        ],
      ),
    );
  }
}
