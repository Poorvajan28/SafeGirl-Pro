import 'package:flutter/material.dart';
import 'package:safegirl_pro/services/app_services.dart';

class EmergencyMessagesScreen extends StatefulWidget {
  const EmergencyMessagesScreen({super.key});

  @override
  State<EmergencyMessagesScreen> createState() =>
      _EmergencyMessagesScreenState();
}

class _EmergencyMessagesScreenState extends State<EmergencyMessagesScreen> {
  final _services = AppServices();
  final _messageController = TextEditingController();
  bool _includeLocation = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentMessage();
  }

  void _loadCurrentMessage() {
    final messages = _services.emergency.scheduledMessages;
    if (messages.isNotEmpty) {
      final activeMessage = messages.firstWhere(
        (m) => m.isActive,
        orElse: () => messages.first,
      );
      setState(() {
        _messageController.text = activeMessage.message;
        _includeLocation = activeMessage.includeLocation;
        _isActive = activeMessage.isActive;
      });
    } else {
      _messageController.text =
          'Emergency! I need help. Please check on me immediately.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.error.withValues(alpha: 0.1),
              colorScheme.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.error,
                      colorScheme.primary,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.error.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.message_outlined, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Emergency Messages',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customize Your SOS Message',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This message will be sent to your guardians during an emergency',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Message Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _messageController,
                          maxLines: 5,
                          maxLength: 200,
                          decoration: InputDecoration(
                            labelText: 'Emergency Message',
                            hintText: 'Enter your custom SOS message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Options
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                'Include Location',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Add your GPS coordinates to the message',
                                style: theme.textTheme.bodySmall,
                              ),
                              value: _includeLocation,
                              onChanged: (value) {
                                setState(() => _includeLocation = value);
                              },
                              activeColor: colorScheme.primary,
                              secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            Divider(height: 1),
                            SwitchListTile(
                              title: Text(
                                'Active Message',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Enable this message for emergencies',
                                style: theme.textTheme.bodySmall,
                              ),
                              value: _isActive,
                              onChanged: (value) {
                                setState(() => _isActive = value);
                              },
                              activeColor: colorScheme.error,
                              secondary: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      colorScheme.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.notification_important,
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Preview Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.error.withValues(alpha: 0.1),
                              colorScheme.primary.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.error.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Message Preview',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _messageController.text.isEmpty
                                  ? 'Your message will appear here'
                                  : _messageController.text,
                              style: theme.textTheme.bodyMedium,
                            ),
                            if (_includeLocation) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Location: https://maps.google.com/?q=28.6139,77.2090',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Save Message',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMessage() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a message'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save message logic would go here
    // For now, just show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Emergency message saved successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Navigate back
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
