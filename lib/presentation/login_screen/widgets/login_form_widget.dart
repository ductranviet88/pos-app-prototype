import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../../../theme/app_theme.dart';
import './numpad_widget.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  // TODO: Replace with Riverpod/Bloc auth state for production
  final String _mockCashierId = '80540033';
  final String _mockPassword = '310188';

  final String _cashierId = '80540033';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  void _onNumpadPress(String value) {
    setState(() {
      _errorMessage = null;
      if (value == 'backspace') {
        if (_password.isNotEmpty) {
          _password = _password.substring(0, _password.length - 1);
        }
      } else if (value == 'clear') {
        _password = '';
      } else {
        if (_password.length < 20) {
          _password += value;
        }
      }
    });
  }

  Future<void> _handleLogin() async {
    if (_password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password using the numpad.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // TODO: Replace with real authentication API call for production
    await Future.delayed(const Duration(milliseconds: 800));

    if (_cashierId == _mockCashierId && _password == _mockPassword) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.mainPosScreen,
          (route) => false,
          arguments: {'cashierId': _cashierId, 'cashierName': 'luckytester'},
        );
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Invalid credentials. Try: $_mockCashierId / $_mockPassword';
      });
    }
  }

  void _handleResetPassword() {
    // TODO: Connect to reset password API for production
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Reset Password',
          style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          'A password reset request will be sent to your store manager. Please contact your supervisor to proceed.',
          style: GoogleFonts.ibmPlexSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Reset request sent to store manager.',
                    style: GoogleFonts.ibmPlexSans(),
                  ),
                  backgroundColor: AppTheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          'Welcome to Mannings Store',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 28),

        // ID Field
        _buildFieldRow(label: 'ID:', child: _buildIdField()),
        const SizedBox(height: 14),

        // Password Field
        _buildFieldRow(label: 'Password:', child: _buildPasswordField()),

        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.error.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.error.withAlpha(77), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: AppTheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12.5,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),

        // Numpad
        NumpadWidget(onKeyPress: _onNumpadPress),

        const SizedBox(height: 20),

        // Bottom action buttons row
        Row(
          children: [
            Expanded(child: _buildResetPasswordButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildLoginButton()),
          ],
        ),

        const SizedBox(height: 20),

        // Demo credentials box
        _buildDemoCredentials(),
      ],
    );
  }

  Widget _buildFieldRow({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildIdField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cardBorder, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _cashierId,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _password.isNotEmpty
              ? AppTheme.primary.withAlpha(128)
              : AppTheme.cardBorder,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _password.isEmpty
                ? Text(
                    'Enter password via numpad',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  )
                : Row(
                    children: List.generate(
                      _password.length.clamp(0, 20),
                      (index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
          ),
          // Blinking cursor indicator
          if (_password.isNotEmpty)
            Container(width: 2, height: 18, color: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _handleResetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.resetBtn,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Reset\nPassword',
          textAlign: TextAlign.center,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.loginCta,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.loginCta.withAlpha(153),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                'Login',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primary.withAlpha(51), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: AppTheme.primary.withAlpha(204),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demo credentials — ID: $_mockCashierId · Password: $_mockPassword',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11.5,
                color: AppTheme.primary.withAlpha(204),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
