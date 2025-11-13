import 'package:flutter/material.dart';
import 'package:safegirl_pro/screens/emergency_screen.dart';
import 'package:safegirl_pro/screens/guardians_screen.dart';
import 'package:safegirl_pro/screens/profile_screen.dart';
import 'package:safegirl_pro/services/app_services.dart';
import 'package:safegirl_pro/widgets/panic_button.dart';
import 'package:safegirl_pro/widgets/safety_tool_card.dart';
import 'package:safegirl_pro/widgets/voice_indicator.dart';
import 'package:torch_light/torch_light.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _services = AppServices();
  bool _isFlashlightOn = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _services.location.checkPermission();
    final pos = await _services.location.getCurrentLocation();
    if (mounted) {
      setState(() {
        _gpsStatus = pos != null
            ? '${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}'
            : 'Unavailable';
      });
    }
    _services.voice.commandStream.listen((command) {
      if (command == 'emergency') {
        _triggerEmergency();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomePage(),
          const GuardiansScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomePage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = _services.auth.currentUser;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.tertiary,
                  colorScheme.secondary,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.name.split(' ').first ?? 'User',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Your safety companion is active',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStatusChips(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const VoiceIndicator(),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: PanicButton(
                    onPressed: _triggerEmergency,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.tertiary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildQuickActions(theme),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.secondary,
                            colorScheme.tertiary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Safety Tools',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSafetyTools(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChips() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOnline = _services.connectivity.isOnline;
    final gpsText = 'GPS ${_gpsStatus ?? 'Checking...'}';
    final guardiansCount = _services.guardian.getGuardians().length;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatusChip(
          icon: isOnline ? Icons.wifi : Icons.wifi_off,
          label: isOnline ? 'Online' : 'Offline',
          color: isOnline ? colorScheme.primary : colorScheme.error,
        ),
        _StatusChip(
          icon: Icons.location_searching,
          label: gpsText,
          color: colorScheme.secondary,
        ),
        _StatusChip(
          icon: Icons.people_alt,
          label: 'Guardians $guardiansCount/3',
          color: colorScheme.tertiary,
        ),
      ],
    );
  }

  String? _gpsStatus;
  bool _isTracking = false;

  Widget _buildQuickActions(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SafetyToolCard(
                icon: Icons.sos,
                title: 'Quick SOS',
                color: cs.error,
                onTap: _triggerEmergency,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SafetyToolCard(
                icon: _isTracking
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                title: _isTracking ? 'Stop Tracking' : 'Live Tracking',
                color: cs.primary,
                onTap: _toggleTracking,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SafetyToolCard(
                icon: Icons.message_outlined,
                title: 'Check-In',
                color: cs.secondary,
                onTap: _sendCheckIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SafetyToolCard(
                icon: Icons.local_police_outlined,
                title: 'Call Police',
                color: cs.tertiary,
                onTap: _callPolice,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetyTools(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SafetyToolCard(
                icon: Icons.flashlight_on,
                title: 'Flashlight',
                color: theme.colorScheme.secondary,
                onTap: _toggleFlashlight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SafetyToolCard(
                icon: Icons.phone_outlined,
                title: 'Fake Call',
                color: theme.colorScheme.tertiary,
                onTap: _fakeCall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SafetyToolCard(
                icon: Icons.volume_up_outlined,
                title: 'Siren',
                color: theme.colorScheme.primary,
                onTap: _activateSiren,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SafetyToolCard(
                icon: Icons.location_on_outlined,
                title: 'Share Location',
                color: theme.colorScheme.secondary,
                onTap: _shareLocation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SafetyToolCard(
                icon: Icons.people_outline,
                title: 'Guardians',
                color: theme.colorScheme.tertiary,
                onTap: () => setState(() => _currentIndex = 1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SafetyToolCard(
                icon: Icons.settings_backup_restore,
                title: 'Process Queue',
                color: theme.colorScheme.inversePrimary,
                onTap: () async {
                  await _services.offlineQueue.processQueue();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processed queued actions')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
        elevation: 0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.2),
        animationDuration: const Duration(milliseconds: 400),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Guardians',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Future<void> _triggerEmergency() async {
    final session = await _services.emergency.triggerEmergency();
    if (session != null && mounted) {
      await _services.notification.showEmergencyNotification(
        title: 'Emergency Activated',
        body: 'Your guardians have been notified.',
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const EmergencyScreen()),
      );
    }
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      _services.location.stopLocationTracking();
      setState(() => _isTracking = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Live tracking stopped')),
        );
      }
    } else {
      final permitted = await _services.location.checkPermission();
      if (!permitted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission required')),
          );
        }
        return;
      }
      _services.location.startLocationTracking().listen((pos) {
        setState(() {
          _gpsStatus =
              '${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}';
        });
      });
      setState(() => _isTracking = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Live tracking started')),
        );
      }
    }
  }

  Future<void> _sendCheckIn() async {
    final guardians = _services.guardian.getGuardians();
    if (guardians.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add guardians first')),
        );
      }
      return;
    }
    final pos = await _services.location.getCurrentLocation();
    final url = pos != null
        ? ' https://maps.google.com/?q=${pos.latitude},${pos.longitude}'
        : '';
    for (final g in guardians) {
      await _services.telephony.sendSms(
        phone: g.phone,
        body: 'I am checking in. I am safe.$url',
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in sent to guardians')),
      );
    }
  }

  Future<void> _callPolice() async {
    final contacts = _services.emergency.emergencyContacts;
    if (contacts.isEmpty) return;
    final police = contacts.firstWhere(
      (c) => c.type == 'Emergency',
      orElse: () => contacts.first,
    );
    await _services.telephony.makeCall(phone: police.phone);
  }

  Future<void> _toggleFlashlight() async {
    try {
      if (_isFlashlightOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() => _isFlashlightOn = !_isFlashlightOn);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flashlight not available')),
        );
      }
    }
  }

  Future<void> _fakeCall() async {
    await Future.delayed(const Duration(seconds: 2));
    final uri =
        Uri(scheme: 'tel', path: _services.auth.currentUser?.phone ?? '');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _activateSiren() async {
    await _services.voice.speak('Emergency alert activated');
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Siren Activated'),
          content:
              const Text('Loud siren sound is playing to attract attention.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Stop'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _shareLocation() async {
    final position = await _services.location.getCurrentLocation();
    if (position != null) {
      final url =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.location_on,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Your Location'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coordinates:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Google Maps URL:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                SelectableText(
                  url,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Copy the URL above to share your location',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Open in Maps'),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get current location')),
        );
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
