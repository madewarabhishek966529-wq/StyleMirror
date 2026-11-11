import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Screen 3: Authentication Modal (Login / Sign Up / Google Auth)
class AuthDialog extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthDialog({super.key, required this.onAuthenticated});

  static Future<void> show(BuildContext context, {required VoidCallback onAuthenticated}) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: AuthDialog(onAuthenticated: onAuthenticated),
      ),
    );
  }

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  bool _isSignUp = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }
    if (pass.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }

    setState(() => _errorMessage = null);
    Navigator.pop(context);
    widget.onAuthenticated();
  }

  void _loginGoogle() {
    Navigator.pop(context);
    widget.onAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.border),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.lock_outline, color: AppTheme.primaryAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isSignUp ? 'Create Account' : 'Welcome Back',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.secondaryText, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _isSignUp
                  ? 'Sign up to save your face shape, favorite cuts, and styling vault'
                  : 'Log in to access your saved hairstyles and barber consultations',
              style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 20),

            // Google Auth Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _loginGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.white),
                label: const Text('Continue with Google'),
              ),
            ),
            const SizedBox(height: 16),

            const Row(
              children: [
                Expanded(child: Divider(color: AppTheme.border)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR', style: TextStyle(fontSize: 11, color: AppTheme.secondaryText)),
                ),
                Expanded(child: Divider(color: AppTheme.border)),
              ],
            ),
            const SizedBox(height: 16),

            if (_isSignUp) ...[
              const Text('Full Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Alex Vance'),
              ),
              const SizedBox(height: 14),
            ],

            const Text('Email Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'alex@example.com'),
            ),
            const SizedBox(height: 14),

            const Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '••••••••',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 8),

            if (!_isSignUp)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset instructions sent to your email.')),
                    );
                  },
                  child: const Text('Forgot Password?', style: TextStyle(fontSize: 11, color: AppTheme.primaryAccent)),
                ),
              ),

            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_errorMessage!, style: const TextStyle(fontSize: 11, color: AppTheme.error)),
              ),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(_isSignUp ? 'Create Account' : 'Log In'),
              ),
            ),
            const SizedBox(height: 12),

            // Toggle login/signup
            Center(
              child: TextButton(
                onPressed: () => setState(() {
                  _isSignUp = !_isSignUp;
                  _errorMessage = null;
                }),
                child: Text(
                  _isSignUp ? 'Already have an account? Log In' : "Don't have an account? Sign Up",
                  style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

