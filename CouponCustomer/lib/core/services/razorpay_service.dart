import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

@singleton
class RazorpayService {
  Razorpay? _razorpay;

  Function(PaymentSuccessResponse response)? onSuccess;
  Function(String message)? onFailure;

  void initialize() {
    // Defensive: a leftover instance from a previous attempt in the same
    // session would otherwise fire duplicate success/failure callbacks.
    _razorpay?.clear();
    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handleError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// [params] is the response of POST /payments/initiate:
  /// { keyId, orderId, customerId, amount (paise), currency, name,
  ///   description, recurring: '1', prefill: {name, email, contact} }
  void openCheckout(Map<String, dynamic> params) {
    final prefill = params['prefill'] as Map<String, dynamic>? ?? {};

    final options = {
      'key':         params['keyId'],
      'order_id':    params['orderId'],
      'customer_id': params['customerId'],
      'recurring':   params['recurring'] ?? '1',
      'amount':      params['amount'],
      'currency':    params['currency'] ?? 'INR',
      'name':        params['name'],
      'description': params['description'],
      'prefill': {
        'name':    prefill['name'] ?? '',
        'email':   prefill['email'] ?? '',
        'contact': prefill['contact'] ?? '',
      },
      'retry': {'enabled': true, 'max_count': 1},
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('[Razorpay] open() threw: $e');
      onFailure?.call('Could not open payment screen');
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    onSuccess?.call(response);
  }

  void _handleError(PaymentFailureResponse response) {
    onFailure?.call(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Not used — Checkout is configured for UPI Autopay only.
  }

  /// Must be called when the owning controller/screen is disposed, or the
  /// plugin's method-channel listeners leak into the next attempt.
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
