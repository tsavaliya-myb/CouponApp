// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentOrderModelImpl _$$PaymentOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentOrderModelImpl(
      orderId: json['orderId'] as String,
      amount: json['amount'] as num,
      currency: json['currency'] as String,
      keyId: json['keyId'] as String,
    );

Map<String, dynamic> _$$PaymentOrderModelImplToJson(
        _$PaymentOrderModelImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'keyId': instance.keyId,
    };
