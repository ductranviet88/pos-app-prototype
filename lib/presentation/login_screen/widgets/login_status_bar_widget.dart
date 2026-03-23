import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginStatusBarWidget extends StatefulWidget {
  const LoginStatusBarWidget({super.key});

  @override
  State<LoginStatusBarWidget> createState() => _LoginStatusBarWidgetState();
}

class _LoginStatusBarWidgetState extends State<LoginStatusBarWidget> {
  late String _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatTime(DateTime.now());
    // Live clock: update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _currentTime = _formatTime(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    return '$day/$month/$year $h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.ibmPlexSans(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
      color: Colors.white.withAlpha(235),
      letterSpacing: 0.1,
    );
    final valueStyle = GoogleFonts.ibmPlexSans(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.1,
    );

    return Container(
      width: double.infinity,
      height: 36,
      color: AppTheme.statusBar,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Signal icon
          const Icon(
            Icons.signal_cellular_alt,
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 8),
          Text(_currentTime, style: valueStyle),
          const SizedBox(width: 20),
          _buildInfoPair(
            'Version:',
            'MangoTill 1.0.8.0',
            labelStyle,
            valueStyle,
          ),
          const SizedBox(width: 20),
          _buildInfoPair('StoreNo:', '8054', labelStyle, valueStyle),
          const SizedBox(width: 20),
          _buildInfoPair('POS:', '505', labelStyle, valueStyle),
          const SizedBox(width: 20),
          _buildInfoPair('Cashier:', '80540033', labelStyle, valueStyle),
          const SizedBox(width: 20),
          _buildInfoPair('CashierName:', 'luckytester', labelStyle, valueStyle),
          const Spacer(),
          const Icon(Icons.wifi, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text('10.12.68.200', style: valueStyle),
        ],
      ),
    );
  }

  Widget _buildInfoPair(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(width: 3),
        Text(value, style: valueStyle),
      ],
    );
  }
}
