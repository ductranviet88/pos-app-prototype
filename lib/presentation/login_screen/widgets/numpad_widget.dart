import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class NumpadWidget extends StatelessWidget {
  final void Function(String value) onKeyPress;

  const NumpadWidget({super.key, required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    // Layout: 4 rows × 3 columns
    // Row 1: 7, 8, 9
    // Row 2: 4, 5, 6
    // Row 3: 1, 2, 3
    // Row 4: ⇤ (clear), 0, ⌫ (backspace)

    return Column(
      children: [
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 10),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 10),
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 10),
        _buildRow(['clear', '0', 'backspace']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys.asMap().entries.map((entry) {
        final key = entry.value;
        final isLast = entry.key == keys.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: _NumpadKey(value: key, onPress: onKeyPress),
          ),
        );
      }).toList(),
    );
  }
}

class _NumpadKey extends StatefulWidget {
  final String value;
  final void Function(String) onPress;

  const _NumpadKey({required this.value, required this.onPress});

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildKeyContent() {
    if (widget.value == 'backspace') {
      return const Icon(
        Icons.backspace_outlined,
        size: 20,
        color: AppTheme.textSecondary,
      );
    } else if (widget.value == 'clear') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.keyboard_tab_rounded,
            size: 18,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.first_page_rounded,
            size: 16,
            color: AppTheme.textSecondary,
          ),
        ],
      );
    }
    return Text(
      widget.value,
      style: GoogleFonts.ibmPlexSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) {
          _scaleController.reverse();
          widget.onPress(widget.value);
        },
        onTapCancel: () => _scaleController.reverse(),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppTheme.numpadBtn,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: _buildKeyContent()),
        ),
      ),
    );
  }
}
