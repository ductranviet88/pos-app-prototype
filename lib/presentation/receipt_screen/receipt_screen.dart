import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/models/receipt_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final ReceiptData receiptData;

  const ReceiptScreen({super.key, required this.receiptData});

  static const String _storeName = 'MangoTill Convenience';
  static const String _storeAddress = '96 San Hong Street, Sheung Shui, N.T.';
  static const String _storePhone = 'Hotline: 1900 1234';
  static const String _cashierName = 'Cashier 01';
  static const String _vatNumber = 'VAT Reg: MT-8472-51';
  static const String _terminalId = 'TERM 03';

  String _formatCurrency(double amount) {
    final usd = amount / 25000;
    return '\$${usd.toStringAsFixed(2)}';
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute:$second';
  }

  String _buildPaymentLabel() {
    final brand = receiptData.cardBrand;
    final type = receiptData.cardType;
    final lastFour = receiptData.lastFourDigits;

    if (brand == null || type == null || lastFour == null) {
      return 'CARD';
    }

    return '$brand $type ****$lastFour';
  }

  void _finishFlow(BuildContext context, {bool shouldPrint = false}) {
    if (shouldPrint) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Printing receipt for ${receiptData.transactionId}...',
            style: GoogleFonts.ibmPlexSans(),
          ),
          backgroundColor: AppTheme.checkBtn,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.mainPosScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF8),
      appBar: AppBar(
        backgroundColor: AppTheme.statusBar,
        foregroundColor: Colors.white,
        title: Text(
          'Receipt Preview',
          style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(18),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _ReceiptLogoMark(),
                            const SizedBox(height: 10),
                            Text(
                              _storeName,
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _storeAddress,
                              style: GoogleFonts.ibmPlexMono(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _storePhone,
                              style: GoogleFonts.ibmPlexMono(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _vatNumber,
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            const _ReceiptDivider(),
                            const SizedBox(height: 10),
                            _ReceiptInfoRow(
                              label: 'Receipt No',
                              value: receiptData.transactionId,
                            ),
                            _ReceiptInfoRow(
                              label: '日期',
                              value: _formatDateTime(receiptData.submittedAt),
                            ),
                            const _ReceiptInfoRow(
                              label: '終端機',
                              value: _terminalId,
                            ),
                            const _ReceiptInfoRow(
                              label: 'Cashier',
                              value: _cashierName,
                            ),
                            _ReceiptInfoRow(
                              label: 'Payment',
                              value: _buildPaymentLabel(),
                            ),
                            if (receiptData.approvedCode != null)
                              _ReceiptInfoRow(
                                label: 'Approved',
                                value: receiptData.approvedCode!,
                              ),
                            const SizedBox(height: 12),
                            const _ReceiptDottedCutLine(),
                            const SizedBox(height: 10),
                            const _ReceiptInfoRow(
                              label: 'SKU',
                              value: 'QTY  PRICE   AMOUNT',
                              dense: true,
                            ),
                            const SizedBox(height: 8),
                            ...receiptData.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${item.quantity.toString().padLeft(2, ' ')}  '
                                            '${_formatCurrency(item.unitPrice).padLeft(6, ' ')}',
                                            style: GoogleFonts.ibmPlexMono(
                                              fontSize: 11,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatCurrency(item.lineTotal),
                                          style: GoogleFonts.ibmPlexMono(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const _ReceiptDivider(),
                            const SizedBox(height: 10),
                            _ReceiptInfoRow(
                              label: 'Sub Total',
                              value: _formatCurrency(receiptData.subtotalAmount),
                            ),
                            if (receiptData.discountAmount > 0)
                              _ReceiptInfoRow(
                                label: 'Coupon ${receiptData.couponCode ?? ''}',
                                value:
                                    '-${_formatCurrency(receiptData.discountAmount)}',
                                valueColor: AppTheme.success,
                              ),
                            _ReceiptInfoRow(
                              label: 'Items',
                              value: '${receiptData.totalItemCount}',
                              isBold: true,
                            ),
                            _ReceiptInfoRow(
                              label: 'TOTAL',
                              value: _formatCurrency(receiptData.totalAmount),
                              isBold: true,
                              valueColor: AppTheme.success,
                            ),
                            const SizedBox(height: 14),
                            const _ReceiptMetaBlock(),
                            const SizedBox(height: 12),
                            const _ReceiptDottedCutLine(),
                            const SizedBox(height: 14),
                            Text(
                              'THANK YOU',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please come again for your next purchase.',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '--- customer copy ---',
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 10,
                                color: AppTheme.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _finishFlow(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppTheme.cardBorder),
                        ),
                        child: Text(
                          'No Print Receipt',
                          style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _finishFlow(
                          context,
                          shouldPrint: true,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.submitBtn,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Print Receipt',
                          style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
}

class _ReceiptDivider extends StatelessWidget {
  const _ReceiptDivider();

  @override
  Widget build(BuildContext context) {
    return Text(
      '----------------------------------------',
      style: GoogleFonts.ibmPlexMono(
        fontSize: 12,
        color: AppTheme.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ReceiptInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool dense;
  final Color? valueColor;

  const _ReceiptInfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.dense = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final fontWeight = isBold ? FontWeight.w700 : FontWeight.w500;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 1.5 : 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.ibmPlexMono(
                fontSize: dense ? 11 : 12,
                fontWeight: fontWeight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.ibmPlexMono(
                fontSize: dense ? 11 : 12,
                fontWeight: fontWeight,
                color: valueColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptLogoMark extends StatelessWidget {
  const _ReceiptLogoMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.statusBar,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 7,
              child: Container(
                width: 24,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Positioned(
              bottom: 9,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.submitBtn,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptDottedCutLine extends StatelessWidget {
  const _ReceiptDottedCutLine();

  @override
  Widget build(BuildContext context) {
    return Text(
      '. . . . . . . . . . . . . . . . . . . .',
      style: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        color: AppTheme.textMuted,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _ReceiptMetaBlock extends StatelessWidget {
  const _ReceiptMetaBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        children: [
          Text(
            'VAT INCLUDED IN PRICES',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Cashier verified transaction and customer copy issued.',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
