import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../core/services/payu_service.dart';
import '../../../core/error/failures.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../data/payment_repository.dart';

/// Drives the PayU UPI Autopay purchase flow.
///
/// State is `AsyncLoading` while the SDK checkout is open, `AsyncData(null)`
/// on success, and `AsyncError` on failure / cancellation.
class PaymentController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial idle state
  }

  /// Initiates the PayU UPI Autopay flow.
  ///
  /// 1. Calls the backend to get payment params + SHA-512 hash.
  /// 2. Opens the PayU CheckoutPro SDK.
  /// 3. On success, waits 3 s for the S2S webhook to fulfil the subscription,
  ///    then invalidates [profileProvider] to refresh the user's status.
  Future<void> startPaymentFlow(BuildContext context) async {
    state = const AsyncLoading();
    try {
      final repository = GetIt.I<PaymentRepository>();
      final payuService = GetIt.I<PayUService>();

      // Step 1 — fetch PayU params from backend
      final result = await repository.initiatePayment();
      final params = result.fold(
        (failure) => throw failure,
        (p) => p,
      );

      // Step 2 — wire callbacks before opening checkout
      payuService.initialize(context);

      // Server-side hash generation keeps the merchant salt off the client.
      payuService.onGenerateHash = (hashString) async {
        final result = await repository.generateHash(hashString);
        return result.fold((_) => '', (hash) => hash);
      };

      payuService.onSuccess = (_) async {
        // The actual subscription fulfilment happens server-side via S2S
        // webhook. We wait briefly, then refresh the profile.
        await Future.delayed(const Duration(seconds: 3));
        ref.invalidate(profileProvider);
        state = const AsyncData(null);
      };

      payuService.onFailure = (err) {
        state = AsyncError(err, StackTrace.current);
      };

      // Step 3 — open checkout (non-blocking; result via callbacks above)
      payuService.openCheckout(params);
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
