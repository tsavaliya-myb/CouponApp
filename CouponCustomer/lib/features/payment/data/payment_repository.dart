import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

@injectable
class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  /// Calls POST /api/v1/payments/initiate and returns the PayU payment params
  /// map (key, txnid, amount, hash, si_details, etc.) on success.
  Future<Either<Failure, Map<String, dynamic>>> initiatePayment() async {
    try {
      final response =
          await _apiClient.client.post('/payments/initiate');
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        return Right(data['data'] as Map<String, dynamic>);
      } else {
        return const Left(
            ServerFailure(message: 'Failed to parse payment params from response.'));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        return Left(ServerFailure(
          statusCode: e.response?.statusCode,
          message: e.response!.data['message'] ?? 'Failed to initiate payment',
        ));
      }
      return Left(ServerFailure(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Failed to initiate payment',
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
