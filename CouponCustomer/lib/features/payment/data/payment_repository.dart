import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

@injectable
class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<Either<Failure, String>> createOrder() async {
    try {
      final response = await _apiClient.client.post('/payments/create-order');
      final data = response.data;
      if (data != null && data['data'] != null && data['data']['order_id'] != null) {
        return Right(data['data']['order_id']);
      } else {
        return Left(const ServerFailure(message: 'Failed to parse order ID from response.'));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        return Left(ServerFailure(
          statusCode: e.response?.statusCode,
          message: e.response!.data['message'] ?? 'Failed to create order',
        ));
      }
      return Left(ServerFailure(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Failed to create order',
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
