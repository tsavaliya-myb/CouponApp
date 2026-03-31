import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/confirm_redemption_model.dart';
import '../models/verify_user_model.dart';

abstract class RedemptionRemoteDatasource {
  Future<VerifyUserResponseModel> verifyUser(String userId);

  Future<ConfirmRedemptionResponseModel> confirmRedemption(
      ConfirmRedemptionRequestModel request);
}

@Injectable(as: RedemptionRemoteDatasource)
class RedemptionRemoteDatasourceImpl implements RedemptionRemoteDatasource {
  final ApiClient _apiClient;

  RedemptionRemoteDatasourceImpl(this._apiClient);

  @override
  Future<VerifyUserResponseModel> verifyUser(String userId) async {
    final response = await _apiClient.client.get('/v1/redemptions/verifyUser/$userId');
    return VerifyUserResponseModel.fromJson(response.data);
  }

  @override
  Future<ConfirmRedemptionResponseModel> confirmRedemption(
      ConfirmRedemptionRequestModel request) async {
    final response = await _apiClient.client.post(
      '/v1/redemptions/confirm',
      data: request.toJson(),
    );
    return ConfirmRedemptionResponseModel.fromJson(response.data);
  }
}

