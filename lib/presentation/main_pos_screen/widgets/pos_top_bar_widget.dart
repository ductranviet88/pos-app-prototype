import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class PosTopBarWidget extends StatefulWidget {
  final String transactionId;
  final VoidCallback onLogout;

  const PosTopBarWidget({
    super.key,
    required this.transactionId,
    required this.onLogout,
  });

  @override
  State<PosTopBarWidget> createState() => _PosTopBarWidgetState();
}

class _PosTopBarWidgetState extends State<PosTopBarWidget> {
  late String _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatTime(DateTime.now());
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
    return '$day/$month $h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = GoogleFonts.ibmPlexSans(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
      color: Colors.white.withAlpha(217),
    );
    final valueStyle = GoogleFonts.ibmPlexSans(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      height: 40,
      color: AppTheme.statusBar,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.store_rounded, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text('MangoTill POS', style: valueStyle),
          const SizedBox(width: 16),
          _buildInfoPair('Store:', '8054', labelStyle, valueStyle),
          const SizedBox(width: 16),
          _buildInfoPair('POS:', '505', labelStyle, valueStyle),
          const SizedBox(width: 16),
          _buildInfoPair(
            'Cashier:',
            'luckytester (80540033)',
            labelStyle,
            valueStyle,
          ),
          const SizedBox(width: 16),
          _buildInfoPair('TXN:', widget.transactionId, labelStyle, valueStyle),
          const Spacer(),
          Text(_currentTime, style: valueStyle),
          const SizedBox(width: 16),
          // Logout button
          GestureDetector(
            onTap: widget.onLogout,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.cancelBtn.withAlpha(64),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.cancelBtn.withAlpha(102),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    size: 13,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Logout',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 11.5,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
