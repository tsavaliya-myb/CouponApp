import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_history_model.freezed.dart';
part 'payment_history_model.g.dart';

@freezed
class PaymentHistoryResponse with _$PaymentHistoryResponse {
  const factory PaymentHistoryResponse({
    SubscriptionDetailsModel? subscription,
    @Default([]) List<PaymentAttemptModel> history,
  }) = _PaymentHistoryResponse;

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryResponseFromJson(json);
}

@freezed
class SubscriptionDetailsModel with _$SubscriptionDetailsModel {
  const factory SubscriptionDetailsModel({
    required String status,
    required DateTime startDate,
    required DateTime endDate,
    required bool isAutopayEnabled,
  }) = _SubscriptionDetailsModel;

  factory SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDetailsModelFromJson(json);
}

@freezed
class PaymentAttemptModel with _$PaymentAttemptModel {
  const factory PaymentAttemptModel({
    required String id,
    required String txnid,
    required String amount,
    required DateTime createdAt,
    required String kind,
  }) = _PaymentAttemptModel;

  factory PaymentAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentAttemptModelFromJson(json);
}
