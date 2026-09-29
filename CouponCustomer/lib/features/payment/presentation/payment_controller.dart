import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/services/razorpay_service.dart';
import '../../../core/error/failures.dart';
import '../../home/presentation/providers/home_provider.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../../subscription/presentation/my_subscriptions_screen.dart';
import '../data/payment_repository.dart';

/// Drives the Razorpay UPI Autopay purchase flow.
///
/// State is `AsyncLoading` while Checkout is open, `AsyncData(null)` on
/// success, and `AsyncError` on failure / cancellation.
class PaymentController extends AutoDisposeAsyncNotifier<void> {
  /// keepAlive link held while the Razorpay Checkout is open.
  /// Without this the AutoDispose mechanism destroys the provider (and clears
  /// the SDK callbacks) the moment the user app-switches to their UPI app —
  /// the success/failure response from the UPI app would then be silently lost.
  KeepAliveLink? _keepAliveLink;

  @override
  FutureOr<void> build() {
    ref.onDispose(() {
      // Only release the SDK when we are not in the middle of a checkout.
      // _keepAliveLink?.close() is the signal that checkout has concluded.
      GetIt.I<RazorpayService>().dispose();
    });
  }

  /// Initiates the Razorpay UPI Autopay flow.
  ///
  /// 1. Calls the backend to get an order + Checkout params.
  /// 2. Opens Razorpay Checkout in recurring mode.
  /// 3. On success, verifies the signature, then polls the profile until the
  ///    subscription turns ACTIVE — the S2S webhook is the source of truth.
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

      // KEY FIX: Pin the provider alive while checkout is open so AutoDispose
      // doesn't destroy our callbacks when the user switches to the UPI app.
      _keepAliveLink = ref.keepAlive();

      razorpayService.onSuccess = (PaymentSuccessResponse response) async {
        final orderId   = response.orderId   ?? '';
        final paymentId = response.paymentId ?? '';
        final signature = response.signature ?? '';

        if (orderId.isEmpty || paymentId.isEmpty || signature.isEmpty) {
          debugPrint('[Payment] success callback missing order/payment/signature');
        } else {
          final verifyResult = await repository.verifyPayment(
            orderId:   orderId,
            paymentId: paymentId,
            signature: signature,
          );
          verifyResult.fold(
            (failure) => debugPrint('[Payment] verify failed: ${failure.message}'),
            (status)  => debugPrint('[Payment] verify status: $status'),
          );
        }

        // KEY FIX: Poll for longer — UPI capture can take 30–60s after the SDK
        // fires onSuccess (mandate registration ≠ payment capture).
        // Poll 15 × 3s = 45s before giving up.
        bool activated = false;
        for (var i = 0; i < 15; i++) {
          await Future.delayed(const Duration(seconds: 3));
          ref.invalidate(profileProvider);
          try {
            final profile = await ref.read(profileProvider.future);
            if (profile.subscriptionStatus == 'ACTIVE') {
              activated = true;
              break;
            }
          } catch (_) {
            // profile fetch failed — keep polling
          }
        }

        // Purchase changes what every user-scoped screen should show — drop
        // keepAlive providers so they refetch on next read.
        _invalidateSubscriptionScopedProviders();

        // Release the keepAlive pin now that checkout has fully concluded.
        _keepAliveLink?.close();
        _keepAliveLink = null;

        if (activated) {
          state = const AsyncData(null);
        } else {
          // KEY FIX: Show "processing" instead of navigating to success when the
          // subscription isn't ACTIVE yet — webhook may still be in flight.
          // The user sees a clear message and can check back, rather than a
          // confusing success screen with a still-inactive subscription.
          state = AsyncError(
            'Your payment is being processed. Your subscription will activate within a few minutes. '
            'If not, please contact support.',
            StackTrace.current,
          );
        }
      };

      razorpayService.onFailure = (err) {
        // Release the keepAlive pin on failure too.
        _keepAliveLink?.close();
        _keepAliveLink = null;
        state = AsyncError(err, StackTrace.current);
      };

      // Step 3 — open checkout (non-blocking; result via callbacks above)
      razorpayService.openCheckout(params);
    } on Failure catch (f, stack) {
      _keepAliveLink?.close();
      _keepAliveLink = null;
      state = AsyncError(f.message, stack);
    } catch (e, stack) {
      _keepAliveLink?.close();
      _keepAliveLink = null;
      state = AsyncError(e.toString(), stack);
    }
  }

  /// Drops the keepAlive providers whose contents depend on subscription
  /// status, so post-purchase screens don't render pre-purchase data.
  void _invalidateSubscriptionScopedProviders() {
    ref.invalidate(profileProvider);
    ref.invalidate(userSettingsProvider);
    ref.invalidate(mySubscriptionsProvider);
    ref.invalidate(allCouponsProvider);
    ref.invalidate(allSellersProvider);
  }
}

final paymentControllerProvider =
    AutoDisposeAsyncNotifierProvider<PaymentController, void>(
  PaymentController.new,
);
