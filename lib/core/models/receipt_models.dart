class ReceiptLineItem {
  final String name;
  final int quantity;
  final double unitPrice;

  const ReceiptLineItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

class ReceiptData {
  final String transactionId;
  final double subtotalAmount;
  final double discountAmount;
  final double totalAmount;
  final int totalItemCount;
  final DateTime submittedAt;
  final List<ReceiptLineItem> items;
  final String? couponCode;
  final String? cardType;
  final String? cardBrand;
  final String? lastFourDigits;
  final String? approvedCode;

  const ReceiptData({
    required this.transactionId,
    required this.subtotalAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.totalItemCount,
    required this.submittedAt,
    required this.items,
    this.couponCode,
    this.cardType,
    this.cardBrand,
    this.lastFourDigits,
    this.approvedCode,
  });

  ReceiptData copyWith({
    String? transactionId,
    double? subtotalAmount,
    double? discountAmount,
    double? totalAmount,
    int? totalItemCount,
    DateTime? submittedAt,
    List<ReceiptLineItem>? items,
    String? couponCode,
    String? cardType,
    String? cardBrand,
    String? lastFourDigits,
    String? approvedCode,
  }) {
    return ReceiptData(
      transactionId: transactionId ?? this.transactionId,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      totalItemCount: totalItemCount ?? this.totalItemCount,
      submittedAt: submittedAt ?? this.submittedAt,
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      cardType: cardType ?? this.cardType,
      cardBrand: cardBrand ?? this.cardBrand,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      approvedCode: approvedCode ?? this.approvedCode,
    );
  }
}
