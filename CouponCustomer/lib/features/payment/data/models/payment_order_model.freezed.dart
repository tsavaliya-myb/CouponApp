// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentOrderModel _$PaymentOrderModelFromJson(Map<String, dynamic> json) {
  return _PaymentOrderModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentOrderModel {
  String get orderId => throw _privateConstructorUsedError;
  num get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get keyId => throw _privateConstructorUsedError;

  /// Serializes this PaymentOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentOrderModelCopyWith<PaymentOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentOrderModelCopyWith<$Res> {
  factory $PaymentOrderModelCopyWith(
          PaymentOrderModel value, $Res Function(PaymentOrderModel) then) =
      _$PaymentOrderModelCopyWithImpl<$Res, PaymentOrderModel>;
  @useResult
  $Res call({String orderId, num amount, String currency, String keyId});
}

/// @nodoc
class _$PaymentOrderModelCopyWithImpl<$Res, $Val extends PaymentOrderModel>
    implements $PaymentOrderModelCopyWith<$Res> {
  _$PaymentOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? keyId = null,
  }) {
    return _then(_value.copyWith(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      keyId: null == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentOrderModelImplCopyWith<$Res>
    implements $PaymentOrderModelCopyWith<$Res> {
  factory _$$PaymentOrderModelImplCopyWith(_$PaymentOrderModelImpl value,
          $Res Function(_$PaymentOrderModelImpl) then) =
      __$$PaymentOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String orderId, num amount, String currency, String keyId});
}

/// @nodoc
class __$$PaymentOrderModelImplCopyWithImpl<$Res>
    extends _$PaymentOrderModelCopyWithImpl<$Res, _$PaymentOrderModelImpl>
    implements _$$PaymentOrderModelImplCopyWith<$Res> {
  __$$PaymentOrderModelImplCopyWithImpl(_$PaymentOrderModelImpl _value,
      $Res Function(_$PaymentOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? keyId = null,
  }) {
    return _then(_$PaymentOrderModelImpl(
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      keyId: null == keyId
          ? _value.keyId
          : keyId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentOrderModelImpl implements _PaymentOrderModel {
  const _$PaymentOrderModelImpl(
      {required this.orderId,
      required this.amount,
      required this.currency,
      required this.keyId});

  factory _$PaymentOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentOrderModelImplFromJson(json);

  @override
  final String orderId;
  @override
  final num amount;
  @override
  final String currency;
  @override
  final String keyId;

  @override
  String toString() {
    return 'PaymentOrderModel(orderId: $orderId, amount: $amount, currency: $currency, keyId: $keyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentOrderModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.keyId, keyId) || other.keyId == keyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, amount, currency, keyId);

  /// Create a copy of PaymentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentOrderModelImplCopyWith<_$PaymentOrderModelImpl> get copyWith =>
      __$$PaymentOrderModelImplCopyWithImpl<_$PaymentOrderModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentOrderModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentOrderModel implements PaymentOrderModel {
  const factory _PaymentOrderModel(
      {required final String orderId,
      required final num amount,
      required final String currency,
      required final String keyId}) = _$PaymentOrderModelImpl;

  factory _PaymentOrderModel.fromJson(Map<String, dynamic> json) =
      _$PaymentOrderModelImpl.fromJson;

  @override
  String get orderId;
  @override
  num get amount;
  @override
  String get currency;
  @override
  String get keyId;

  /// Create a copy of PaymentOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentOrderModelImplCopyWith<_$PaymentOrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
