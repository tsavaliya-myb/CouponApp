import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Wraps the PayU CheckoutPro Flutter SDK (v1.4.x) for UPI Autopay
/// (Standing Instructions / SI mandate).
///
/// Usage in a controller:
///   1. `initialize(context)` — must be called with a live [BuildContext].
///   2. Set [onSuccess] and [onFailure] callbacks.
///   3. `openCheckout(params)` — params = map from `POST /payments/initiate`.
@singleton
class PayUService implements PayUCheckoutProProtocol {
  PayUCheckoutProFlutter? _payU;

  // Cached for hash generation callback
  String _salt = '';
  String _key = '';

  /// Called with the `mihpayid` string on a successful payment / mandate.
  Function(String mihpayid)? onSuccess;

  /// Called with a human-readable error string on failure or cancellation.
  Function(String error)? onFailure;

  /// Initialises the SDK channel listener. Must be called before [openCheckout].
  void initialize(BuildContext context) {
    _payU = PayUCheckoutProFlutter(this);
  }

  /// Opens the PayU CheckoutPro screen with UPI Autopay (SI) params.
  ///
  /// [params] is the map returned by `POST /api/v1/payments/initiate`:
  /// ```json
  /// {
  ///   "key": "...", "txnid": "...", "amount": "999.00",
  ///   "productinfo": "CouponApp Premium",
  ///   "firstname": "...", "email": "...", "phone": "...",
  ///   "env": "test",
  ///   "si_details": {
  ///     "mandateStartDate": "YYYY-MM-DD",
  ///     "mandateEndDate":   "YYYY-MM-DD"
  ///   }
  /// }
  /// ```
  ///
  /// Note: The SDK handles hash generation via the [generateHash] callback.
  void openCheckout(Map<String, dynamic> params) {
    _key = params['key'] as String;
    _salt = params['salt'] as String? ?? '';

    final si = params['si_details'] as Map<String, dynamic>;

    // "0" = Production, "1" = Test (PayU v1.x SDK convention)
    final envFlag = params['env'] == 'production' ? '0' : '1';

    final paymentParams = {
      PayUPaymentParamKey.key: _key,
      PayUPaymentParamKey.amount: params['amount'],
      PayUPaymentParamKey.productInfo: params['productinfo'],
      PayUPaymentParamKey.firstName: params['firstname'],
      PayUPaymentParamKey.email: params['email'],
      PayUPaymentParamKey.phone: params['phone'],
      PayUPaymentParamKey.transactionId: params['txnid'],
      PayUPaymentParamKey.environment: envFlag,
      PayUPaymentParamKey.payUSIParams: {
        PayUSIParamsKeys.isPreAuthTxn: true,
        PayUSIParamsKeys.billingAmount: params['amount'],
        PayUSIParamsKeys.billingInterval: '1',
        PayUSIParamsKeys.paymentStartDate: si['mandateStartDate'],
        PayUSIParamsKeys.paymentEndDate: si['mandateEndDate'],
        PayUSIParamsKeys.billingCycle: 'monthly',
        PayUSIParamsKeys.billingRule: 'MAX',
        PayUSIParamsKeys.remarks: 'CouponApp Monthly Subscription',
      },
    };

    final checkoutConfig = {
      PayUCheckoutProConfigKeys.merchantName: 'CouponApp',
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
    };

    _payU?.openCheckoutScreen(
      payUPaymentParams: paymentParams,
      payUCheckoutProConfig: checkoutConfig,
    );
  }

  // ── PayUCheckoutProProtocol ────────────────────────────────────────────────

  /// The SDK calls this when it needs a hash. We compute it synchronously and
  /// feed it back via [_payU?.hashGenerated].
  @override
  generateHash(Map response) {
    final hashName = response[PayUHashConstantsKeys.hashName] as String? ?? '';
    final hashString =
        response[PayUHashConstantsKeys.hashString] as String? ?? '';
    final hashVersion =
        response[PayUHashConstantsKeys.hashType] as String? ?? '';

    String computed;
    if (hashVersion == PayUHashConstantsKeys.hashVersionV2) {
      // V2: hmac-sha256 using merchant salt as key
      final hmac = Hmac(sha256, utf8.encode(_salt));
      computed = hmac.convert(utf8.encode(hashString)).toString();
    } else {
      // V1 (default): sha512(hashString + "|" + salt)
      final input = '$hashString|$_salt';
      computed = sha512.convert(utf8.encode(input)).toString();
    }

    _payU?.hashGenerated(hash: {
      PayUHashConstantsKeys.hashName: hashName,
      PayUHashConstantsKeys.hashString: computed,
    });
  }

  @override
  void onPaymentSuccess(dynamic response) {
    final mihpayid =
        (response is Map ? response['mihpayid'] : null)?.toString() ?? '';
    onSuccess?.call(mihpayid);
  }

  @override
  void onPaymentFailure(dynamic response) {
    final msg =
        (response is Map ? response[PayUConstants.errorMsg] : null)
            ?.toString() ??
            'Payment failed';
    onFailure?.call(msg);
  }

  @override
  void onPaymentCancel(Map? response) {
    onFailure?.call('Payment cancelled by user');
  }

  @override
  void onError(Map? response) {
    final msg =
        response?[PayUConstants.errorMsg]?.toString() ??
            'An unknown payment error occurred';
    onFailure?.call(msg);
  }
}
