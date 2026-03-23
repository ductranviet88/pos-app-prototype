import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/pos_action_bar_widget.dart';
import './widgets/pos_cart_panel_widget.dart';
import './widgets/pos_product_grid_widget.dart';
import './widgets/pos_top_bar_widget.dart';

// Mock data models
class ProductItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final String semanticLabel;

  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.semanticLabel,
  });

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String,
      semanticLabel: map['semanticLabel'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'imageUrl': imageUrl,
    'semanticLabel': semanticLabel,
  };
}

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

class MainPosScreen extends StatefulWidget {
  const MainPosScreen({super.key});

  @override
  State<MainPosScreen> createState() => _MainPosScreenState();
}

class _MainPosScreenState extends State<MainPosScreen> {
  // TODO: Replace with Riverpod/Bloc for production state management

  static final List<Map<String, dynamic>> _productMaps = [
    {
      'id': 'P001',
      'name': 'Coca-Cola 330ml',
      'price': 15000.0,
      'category': 'Beverages',
      'imageUrl':
          'https://images.unsplash.com/photo-1719960243073-7aeb60e7c45d',
      'semanticLabel':
          'Red Coca-Cola aluminum can with white logo on white background',
    },
    {
      'id': 'P002',
      'name': 'Hao Hao Sour Shrimp Noodles',
      'price': 4500.0,
      'category': 'Instant Food',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1dbc026b1-1773651324197.png',
      'semanticLabel':
          'Orange packet of Hao Hao instant noodles with shrimp flavor illustration',
    },
    {
      'id': 'P003',
      'name': 'Oreo Chocolate Cookies',
      'price': 12000.0,
      'category': 'Snacks',
      'imageUrl':
          'https://images.unsplash.com/photo-1618982446389-0b1015606686',
      'semanticLabel':
          'Blue Oreo cookies package with chocolate sandwich cookies visible',
    },
    {
      'id': 'P004',
      'name': 'Dasani Water 500ml',
      'price': 6000.0,
      'category': 'Beverages',
      'imageUrl':
          'https://images.unsplash.com/photo-1729926677747-1fa3f52c7452',
      'semanticLabel':
          'Clear plastic water bottle with blue Dasani label on white background',
    },
    {
      'id': 'P005',
      'name': 'Vinamilk Fresh Milk 180ml',
      'price': 8000.0,
      'category': 'Dairy',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ba2f9889-1766216508507.png',
      'semanticLabel':
          'White and blue Vinamilk small carton with cow illustration',
    },
    {
      'id': 'P006',
      'name': 'Alpenliebe Strawberry Candy',
      'price': 3000.0,
      'category': 'Candy',
      'imageUrl':
          'https://images.unsplash.com/flagged/photo-1582111301063-df1454cbe739',
      'semanticLabel':
          'Pink Alpenliebe strawberry candy wrapper with swirl design',
    },
    {
      'id': 'P007',
      'name': 'Sandwich Bread Loaf',
      'price': 18000.0,
      'category': 'Bakery',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_13ae50916-1772492791388.png',
      'semanticLabel':
          'White sliced sandwich bread loaf in clear plastic packaging',
    },
    {
      'id': 'P008',
      'name': 'Tiger Beer 330ml',
      'price': 22000.0,
      'category': 'Beverages',
      'imageUrl':
          'https://images.unsplash.com/photo-1608455872025-7bd582b5cbc4',
      'semanticLabel':
          'Green Tiger beer can with orange tiger logo on white background',
    },
    {
      'id': 'P009',
      'name': 'Nissin Cup Noodles',
      'price': 9500.0,
      'category': 'Instant Food',
      'imageUrl':
          'https://images.unsplash.com/photo-1579887210201-f7192a745782',
      'semanticLabel':
          'Red Nissin cup noodles container with lid and fork illustration',
    },
    {
      'id': 'P010',
      'name': 'Poca BBQ Potato Chips',
      'price': 10000.0,
      'category': 'Snacks',
      'imageUrl':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1328588ea-1774256749920.png',
      'semanticLabel':
          'Dark red Poca BBQ potato chips bag with flame graphic and chips',
    },
    {
      'id': 'P011',
      'name': 'C2 Green Tea 500ml',
      'price': 10000.0,
      'category': 'Beverages',
      'imageUrl':
          'https://images.unsplash.com/photo-1654088956224-1312bea6d71d',
      'semanticLabel':
          'Green C2 green tea plastic bottle with leaf design label',
    },
    {
      'id': 'P012',
      'name': 'Vissan Sausage',
      'price': 13000.0,
      'category': 'Processed Meat',
      'imageUrl':
          'https://images.unsplash.com/photo-1695813539445-ea37e701bb41',
      'semanticLabel':
          'Red Vissan sausage individual wrapped stick on white background',
    },
  ];

  late List<ProductItem> _products;
  final List<CartItem> _cartItems = [];
  String _selectedCategory = 'All';
  String _currentTransactionId = '';
  bool _isSubmitting = false;

  static const double _plasticBagPrice = 500.0;
  int _plasticBagCount = 0;

  final List<String> _categories = [
    'All',
    'Beverages',
    'Snacks',
    'Instant Food',
    'Dairy',
    'Bakery',
    'Candy',
    'Processed Meat',
  ];

