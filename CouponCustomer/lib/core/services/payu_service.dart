import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

@singleton
class PayUService implements PayUCheckoutProProtocol {
  PayUCheckoutProFlutter? _payU;

  Function(String mihpayid)? onSuccess;
  Function(String error)? onFailure;

  /// Set by the payment controller before [openCheckout].
  /// The SDK calls [generateHash] for dynamic hashes (VPA validation, bin
  /// lookup, etc.); this callback fetches the computed hash from the server
  /// so the merchant salt never lives on the client.
  Future<String> Function(String hashString)? onGenerateHash;

  void initialize(BuildContext context) {
    _payU = PayUCheckoutProFlutter(this);
  }

  void openCheckout(Map<String, dynamic> params) {
    final si = params['si_details'] as Map<String, dynamic>;

    // "0" = Production, "1" = Test
    final envFlag = params['env'] == 'production' ? '0' : '1';

    // PayU SDK requires txnid alphanumeric only, max 25 chars.
    final sanitized =
        (params['txnid']?.toString() ?? '').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final txnid = sanitized.length > 25 ? sanitized.substring(0, 25) : sanitized;

    debugPrint('[PayU] txnid="${params['txnid']}" → sanitized="$txnid"');

    final paymentParams = {
      PayUPaymentParamKey.key:              params['key'],
      PayUPaymentParamKey.amount:           params['amount'],
      PayUPaymentParamKey.productInfo:      params['productinfo'],
      PayUPaymentParamKey.firstName:        params['firstname'],
      PayUPaymentParamKey.email:            params['email'] ?? '',
      PayUPaymentParamKey.phone:            params['phone'],
      PayUPaymentParamKey.transactionId:    txnid,
      PayUPaymentParamKey.environment:      envFlag,
      PayUPaymentParamKey.userCredential:   params['userCredential'] ?? '',
      PayUPaymentParamKey.android_surl:     'https://payu.in/txnstatus',
      PayUPaymentParamKey.android_furl:     'https://payu.in/txnstatus',
      PayUPaymentParamKey.ios_surl:         'https://payu.in/txnstatus',
      PayUPaymentParamKey.ios_furl:         'https://payu.in/txnstatus',
      PayUPaymentParamKey.payUSIParams: {
        PayUSIParamsKeys.isPreAuthTxn:     true,
        PayUSIParamsKeys.billingAmount:    si['billingAmount'] ?? params['amount'],
        PayUSIParamsKeys.billingCycle:
            (si['billingCycle'] as String? ?? 'yearly').toLowerCase(),
        PayUSIParamsKeys.billingInterval:  '${si['billingInterval'] ?? 1}',
        PayUSIParamsKeys.paymentStartDate: si['paymentStartDate'],
        PayUSIParamsKeys.paymentEndDate:   si['paymentEndDate'],
        PayUSIParamsKeys.billingRule:      si['billingRule'] ?? 'MAX',
        PayUSIParamsKeys.billingCurrency:  si['billingCurrency'] ?? 'INR',
        PayUSIParamsKeys.remarks:          si['remarks'] ?? 'CouponApp Subscription',
      },
    };

    final checkoutConfig = {
      PayUCheckoutProConfigKeys.merchantName:
          'CouponApp',
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen:  true,
      // Allow up to 10 s for the server hash callback to respond.
      // Default SDK timeout is very short; Render.com cold-starts can exceed it.
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 10,
    };

    _payU?.openCheckoutScreen(
      payUPaymentParams: paymentParams,
      payUCheckoutProConfig: checkoutConfig,
    );
  }

  // ── PayUCheckoutProProtocol ────────────────────────────────────────────────

  @override
  void generateHash(Map response) async {
    final hashName   = response[PayUHashConstantsKeys.hashName]   as String? ?? '';
    final hashString = response[PayUHashConstantsKeys.hashString] as String? ?? '';

    String computed = '';
    if (onGenerateHash != null) {
      try {
        computed = await onGenerateHash!(hashString);
      } catch (e) {
        debugPrint('[PayU] generateHash error: $e');
      }
    } else {
      debugPrint('[PayU] generateHash called but onGenerateHash is not set');
    }

    _payU?.hashGenerated(hash: {
      PayUHashConstantsKeys.hashName:   hashName,
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
        (response is Map ? response[PayUConstants.errorMsg] : null)?.toString() ??
            'Payment failed';
    onFailure?.call(msg);
  }

  @override
  void onPaymentCancel(Map? response) {
    onFailure?.call('Payment cancelled by user');
  }

  @override
  void onError(Map? response) {
    final msg = response?[PayUConstants.errorMsg]?.toString() ??
        'An unknown payment error occurred';
    onFailure?.call(msg);
  }
}
