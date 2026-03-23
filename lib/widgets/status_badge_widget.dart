import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum PosOrderStatus { draft, itemsAdded, confirmed, submitted, cancelled }

class StatusBadgeWidget extends StatelessWidget {
  final PosOrderStatus status;
  final double? fontSize;

  const StatusBadgeWidget({super.key, required this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config['label'] as String,
        style: TextStyle(
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          color: config['text'] as Color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Map<String, dynamic> _getConfig() {
    switch (status) {
      case PosOrderStatus.draft:
        return {
          'bg': const Color(0xFFF3F4F6),
          'text': const Color(0xFF6B7280),
          'label': 'Draft',
        };
      case PosOrderStatus.itemsAdded:
        return {
          'bg': const Color(0xFFEFF6FF),
          'text': AppTheme.primary,
          'label': 'Items Added',
        };
      case PosOrderStatus.confirmed:
        return {
          'bg': const Color(0xFFECFDF5),
          'text': AppTheme.success,
          'label': 'Confirmed',
        };
      case PosOrderStatus.submitted:
        return {
          'bg': const Color(0xFFF0FDF4),
          'text': const Color(0xFF16A34A),
          'label': 'Submitted',
        };
      case PosOrderStatus.cancelled:
        return {
          'bg': const Color(0xFFFEF2F2),
          'text': AppTheme.cancelBtn,
          'label': 'Cancelled',
        };
    }
  }
}
