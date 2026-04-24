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

  /// Calls POST /api/v1/payments/generate-hash with [hashString] and returns
  /// the server-computed SHA-512 hash. Used by the PayU SDK's generateHash
  /// callback so the merchant salt never lives on the client.
  Future<Either<Failure, String>> generateHash(String hashString) async {
    try {
      final response = await _apiClient.client.post(
        '/payments/generate-hash',
        data: {'hash_string': hashString},
      );
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        final hash = data['data']['hash'] as String?;
        if (hash != null && hash.isNotEmpty) return Right(hash);
      }
      return const Left(ServerFailure(message: 'Hash generation failed'));
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        return Left(ServerFailure(
          statusCode: e.response?.statusCode,
          message: e.response!.data['message'] ?? 'Hash generation failed',
        ));
      }
      return Left(ServerFailure(
        statusCode: e.response?.statusCode,
        message: e.message ?? 'Hash generation failed',
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
