import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../main_pos_screen.dart';

class PosProductGridWidget extends StatelessWidget {
  final List<ProductItem> products;
  final void Function(ProductItem) onProductTap;
  final String Function(double) formatCurrency;

  const PosProductGridWidget({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppTheme.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No products in this category',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(
          product: products[index],
          onTap: onProductTap,
          formatCurrency: formatCurrency,
          animationDelay: Duration(milliseconds: (index * 40).clamp(0, 300)),
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final ProductItem product;
  final void Function(ProductItem) onTap;
  final String Function(double) formatCurrency;
  final Duration animationDelay;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.formatCurrency,
    required this.animationDelay,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  // Category color map
  static const Map<String, Color> _categoryColors = {
    'Beverages': Color(0xFF3B7DD8),
    'Snacks': Color(0xFFFF6B35),
    'Instant Food': Color(0xFFE67E22),
    'Dairy': Color(0xFF27AE60),
    'Bakery': Color(0xFFF39C12),
    'Candy': Color(0xFFE91E8C),
    'Processed Meat': Color(0xFFE74C3C),
  };

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  Color get _categoryColor =>
      _categoryColors[widget.product.category] ?? AppTheme.primary;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _pressController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _pressController.reverse();
          widget.onTap(widget.product);
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _pressController.reverse();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: _isPressed ? _categoryColor.withAlpha(20) : AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isPressed
                  ? _categoryColor.withAlpha(102)
                  : AppTheme.cardBorder,
              width: _isPressed ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.02 : 0.05),
                blurRadius: _isPressed ? 4 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category color indicator strip at top
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: _categoryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(11),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Product icon/image area
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _categoryColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(widget.product.category),
                            size: 22,
                            color: _categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Product name
                      Text(
                        widget.product.name,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Price
                      Text(
                        widget.formatCurrency(widget.product.price),
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _categoryColor,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Beverages':
        return Icons.local_drink_rounded;
      case 'Snacks':
        return Icons.cookie_rounded;
      case 'Instant Food':
        return Icons.ramen_dining_rounded;
      case 'Dairy':
        return Icons.egg_alt_rounded;
      case 'Bakery':
        return Icons.breakfast_dining_rounded;
      case 'Candy':
        return Icons.help_outline;
      case 'Processed Meat':
        return Icons.set_meal_rounded;
      default:
        return Icons.inventory_2_rounded;
    }
  }
}
