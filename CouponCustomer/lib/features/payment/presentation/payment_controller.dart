import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../core/services/razorpay_service.dart';
import '../../../core/error/failures.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../data/payment_repository.dart';

class PaymentController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<void> startPaymentFlow({
    required num amount,
    required String contact,
    required String email,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = GetIt.I<PaymentRepository>();
      final razorpayService = GetIt.I<RazorpayService>();

      // 1. Create order
      final orderResult = await repository.createOrder();
      final orderId = orderResult.fold(
        (failure) => throw failure,
        (id) => id,
      );

      // 2. Open Checkout
      final int amountInPaise = (amount * 100).toInt();
      await razorpayService.openCheckout(
        orderId: orderId,
        amount: amountInPaise,
        contact: contact,
        email: email,
      );

      // 3. Success -> Reload profile to get new subscription status
      ref.invalidate(profileProvider);
      
      // We can also actively wait or refresh the provider to ensure we have the new status,
      // but invalidating makes it reload on the next read.
      
      state = const AsyncData(null);
    } on Failure catch (f, stack) {
      state = AsyncError(f.message, stack);
    } catch (e, stack) {
      state = AsyncError(e.toString(), stack);
    }
  }
}

final paymentControllerProvider = AutoDisposeAsyncNotifierProvider<PaymentController, void>(
  PaymentController.new,
);
