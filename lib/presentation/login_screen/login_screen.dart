import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_illustration_widget.dart';
import './widgets/login_status_bar_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 800;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const LoginStatusBarWidget(),
          Expanded(
            child: isWide
                ? _buildWideLayout(context)
                : _buildNarrowLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        // Left: Illustration
        Expanded(
          flex: 45,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE8EEFF), Color(0xFFDDE5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const LoginIllustrationWidget(),
          ),
        ),
        // Right: Login Form
        Expanded(
          flex: 55,
          child: Container(
            color: AppTheme.background,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: const LoginFormWidget(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8EEFF), Color(0xFFDDE5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const LoginIllustrationWidget(),
            ),
          ),
          const SizedBox(height: 24),
          const LoginFormWidget(),
        ],
      ),
    );
  }
}
