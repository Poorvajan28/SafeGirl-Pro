import 'package:flutter/material.dart';
import 'package:safegirl_pro/screens/auth_screen.dart';
import 'package:safegirl_pro/screens/location_history_screen.dart';
import 'package:safegirl_pro/screens/emergency_messages_screen.dart';
import 'package:safegirl_pro/services/app_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _services = AppServices();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = _services.auth.currentUser;

    if (user == null) return const SizedBox();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            _buildSettingsTile(
              icon: Icons.phone,
              title: 'Phone',
              subtitle: user.phone,
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Security',
              subtitle: 'Change PIN and security settings',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.mic_outlined,
              title: 'Voice Commands',
              subtitle: 'Enable hands-free emergency activation',
              trailing: Switch(
                value: _services.voice.isEnabled,
                onChanged: (value) async {
                  await _services.voice.setEnabled(value);
                  setState(() {});
                },
              ),
              onTap: null,
            ),
            _buildSettingsTile(
              icon: Icons.location_on_outlined,
              title: 'Location History',
              subtitle: 'View your location tracking history',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LocationHistoryScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.message_outlined,
              title: 'Emergency Messages',
              subtitle: 'Configure automated messages',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const EmergencyMessagesScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {},
            ),
            const Divider(),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: _logout,
              textColor: colorScheme.error,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: textColor ?? colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text.rich(
        TextSpan(text: subtitle),
        textAlign: TextAlign.left,
      ),
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _services.auth.logout();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }
}
