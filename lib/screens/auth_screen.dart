import 'package:flutter/material.dart';
import 'package:safegirl_pro/screens/home_screen.dart';
import 'package:safegirl_pro/services/app_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _services = AppServices();
  bool _isRegistering = false;
  bool _useBiometric = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    if (_services.auth.isLoggedIn) {
      _proceedToLogin();
    } else {
      setState(() => _isRegistering = true);
    }
  }

  Future<void> _proceedToLogin() async {
    final user = _services.auth.currentUser;
    if (user == null) return;

    bool authenticated = false;

    if (user.useBiometric) {
      authenticated = await _services.auth.authenticateWithBiometrics();
    }

    if (!authenticated && user.pin != null) {
      if (mounted) {
        authenticated = await _showPinDialog();
      }
    }

    if (authenticated && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<bool> _showPinDialog() async {
    final pinController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter PIN'),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Enter 4-digit PIN',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final isValid =
                  await _services.auth.authenticateWithPin(pinController.text);
              if (context.mounted) {
                Navigator.pop(context, isValid);
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.tertiary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Logo and Title
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shield,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SafeGirl Pro',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Personal Safety Companion',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Glass morphism card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (_isRegistering) ...[
                          _buildGlassTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildGlassTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Required';
                              if (!value!.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildGlassTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Required';
                              if (value!.length < 10) return 'Invalid phone';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildGlassTextField(
                            controller: _pinController,
                            label: '4-Digit Security PIN',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Required';
                              if (value!.length != 4)
                                return 'PIN must be 4 digits';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          FutureBuilder<bool>(
                            future: _services.auth.checkBiometrics(),
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Enable Biometric Login',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Switch(
                                        value: _useBiometric,
                                        onChanged: (value) => setState(
                                            () => _useBiometric = value),
                                        activeColor: colorScheme.tertiary,
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 32),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withValues(alpha: 0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: colorScheme.primary,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Create Account',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'By signing up, you agree to keep yourself safe',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.8)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          counterText: '',
          counterStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        validator: validator,
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final result = await _services.auth.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      pin: _pinController.text,
      useBiometric: _useBiometric,
    );

    if (mounted) {
      Navigator.of(context).pop(); // Close loading

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
