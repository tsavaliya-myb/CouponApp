import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_order_model.freezed.dart';
part 'payment_order_model.g.dart';

@freezed
class PaymentOrderModel with _$PaymentOrderModel {
  const factory PaymentOrderModel({
    required String orderId,
    required num amount,
    required String currency,
    required String keyId,
  }) = _PaymentOrderModel;

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderModelFromJson(json);
}
