import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/receipt_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class PaymentFlowScreen extends StatefulWidget {
  final double paymentAmount;
  final String transactionId;
  final ReceiptData? receiptData;

  const PaymentFlowScreen({
    super.key,
    required this.paymentAmount,
    required this.transactionId,
    this.receiptData,
  });

  @override
  State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

enum _PaymentStep { cardType, cardBrand, enterCard }

class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
  _PaymentStep _step = _PaymentStep.cardType;
  String _cardType = '';
  String _cardBrand = '';
  String _lastFour = '';

  static const String _correctLastFour = '1234';
  static const String _approvedCode = '123456';
  static const String _tid = '1234567890123456';
  static const String _mid = '1234567890123456';

  bool get _isApproved => _lastFour == _correctLastFour;

  String _formatCurrency(double amount) {
    final usd = amount / 25000;
    return '\$${usd.toStringAsFixed(2)}';
  }

  void _onNumpadTap(String value) {
    if (_lastFour.length >= 4) return;
    setState(() {
      _lastFour += value;
    });
  }

  void _onBackspace() {
    if (_lastFour.isEmpty) return;
    setState(() {
      _lastFour = _lastFour.substring(0, _lastFour.length - 1);
    });
  }

  void _onBack() {
    if (_step == _PaymentStep.cardType) {
      Navigator.pop(context);
    } else if (_step == _PaymentStep.cardBrand) {
      setState(() {
        _step = _PaymentStep.cardType;
        _cardType = '';
      });
    } else {
      setState(() {
        _step = _PaymentStep.cardBrand;
        _cardBrand = '';
        _lastFour = '';
      });
    }
  }

  void _onConfirm() {
    if (_step == _PaymentStep.cardType && _cardType.isNotEmpty) {
      setState(() => _step = _PaymentStep.cardBrand);
    } else if (_step == _PaymentStep.cardBrand && _cardBrand.isNotEmpty) {
      setState(() => _step = _PaymentStep.enterCard);
    } else if (_step == _PaymentStep.enterCard && _isApproved) {
      _showTransactionComplete();
    }
  }

  void _showTransactionComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.success.withAlpha(31),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 40,
                color: AppTheme.success,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Transaction Complete!',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.transactionId,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatCurrency(widget.paymentAmount),
              style: GoogleFonts.ibmPlexSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.success,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$_cardBrand $_cardType — ****$_lastFour',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                  ),
                  child: const Text(
                    'New Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.receiptScreen,
                      arguments: widget.receiptData?.copyWith(
                        cardType: _cardType,
                        cardBrand: _cardBrand,
                        lastFourDigits: _lastFour,
                        approvedCode: _approvedCode,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                  ),
                  child: const Text(
                    'View Receipt',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildLeftPanel()),
                if (_step == _PaymentStep.enterCard) _buildRightPanel(),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 48,
      color: AppTheme.statusBar,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'PAYMENT',
            style: GoogleFonts.ibmPlexSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            widget.transactionId,
            style: GoogleFonts.ibmPlexMono(color: Colors.white60, fontSize: 12),
          ),
          const Spacer(),
          _buildStepIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Card Type', 'Card Brand', 'Payment'];
    final currentIndex = _step.index;
    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i == currentIndex;
        final isDone = i < currentIndex;
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDone
                    ? AppTheme.success
                    : isActive
                    ? AppTheme.submitBtn
                    : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                steps[i],
                style: GoogleFonts.ibmPlexSans(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            if (i < steps.length - 1)
              Container(
                width: 16,
                height: 1,
                color: Colors.white30,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppTheme.statusBar,
            child: Row(
              children: [
                _buildSummaryItem(
                  'Total',
                  _formatCurrency(widget.paymentAmount),
                  Colors.white,
                ),
                const SizedBox(width: 32),
                _buildSummaryItem('Paid', _formatCurrency(0), Colors.white),
                const SizedBox(width: 32),
                _buildSummaryItem(
                  'To Be Paid',
                  _formatCurrency(widget.paymentAmount),
                  AppTheme.submitBtn,
                ),
                const SizedBox(width: 32),
                _buildSummaryItem(
                  'Change',
                  _formatCurrency(0),
                  AppTheme.submitBtn,
                ),
              ],
            ),
          ),
          Expanded(child: _buildStepContent()),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.ibmPlexSans(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case _PaymentStep.cardType:
        return _buildCardTypeStep();
      case _PaymentStep.cardBrand:
        return _buildCardBrandStep();
      case _PaymentStep.enterCard:
        return _buildEnterCardStep();
    }
  }

  Widget _buildCardTypeStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Payment Type',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSelectCard(
                label: 'Credit',
                icon: Icons.credit_card_rounded,
                isSelected: _cardType == 'Credit',
                onTap: () => setState(() => _cardType = 'Credit'),
              ),
              const SizedBox(width: 24),
              _buildSelectCard(
                label: 'Debit',
                icon: Icons.account_balance_wallet_rounded,
                isSelected: _cardType == 'Debit',
                onTap: () => setState(() => _cardType = 'Debit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Card Brand',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _cardType,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSelectCard(
                label: 'VISA',
                icon: Icons.credit_score_rounded,
                isSelected: _cardBrand == 'VISA',
                onTap: () => setState(() => _cardBrand = 'VISA'),
                accentColor: const Color(0xFF1A1F71),
              ),
              const SizedBox(width: 24),
              _buildSelectCard(
                label: 'MASTER',
                icon: Icons.blur_circular_rounded,
                isSelected: _cardBrand == 'MASTER',
                onTap: () => setState(() => _cardBrand = 'MASTER'),
                accentColor: const Color(0xFFEB001B),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnterCardStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_cardBrand ($_cardType)',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.statusBar,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoField(
            label: 'Payment Amount',
            value: _formatCurrency(widget.paymentAmount),
            highlight: true,
          ),
          const SizedBox(height: 10),
          _buildInfoField(
            label: 'Card No.',
            value: _lastFour.isEmpty ? '—' : '****$_lastFour',
          ),
          if (_isApproved) ...[
            const SizedBox(height: 10),
            _buildInfoField(label: 'Approved Code', value: _approvedCode),
            const SizedBox(height: 10),
            _buildInfoField(label: 'TID', value: _tid),
            const SizedBox(height: 10),
            _buildInfoField(label: 'MID', value: _mid),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.primary.withAlpha(15) : Colors.white,
        border: Border.all(
          color: highlight ? AppTheme.primary : AppTheme.cardBorder,
          width: highlight ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.ibmPlexMono(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: highlight ? AppTheme.primary : AppTheme.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color? accentColor,
  }) {
    final color = accentColor ?? AppTheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 160,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(20) : Colors.white,
          border: Border.all(
            color: isSelected ? color : AppTheme.cardBorder,
            width: isSelected ? 2.5 : 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? color : AppTheme.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 220,
      color: const Color(0xFFF5F7FF),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildNumpad()],
      ),
    );
  }

  Widget _buildNumpad() {
    final keys = [
      ['7', '8', '9'],
      ['4', '5', '6'],
      ['1', '2', '3'],
      ['.', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              final isBackspace = key == '⌫';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _NumpadKey(
                    label: key,
                    isBackspace: isBackspace,
                    onTap: () {
                      if (isBackspace) {
                        _onBackspace();
                      } else if (key != '.') {
                        _onNumpadTap(key);
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    bool canConfirm = false;
    if (_step == _PaymentStep.cardType) canConfirm = _cardType.isNotEmpty;
    if (_step == _PaymentStep.cardBrand) canConfirm = _cardBrand.isNotEmpty;
    if (_step == _PaymentStep.enterCard) canConfirm = _isApproved;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.divider)),
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
            child: _BottomButton(
              label: 'Back',
              color: AppTheme.primary,
              onTap: _onBack,
              isEnabled: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _BottomButton(
              label: 'Confirm',
              color: AppTheme.submitBtn,
              onTap: canConfirm ? _onConfirm : null,
              isEnabled: canConfirm,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumpadKey extends StatefulWidget {
  final String label;
  final bool isBackspace;
  final VoidCallback onTap;

  const _NumpadKey({
    required this.label,
    required this.isBackspace,
    required this.onTap,
  });

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: widget.isBackspace
                ? AppTheme.cancelBtn.withAlpha(20)
                : AppTheme.numpadBtn,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isBackspace
                  ? AppTheme.cancelBtn.withAlpha(60)
                  : AppTheme.cardBorder,
            ),
          ),
          alignment: Alignment.center,
          child: widget.isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  size: 20,
                  color: AppTheme.cancelBtn,
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _BottomButton({
    required this.label,
    required this.color,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isEnabled ? color : color.withAlpha(100);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
