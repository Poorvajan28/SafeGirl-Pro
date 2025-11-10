import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safegirl_pro/services/app_services.dart';
import 'package:intl/intl.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  final _services = AppServices();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final session = _services.emergency.activeSession;
    final isOnline = _services.connectivity.isOnline;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Emergency')),
        body: const Center(child: Text('No active emergency')),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.errorContainer,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (!isOnline)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.offline_bolt,
                              size: 18, color: colorScheme.onTertiaryContainer),
                          const SizedBox(width: 8),
                          Text(
                            'Offline mode: actions will be queued',
                            style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onTertiaryContainer),
                          ),
                        ],
                      ),
                    ),
                  if (!isOnline) const SizedBox(height: 12),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Icon(
                      Icons.warning,
                      size: 80,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'EMERGENCY ACTIVE',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Started ${DateFormat('HH:mm:ss').format(session.startedAt)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          colorScheme.onErrorContainer.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildStatusCard(
                    'Guardians Notified',
                    '${session.notifiedGuardians.length}',
                    Icons.people,
                    colorScheme,
                  ),
                  const SizedBox(height: 12),
                  _buildStatusCard(
                    'Police Notified',
                    session.policeNotified ? 'Yes' : 'No',
                    Icons.local_police,
                    colorScheme,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(session.latitude, session.longitude),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('emergency_location'),
                        position: LatLng(session.latitude, session.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              color: colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await _services.emergency.cancelEmergency();
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _services.emergency.resolveEmergency();
                        if (mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                      ),
                      child: const Text('I\'m Safe'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      String title, String value, IconData icon, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
