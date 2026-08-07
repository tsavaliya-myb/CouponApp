import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/services/razorpay_service.dart';
import '../../../core/error/failures.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../data/payment_repository.dart';

/// Drives the Razorpay UPI Autopay purchase flow.
///
/// State is `AsyncLoading` while Checkout is open, `AsyncData(null)` on
/// success, and `AsyncError` on failure / cancellation.
class PaymentController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Release the Checkout SDK's method-channel listeners when this
    // controller (and the screen that watches it) goes away.
    ref.onDispose(() => GetIt.I<RazorpayService>().dispose());
  }

  /// Initiates the Razorpay UPI Autopay flow.
  ///
  /// 1. Calls the backend to get an order + Checkout params.
  /// 2. Opens Razorpay Checkout in recurring mode.
  /// 3. On success, verifies the signature (optimistic fulfilment), then
  ///    polls the profile until the subscription turns ACTIVE — the S2S
  ///    webhook is the actual source of truth and may still be in flight.
  Future<void> startPaymentFlow() async {
    state = const AsyncLoading();
    try {
      final repository = GetIt.I<PaymentRepository>();
      final razorpayService = GetIt.I<RazorpayService>();

      // Step 1 — fetch Razorpay order + Checkout params from backend
      final result = await repository.initiatePayment();
      final params = result.fold(
        (failure) => throw failure,
        (p) => p,
      );

      // Step 2 — wire callbacks before opening checkout
      razorpayService.initialize();

      razorpayService.onSuccess = (PaymentSuccessResponse response) async {
        final orderId = response.orderId ?? '';
        final paymentId = response.paymentId ?? '';
        final signature = response.signature ?? '';

        if (orderId.isEmpty || paymentId.isEmpty || signature.isEmpty) {
          debugPrint('[Payment] success callback missing order/payment/signature');
        } else {
          final verifyResult = await repository.verifyPayment(
            orderId: orderId,
            paymentId: paymentId,
            signature: signature,
          );
          verifyResult.fold(
            (failure) => debugPrint('[Payment] verify failed: ${failure.message}'),
            (status) => debugPrint('[Payment] verify status: $status'),
          );
        }

        // Poll the profile up to 5 times (2s apart) until it turns ACTIVE,
        // so a slightly slow webhook doesn't leave the UI stuck.
        for (var i = 0; i < 5; i++) {
          await Future.delayed(const Duration(seconds: 2));
          ref.invalidate(profileProvider);
          try {
            final profile = await ref.read(profileProvider.future);
            if (profile.subscriptionStatus == 'ACTIVE') break;
          } catch (_) {
            // profile fetch failed — keep polling
          }
        }
        state = const AsyncData(null);
      };

      razorpayService.onFailure = (err) {
        state = AsyncError(err, StackTrace.current);
      };

      // Step 3 — open checkout (non-blocking; result via callbacks above)
      razorpayService.openCheckout(params);
    } on Failure catch (f, stack) {
      state = AsyncError(f.message, stack);
    } catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }
}

final paymentControllerProvider =
    AutoDisposeAsyncNotifierProvider<PaymentController, void>(
  PaymentController.new,
);
