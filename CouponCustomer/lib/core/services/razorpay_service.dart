import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

@singleton
class RazorpayService {
  late final Razorpay _razorpay;
  Completer<String>? _paymentCompleter;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.complete(response.paymentId ?? 'SUCCESS');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
      _paymentCompleter!.completeError(response.message ?? 'Payment failed');
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_paymentCompleter != null && !_paymentCompleter!.isCompleted) {
       _paymentCompleter!.completeError('External Wallet Selected: ${response.walletName}');
    }
  }

  Future<String> openCheckout({
    required String keyId,
    required String orderId,
    required num amount,
    required String contact,
    required String email,
  }) {
    _paymentCompleter = Completer<String>();
    
    var options = {
      'key': keyId,
      'amount': amount,
      'name': 'CouponApp Premium',
      'order_id': orderId,
      'prefill': {
        'contact': contact,
        'email': email,
      }
    };
    
    try {
      _razorpay.open(options);
    } catch (e) {
      _paymentCompleter!.completeError(e.toString());
    }
    
    return _paymentCompleter!.future;
  }

  @disposeMethod
  void dispose() {
    _razorpay.clear();
  }
}
