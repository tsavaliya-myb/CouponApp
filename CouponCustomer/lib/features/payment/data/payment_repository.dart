import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../subscription/data/models/payment_history_model.dart';

@injectable
class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  /// Calls POST /api/v1/payments/initiate and returns the Razorpay Checkout
  /// params map (keyId, orderId, customerId, amount, prefill, etc.) on success.
  Future<Either<Failure, Map<String, dynamic>>> initiatePayment() async {
    try {
      final response = await _apiClient.client.post('/payments/initiate');
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        return Right(data['data'] as Map<String, dynamic>);
      }
      return const Left(
          ServerFailure(message: 'Failed to parse payment params from response.'));
    } on DioException catch (e) {
      return Left(_mapDioError(e, 'Failed to initiate payment'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Calls POST /api/v1/payments/verify with the Checkout success callback's
  /// order/payment/signature triple. Optimistic confirmation ahead of the
  /// webhook — the webhook remains the source of truth.
  Future<Either<Failure, String>> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await _apiClient.client.post(
        '/payments/verify',
        data: {
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        },
      );
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        final status = (data['data']['status'] as String?) ?? 'unknown';
        return Right(status);
      }
      return const Left(PaymentFailure(message: 'Payment verification failed'));
    } on DioException catch (e) {
      return Left(_mapDioError(e, 'Payment verification failed'));
    } catch (e) {
      return Left(PaymentFailure(message: e.toString()));
    }
  }

  /// Calls POST /api/v1/payments/cancel-autopay to cancel the UPI Autopay
  /// mandate and disable renewals.
  Future<Either<Failure, Unit>> cancelAutopay() async {
    try {
      final response = await _apiClient.client.post('/payments/cancel-autopay');
      final data = response.data;
      if (data != null && data['success'] == true) {
        return const Right(unit);
      }
      return const Left(ServerFailure(message: 'Failed to cancel autopay'));
    } on DioException catch (e) {
      return Left(_mapDioError(e, 'Failed to cancel autopay'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Calls GET /api/v1/payments/history for the current subscription details
  /// and successful payment attempts.
  Future<Either<Failure, PaymentHistoryResponse>> getPaymentHistory() async {
    try {
      final response = await _apiClient.client.get('/payments/history');
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        return Right(PaymentHistoryResponse.fromJson(data['data'] as Map<String, dynamic>));
      }
      return const Left(ServerFailure(message: 'Failed to load payment history'));
    } on DioException catch (e) {
      return Left(_mapDioError(e, 'Failed to load payment history'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Failure _mapDioError(DioException e, String fallbackMessage) {
    if (e.response != null && e.response!.data is Map) {
      final message = (e.response!.data['message'] as String?) ?? fallbackMessage;
      return ServerFailure(statusCode: e.response?.statusCode, message: message);
    }
    return ServerFailure(statusCode: e.response?.statusCode, message: e.message ?? fallbackMessage);
  }
}
