// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'confirm_redemption_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConfirmRedemptionRequestModel _$ConfirmRedemptionRequestModelFromJson(
  Map<String, dynamic> json,
) {
  return _ConfirmRedemptionRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ConfirmRedemptionRequestModel {
  String get userCouponId => throw _privateConstructorUsedError;
  double get billAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get coinsUsed => throw _privateConstructorUsedError;

  /// Serializes this ConfirmRedemptionRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmRedemptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmRedemptionRequestModelCopyWith<ConfirmRedemptionRequestModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmRedemptionRequestModelCopyWith<$Res> {
  factory $ConfirmRedemptionRequestModelCopyWith(
    ConfirmRedemptionRequestModel value,
    $Res Function(ConfirmRedemptionRequestModel) then,
  ) =
      _$ConfirmRedemptionRequestModelCopyWithImpl<
        $Res,
        ConfirmRedemptionRequestModel
      >;
  @useResult
  $Res call({
    String userCouponId,
    double billAmount,
    double discountAmount,
    double coinsUsed,
  });
}

/// @nodoc
class _$ConfirmRedemptionRequestModelCopyWithImpl<
  $Res,
  $Val extends ConfirmRedemptionRequestModel
>
    implements $ConfirmRedemptionRequestModelCopyWith<$Res> {
  _$ConfirmRedemptionRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmRedemptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userCouponId = null,
    Object? billAmount = null,
    Object? discountAmount = null,
    Object? coinsUsed = null,
  }) {
    return _then(
      _value.copyWith(
            userCouponId: null == userCouponId
                ? _value.userCouponId
                : userCouponId // ignore: cast_nullable_to_non_nullable
                      as String,
            billAmount: null == billAmount
                ? _value.billAmount
                : billAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            coinsUsed: null == coinsUsed
                ? _value.coinsUsed
                : coinsUsed // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfirmRedemptionRequestModelImplCopyWith<$Res>
    implements $ConfirmRedemptionRequestModelCopyWith<$Res> {
  factory _$$ConfirmRedemptionRequestModelImplCopyWith(
    _$ConfirmRedemptionRequestModelImpl value,
    $Res Function(_$ConfirmRedemptionRequestModelImpl) then,
  ) = __$$ConfirmRedemptionRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userCouponId,
    double billAmount,
    double discountAmount,
    double coinsUsed,
  });
}

/// @nodoc
class __$$ConfirmRedemptionRequestModelImplCopyWithImpl<$Res>
    extends
        _$ConfirmRedemptionRequestModelCopyWithImpl<
          $Res,
          _$ConfirmRedemptionRequestModelImpl
        >
    implements _$$ConfirmRedemptionRequestModelImplCopyWith<$Res> {
  __$$ConfirmRedemptionRequestModelImplCopyWithImpl(
    _$ConfirmRedemptionRequestModelImpl _value,
    $Res Function(_$ConfirmRedemptionRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfirmRedemptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userCouponId = null,
    Object? billAmount = null,
    Object? discountAmount = null,
    Object? coinsUsed = null,
  }) {
    return _then(
      _$ConfirmRedemptionRequestModelImpl(
        userCouponId: null == userCouponId
            ? _value.userCouponId
            : userCouponId // ignore: cast_nullable_to_non_nullable
                  as String,
        billAmount: null == billAmount
            ? _value.billAmount
            : billAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        coinsUsed: null == coinsUsed
            ? _value.coinsUsed
            : coinsUsed // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmRedemptionRequestModelImpl
    implements _ConfirmRedemptionRequestModel {
  const _$ConfirmRedemptionRequestModelImpl({
    required this.userCouponId,
    required this.billAmount,
    required this.discountAmount,
    required this.coinsUsed,
  });

  factory _$ConfirmRedemptionRequestModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ConfirmRedemptionRequestModelImplFromJson(json);

  @override
  final String userCouponId;
  @override
  final double billAmount;
  @override
  final double discountAmount;
  @override
  final double coinsUsed;

  @override
  String toString() {
    return 'ConfirmRedemptionRequestModel(userCouponId: $userCouponId, billAmount: $billAmount, discountAmount: $discountAmount, coinsUsed: $coinsUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmRedemptionRequestModelImpl &&
            (identical(other.userCouponId, userCouponId) ||
                other.userCouponId == userCouponId) &&
            (identical(other.billAmount, billAmount) ||
                other.billAmount == billAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.coinsUsed, coinsUsed) ||
                other.coinsUsed == coinsUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userCouponId,
    billAmount,
    discountAmount,
    coinsUsed,
  );

  /// Create a copy of ConfirmRedemptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmRedemptionRequestModelImplCopyWith<
    _$ConfirmRedemptionRequestModelImpl
  >
  get copyWith =>
      __$$ConfirmRedemptionRequestModelImplCopyWithImpl<
        _$ConfirmRedemptionRequestModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmRedemptionRequestModelImplToJson(this);
  }
}

abstract class _ConfirmRedemptionRequestModel
    implements ConfirmRedemptionRequestModel {
  const factory _ConfirmRedemptionRequestModel({
    required final String userCouponId,
    required final double billAmount,
    required final double discountAmount,
    required final double coinsUsed,
  }) = _$ConfirmRedemptionRequestModelImpl;

  factory _ConfirmRedemptionRequestModel.fromJson(Map<String, dynamic> json) =
      _$ConfirmRedemptionRequestModelImpl.fromJson;

  @override
  String get userCouponId;
  @override
  double get billAmount;
  @override
  double get discountAmount;
  @override
  double get coinsUsed;

  /// Create a copy of ConfirmRedemptionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmRedemptionRequestModelImplCopyWith<
    _$ConfirmRedemptionRequestModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

ConfirmRedemptionResponseModel _$ConfirmRedemptionResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _ConfirmRedemptionResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ConfirmRedemptionResponseModel {
  bool get success => throw _privateConstructorUsedError;

  /// Serializes this ConfirmRedemptionResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmRedemptionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmRedemptionResponseModelCopyWith<ConfirmRedemptionResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmRedemptionResponseModelCopyWith<$Res> {
  factory $ConfirmRedemptionResponseModelCopyWith(
    ConfirmRedemptionResponseModel value,
    $Res Function(ConfirmRedemptionResponseModel) then,
  ) =
      _$ConfirmRedemptionResponseModelCopyWithImpl<
        $Res,
        ConfirmRedemptionResponseModel
      >;
  @useResult
  $Res call({bool success});
}

/// @nodoc
class _$ConfirmRedemptionResponseModelCopyWithImpl<
  $Res,
  $Val extends ConfirmRedemptionResponseModel
>
    implements $ConfirmRedemptionResponseModelCopyWith<$Res> {
  _$ConfirmRedemptionResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmRedemptionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null}) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConfirmRedemptionResponseModelImplCopyWith<$Res>
    implements $ConfirmRedemptionResponseModelCopyWith<$Res> {
  factory _$$ConfirmRedemptionResponseModelImplCopyWith(
    _$ConfirmRedemptionResponseModelImpl value,
    $Res Function(_$ConfirmRedemptionResponseModelImpl) then,
  ) = __$$ConfirmRedemptionResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success});
}

/// @nodoc
class __$$ConfirmRedemptionResponseModelImplCopyWithImpl<$Res>
    extends
        _$ConfirmRedemptionResponseModelCopyWithImpl<
          $Res,
          _$ConfirmRedemptionResponseModelImpl
        >
    implements _$$ConfirmRedemptionResponseModelImplCopyWith<$Res> {
  __$$ConfirmRedemptionResponseModelImplCopyWithImpl(
    _$ConfirmRedemptionResponseModelImpl _value,
    $Res Function(_$ConfirmRedemptionResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConfirmRedemptionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null}) {
    return _then(
      _$ConfirmRedemptionResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmRedemptionResponseModelImpl
    implements _ConfirmRedemptionResponseModel {
  const _$ConfirmRedemptionResponseModelImpl({required this.success});

  factory _$ConfirmRedemptionResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ConfirmRedemptionResponseModelImplFromJson(json);

  @override
  final bool success;

  @override
  String toString() {
    return 'ConfirmRedemptionResponseModel(success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmRedemptionResponseModelImpl &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success);

  /// Create a copy of ConfirmRedemptionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmRedemptionResponseModelImplCopyWith<
    _$ConfirmRedemptionResponseModelImpl
  >
  get copyWith =>
      __$$ConfirmRedemptionResponseModelImplCopyWithImpl<
        _$ConfirmRedemptionResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmRedemptionResponseModelImplToJson(this);
  }
}

abstract class _ConfirmRedemptionResponseModel
    implements ConfirmRedemptionResponseModel {
  const factory _ConfirmRedemptionResponseModel({required final bool success}) =
      _$ConfirmRedemptionResponseModelImpl;

  factory _ConfirmRedemptionResponseModel.fromJson(Map<String, dynamic> json) =
      _$ConfirmRedemptionResponseModelImpl.fromJson;

  @override
  bool get success;

  /// Create a copy of ConfirmRedemptionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmRedemptionResponseModelImplCopyWith<
    _$ConfirmRedemptionResponseModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
