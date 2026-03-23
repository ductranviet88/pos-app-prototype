import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginIllustrationWidget extends StatefulWidget {
  const LoginIllustrationWidget({super.key});

  @override
  State<LoginIllustrationWidget> createState() =>
      _LoginIllustrationWidgetState();
}

class _LoginIllustrationWidgetState extends State<LoginIllustrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background decorative circles
        Positioned(
          top: -40,
          left: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withAlpha(20),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.loginCta.withAlpha(18),
            ),
          ),
        ),
        // Main content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Store illustration (CustomPaint — no broken network dependency)
            _buildStoreIllustration(),
            const Spacer(),
            // Powered by footer
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered by ',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  Text(
                    'MangoTill',
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreIllustration() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * 0.5),
          child: child,
        );
      },
      child: SizedBox(
        width: 280,
        height: 200,
        child: CustomPaint(painter: _StoreIllustrationPainter()),
      ),
    );
  }
}

class _StoreIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Floor / platform
    final floorPaint = Paint()..color = const Color(0xFF7BB8F5);
    final floorPath = Path()
      ..moveTo(w * 0.1, h * 0.65)
      ..lineTo(w * 0.5, h * 0.8)
      ..lineTo(w * 0.9, h * 0.65)
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(floorPath, floorPaint);

    // Left wall
    final leftWallPaint = Paint()..color = const Color(0xFFB8D4F8);
    final leftWallPath = Path()
      ..moveTo(w * 0.1, h * 0.25)
      ..lineTo(w * 0.1, h * 0.65)
      ..lineTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.5, h * 0.1)
      ..close();
    canvas.drawPath(leftWallPath, leftWallPaint);

    // Right wall
    final rightWallPaint = Paint()..color = const Color(0xFF90C0F0);
    final rightWallPath = Path()
      ..moveTo(w * 0.9, h * 0.25)
      ..lineTo(w * 0.9, h * 0.65)
      ..lineTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.5, h * 0.1)
      ..close();
    canvas.drawPath(rightWallPath, rightWallPaint);

    // Checkout counter
    final counterPaint = Paint()..color = const Color(0xFF4A90D9);
    final counterPath = Path()
      ..moveTo(w * 0.35, h * 0.55)
      ..lineTo(w * 0.35, h * 0.7)
      ..lineTo(w * 0.55, h * 0.78)
      ..lineTo(w * 0.55, h * 0.63)
      ..close();
    canvas.drawPath(counterPath, counterPaint);

    // Counter top
    final counterTopPaint = Paint()..color = const Color(0xFF6AAEE8);
    final counterTopPath = Path()
      ..moveTo(w * 0.28, h * 0.5)
      ..lineTo(w * 0.35, h * 0.55)
      ..lineTo(w * 0.55, h * 0.63)
      ..lineTo(w * 0.48, h * 0.58)
      ..close();
    canvas.drawPath(counterTopPath, counterTopPaint);

    // Shelf left wall
    final shelfPaint = Paint()..color = const Color(0xFF5BA3E0);
    for (int i = 0; i < 3; i++) {
      final y = h * (0.28 + i * 0.1);
      final shelfPath = Path()
        ..moveTo(w * 0.12, y)
        ..lineTo(w * 0.12, y + h * 0.08)
        ..lineTo(w * 0.3, y + h * 0.04)
        ..lineTo(w * 0.3, y - h * 0.04)
        ..close();
      canvas.drawPath(shelfPath, shelfPaint);

      // Items on shelf
      final itemColors = [
        const Color(0xFFFF6B6B),
        const Color(0xFFFFD93D),
        const Color(0xFF6BCB77),
      ];
      for (int j = 0; j < 3; j++) {
        final itemPaint = Paint()..color = itemColors[j % itemColors.length];
        canvas.drawRect(
          Rect.fromLTWH(
            w * (0.14 + j * 0.05),
            y - h * 0.04,
            w * 0.03,
            h * 0.07,
          ),
          itemPaint,
        );
      }
    }

    // Person at counter (cashier) — simple silhouette
    final personPaint = Paint()..color = const Color(0xFF2563B8);
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.42, w * 0.06, h * 0.1),
        const Radius.circular(3),
      ),
      personPaint,
    );
    // Head
    canvas.drawCircle(Offset(w * 0.45, h * 0.38), w * 0.035, personPaint);

    // Customer person
    final customerPaint = Paint()..color = const Color(0xFF7C3AED);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.56, h * 0.48, w * 0.06, h * 0.1),
        const Radius.circular(3),
      ),
      customerPaint,
    );
    canvas.drawCircle(Offset(w * 0.59, h * 0.44), w * 0.035, customerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
