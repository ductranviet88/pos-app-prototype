import 'package:flutter/material.dart';

import '../core/models/receipt_models.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/main_pos_screen/main_pos_screen.dart';
import '../presentation/payment_flow_screen/payment_flow_screen.dart';
import '../presentation/receipt_screen/receipt_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String mainPosScreen = '/main-pos-screen';
  static const String paymentFlowScreen = '/payment-flow-screen';
  static const String receiptScreen = '/receipt-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    mainPosScreen: (context) => const MainPosScreen(),
    paymentFlowScreen: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return PaymentFlowScreen(
        paymentAmount: (args?['paymentAmount'] as num?)?.toDouble() ?? 0.0,
        transactionId: args?['transactionId'] as String? ?? '',
        receiptData: args?['receiptData'] as ReceiptData?,
      );
    },
    receiptScreen: (context) {
      final receiptData =
          ModalRoute.of(context)!.settings.arguments as ReceiptData?;
      return ReceiptScreen(
        receiptData:
            receiptData ??
            ReceiptData(
              transactionId: '',
              subtotalAmount: 0,
              discountAmount: 0,
              totalAmount: 0,
              totalItemCount: 0,
              submittedAt: DateTime.now(),
              items: const [],
            ),
      );
    },
  };
}
