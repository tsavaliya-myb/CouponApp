// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentHistoryResponseImpl _$$PaymentHistoryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentHistoryResponseImpl(
      subscription: json['subscription'] == null
          ? null
          : SubscriptionDetailsModel.fromJson(
              json['subscription'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) =>
                  PaymentAttemptModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PaymentHistoryResponseImplToJson(
        _$PaymentHistoryResponseImpl instance) =>
    <String, dynamic>{
      'subscription': instance.subscription,
      'history': instance.history,
    };

_$SubscriptionDetailsModelImpl _$$SubscriptionDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionDetailsModelImpl(
      status: json['status'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isAutopayEnabled: json['isAutopayEnabled'] as bool,
    );

Map<String, dynamic> _$$SubscriptionDetailsModelImplToJson(
        _$SubscriptionDetailsModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'isAutopayEnabled': instance.isAutopayEnabled,
    };

_$PaymentAttemptModelImpl _$$PaymentAttemptModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentAttemptModelImpl(
      id: json['id'] as String,
      txnid: json['txnid'] as String,
      amount: json['amount'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      kind: json['kind'] as String,
    );

Map<String, dynamic> _$$PaymentAttemptModelImplToJson(
        _$PaymentAttemptModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'txnid': instance.txnid,
      'amount': instance.amount,
      'createdAt': instance.createdAt.toIso8601String(),
      'kind': instance.kind,
    };
