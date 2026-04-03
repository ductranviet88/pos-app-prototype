import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class PosActionBarWidget extends StatelessWidget {
  final bool isSubmitting;
  final bool hasItems;
  final VoidCallback onCheckOrder;
  final VoidCallback onAddPlasticBag;
  final VoidCallback onCancelOrder;
  final VoidCallback onCoupon;
  final VoidCallback onSubmitOrder;

  const PosActionBarWidget({
    super.key,
    required this.isSubmitting,
    required this.hasItems,
    required this.onCheckOrder,
    required this.onAddPlasticBag,
    required this.onCancelOrder,
    required this.onCoupon,
    required this.onSubmitOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'Check Order',
              icon: Icons.receipt_long_rounded,
              color: AppTheme.checkBtn,
              onTap: onCheckOrder,
              isEnabled: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              label: 'Plastic Bag',
              icon: Icons.shopping_bag_outlined,
              color: AppTheme.bagBtn,
              onTap: onAddPlasticBag,
              isEnabled: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              label: 'Cancel Order',
              icon: Icons.cancel_outlined,
              color: AppTheme.cancelBtn,
              onTap: onCancelOrder,
              isEnabled: hasItems,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 132,
            child: _ActionButton(
              label: 'Coupon',
              icon: Icons.local_offer_outlined,
              color: const Color(0xFF7C3AED),
              onTap: onCoupon,
              isEnabled: hasItems && !isSubmitting,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 160,
            child: _ActionButton(
              label: isSubmitting ? 'Submitting...' : 'Submit Order',
              icon: isSubmitting
                  ? Icons.hourglass_empty_rounded
                  : Icons.check_circle_outline_rounded,
              color: AppTheme.submitBtn,
              onTap: isSubmitting ? null : onSubmitOrder,
              isEnabled: hasItems && !isSubmitting,
              isLoading: isSubmitting,
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isEnabled;
  final bool isLoading;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isEnabled,
    this.isLoading = false,
    this.isPrimary = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.isEnabled
        ? widget.color
        : widget.color.withAlpha(102);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.isEnabled && widget.onTap != null
            ? (_) => _controller.forward()
            : null,
        onTapUp: widget.isEnabled && widget.onTap != null
            ? (_) {
                _controller.reverse();
                widget.onTap?.call();
              }
            : null,
        onTapCancel: () => _controller.reverse(),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? effectiveColor
                : effectiveColor.withAlpha(26),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: effectiveColor.withOpacity(widget.isPrimary ? 0 : 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: widget.isPrimary ? Colors.white : widget.color,
                  ),
                )
              else
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isPrimary ? Colors.white : effectiveColor,
                ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: widget.isPrimary ? Colors.white : effectiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