  @override
  void initState() {
    super.initState();
    _products = _productMaps.map(ProductItem.fromMap).toList();
    _currentTransactionId = _generateTransactionId();
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    return 'TXN${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch % 100000}';
  }

  List<ProductItem> get _filteredProducts {
    if (_selectedCategory == 'All') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  double get _cartSubtotal {
    double total = _cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);
    total += _plasticBagCount * _plasticBagPrice;
    return total;
  }

  int get _totalItemCount {
    int count = _cartItems.fold(0, (sum, item) => sum + item.quantity);
    count += _plasticBagCount;
    return count;
  }

  void _addToCart(ProductItem product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product));
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == productId,
      );
      if (index >= 0) {
        if (_cartItems[index].quantity > 1) {
          _cartItems[index].quantity--;
        } else {
          _cartItems.removeAt(index);
        }
      }
    });
  }

  void _addPlasticBag() {
    setState(() {
      _plasticBagCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Plastic bag added (×$_plasticBagCount) — ${_formatCurrency(_plasticBagPrice)} each',
          style: GoogleFonts.ibmPlexSans(),
        ),
        backgroundColor: AppTheme.bagBtn,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _cancelOrder() {
    if (_cartItems.isEmpty && _plasticBagCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No items in order to cancel.',
            style: GoogleFonts.ibmPlexSans(),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Cancel Order',
          style: GoogleFonts.ibmPlexSans(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel the current order?\nAll $_totalItemCount item(s) will be removed.',
          style: GoogleFonts.ibmPlexSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _cartItems.clear();
                _plasticBagCount = 0;
                _currentTransactionId = _generateTransactionId();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Order cancelled.',
                    style: GoogleFonts.ibmPlexSans(),
                  ),
                  backgroundColor: AppTheme.cancelBtn,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cancelBtn,
            ),
            child: const Text(
              'Cancel Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _checkOrder() {
    if (_cartItems.isEmpty && _plasticBagCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No items in order to check.',
            style: GoogleFonts.ibmPlexSans(),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    _showOrderSummaryDialog();
  }

  void _showOrderSummaryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.checkBtn,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Order Summary',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _currentTransactionId,
                      style: GoogleFonts.ibmPlexMono(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    ..._cartItems.map(
                      (item) => _buildSummaryRow(
                        '${item.product.name} ×${item.quantity}',
                        _formatCurrency(item.lineTotal),
                      ),
                    ),
                    if (_plasticBagCount > 0)
                      _buildSummaryRow(
                        'Plastic Bag ×$_plasticBagCount',
                        _formatCurrency(_plasticBagCount * _plasticBagPrice),
                      ),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      'Total ($_totalItemCount items)',
                      _formatCurrency(_cartSubtotal),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _submitOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.submitBtn,
                        ),
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
                color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.ibmPlexSans(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppTheme.checkBtn : AppTheme.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (_cartItems.isEmpty && _plasticBagCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add items before submitting.',
            style: GoogleFonts.ibmPlexSans(),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO: Replace with real order submission API for production
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      final submittedId = _currentTransactionId;
      final submittedTotal = _cartSubtotal;
      setState(() {
        _isSubmitting = false;
        _cartItems.clear();
        _plasticBagCount = 0;
        _currentTransactionId = _generateTransactionId();
      });
      Navigator.pushNamed(
        context,
        AppRoutes.paymentFlowScreen,
        arguments: {
          'paymentAmount': submittedTotal,
          'transactionId': submittedId,
        },
      );
    }
  }

  String _formatCurrency(double amount) {
    final usd = amount / 25000.0;
    return '\$${usd.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // Top status bar
          PosTopBarWidget(
            transactionId: _currentTransactionId,
            onLogout: () {
              showDialog(
                context: context,
                barrierColor: Colors.black45,
                builder: (ctx) => Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 36,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EOD counting completed',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: 120,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.loginScreen,
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8622A),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Okay',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Main body
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: Cart panel (40%)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: PosCartPanelWidget(
                    cartItems: _cartItems,
                    plasticBagCount: _plasticBagCount,
                    plasticBagPrice: _plasticBagPrice,
                    subtotal: _cartSubtotal,
                    totalItemCount: _totalItemCount,
                    transactionId: _currentTransactionId,
                    formatCurrency: _formatCurrency,
                    onRemove: _removeFromCart,
                    onAdd: (id) {
                      final product = _products.firstWhere((p) => p.id == id);
                      _addToCart(product);
                    },
                  ),
                ),

                // Right: Product grid + actions (60%)
                Expanded(
                  child: Column(
                    children: [
                      // Category filter
                      _buildCategoryFilter(),

                      // Product grid
                      Expanded(
                        child: PosProductGridWidget(
                          products: _filteredProducts,
                          onProductTap: _addToCart,
                          formatCurrency: _formatCurrency,
                        ),
                      ),

                      // Action bar
                      PosActionBarWidget(
                        isSubmitting: _isSubmitting,
                        hasItems: _cartItems.isNotEmpty || _plasticBagCount > 0,
                        onCheckOrder: _checkOrder,
                        onAddPlasticBag: _addPlasticBag,
                        onCancelOrder: _cancelOrder,
                        onSubmitOrder: _submitOrder,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 48,
      color: AppTheme.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : AppTheme.numpadBtn,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                    width: 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
