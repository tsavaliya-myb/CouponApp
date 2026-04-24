import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

@singleton
class PayUService implements PayUCheckoutProProtocol {
  PayUCheckoutProFlutter? _payU;

  /// Called with the `mihpayid` string on a successful payment / mandate.
  Function(String mihpayid)? onSuccess;

  /// Called with a human-readable error string on failure or cancellation.
  Function(String error)? onFailure;

  /// Called by [generateHash] to fetch the computed hash from the server.
  /// Receives the raw hashString from the PayU SDK; must return the SHA-512
  /// hash or an empty string on error.
  Future<String> Function(String hashString)? onGenerateHash;

  void initialize(BuildContext context) {
    _payU = PayUCheckoutProFlutter(this);
  }

  void openCheckout(Map<String, dynamic> params) {
    final si = params['si_details'] as Map<String, dynamic>;

    // "0" = Production, "1" = Test (PayU v1.x SDK convention)
    final envFlag = params['env'] == 'production' ? '0' : '1';

    // PayU native SDK requires txnid to be alphanumeric only, max 25 chars.
    final sanitized =
        (params['txnid']?.toString() ?? '').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final txnid = sanitized.length > 25 ? sanitized.substring(0, 25) : sanitized;
    debugPrint(
        '[PayU] txnid raw="${params['txnid']}" sanitized="$txnid" params=$params');

    final paymentParams = {
      PayUPaymentParamKey.key: params['key'],
      PayUPaymentParamKey.amount: params['amount'],
      PayUPaymentParamKey.productInfo: params['productinfo'],
      PayUPaymentParamKey.firstName: params['firstname'],
      PayUPaymentParamKey.email: params['email'] ?? '',
      PayUPaymentParamKey.phone: params['phone'],
      PayUPaymentParamKey.transactionId: txnid,
      PayUPaymentParamKey.environment: envFlag,
      PayUPaymentParamKey.android_surl: 'https://payu.in/txnstatus',
      PayUPaymentParamKey.android_furl: 'https://payu.in/txnstatus',
      PayUPaymentParamKey.ios_surl: 'https://payu.in/txnstatus',
      PayUPaymentParamKey.ios_furl: 'https://payu.in/txnstatus',
      PayUPaymentParamKey.payUSIParams: {
        PayUSIParamsKeys.isPreAuthTxn: false,
        PayUSIParamsKeys.billingAmount: si['billingAmount'] ?? params['amount'],
        PayUSIParamsKeys.billingInterval: '1',
        PayUSIParamsKeys.paymentStartDate: si['mandateStartDate'],
        PayUSIParamsKeys.paymentEndDate: si['mandateEndDate'],
        // Use the billing cycle from the server (YEARLY / MONTHLY / etc.).
        PayUSIParamsKeys.billingCycle:
            (si['billingCycle'] as String? ?? 'YEARLY').toUpperCase(),
        PayUSIParamsKeys.billingRule:
            (si['billingRule'] as String? ?? 'MAX').toUpperCase(),
        PayUSIParamsKeys.remarks:
            si['remarks'] ?? 'CouponApp Subscription',
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

  @override
  void generateHash(Map response) async {
    final hashName =
        response[PayUHashConstantsKeys.hashName] as String? ?? '';
    final hashString =
        response[PayUHashConstantsKeys.hashString] as String? ?? '';

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
