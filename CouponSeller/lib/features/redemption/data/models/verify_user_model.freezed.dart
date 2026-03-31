// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerifyUserResponseModel _$VerifyUserResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _VerifyUserResponseModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyUserResponseModel {
  bool get success => throw _privateConstructorUsedError;
  VerifyUserDataModel get data => throw _privateConstructorUsedError;

  /// Serializes this VerifyUserResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyUserResponseModelCopyWith<VerifyUserResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyUserResponseModelCopyWith<$Res> {
  factory $VerifyUserResponseModelCopyWith(
    VerifyUserResponseModel value,
    $Res Function(VerifyUserResponseModel) then,
  ) = _$VerifyUserResponseModelCopyWithImpl<$Res, VerifyUserResponseModel>;
  @useResult
  $Res call({bool success, VerifyUserDataModel data});

  $VerifyUserDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$VerifyUserResponseModelCopyWithImpl<
  $Res,
  $Val extends VerifyUserResponseModel
>
    implements $VerifyUserResponseModelCopyWith<$Res> {
  _$VerifyUserResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as VerifyUserDataModel,
          )
          as $Val,
    );
  }

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerifyUserDataModelCopyWith<$Res> get data {
    return $VerifyUserDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyUserResponseModelImplCopyWith<$Res>
    implements $VerifyUserResponseModelCopyWith<$Res> {
  factory _$$VerifyUserResponseModelImplCopyWith(
    _$VerifyUserResponseModelImpl value,
    $Res Function(_$VerifyUserResponseModelImpl) then,
  ) = __$$VerifyUserResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, VerifyUserDataModel data});

  @override
  $VerifyUserDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$VerifyUserResponseModelImplCopyWithImpl<$Res>
    extends
        _$VerifyUserResponseModelCopyWithImpl<
          $Res,
          _$VerifyUserResponseModelImpl
        >
    implements _$$VerifyUserResponseModelImplCopyWith<$Res> {
  __$$VerifyUserResponseModelImplCopyWithImpl(
    _$VerifyUserResponseModelImpl _value,
    $Res Function(_$VerifyUserResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$VerifyUserResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as VerifyUserDataModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyUserResponseModelImpl implements _VerifyUserResponseModel {
  const _$VerifyUserResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$VerifyUserResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyUserResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final VerifyUserDataModel data;

  @override
  String toString() {
    return 'VerifyUserResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyUserResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyUserResponseModelImplCopyWith<_$VerifyUserResponseModelImpl>
  get copyWith =>
      __$$VerifyUserResponseModelImplCopyWithImpl<
        _$VerifyUserResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyUserResponseModelImplToJson(this);
  }
}

abstract class _VerifyUserResponseModel implements VerifyUserResponseModel {
  const factory _VerifyUserResponseModel({
    required final bool success,
    required final VerifyUserDataModel data,
  }) = _$VerifyUserResponseModelImpl;

  factory _VerifyUserResponseModel.fromJson(Map<String, dynamic> json) =
      _$VerifyUserResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  VerifyUserDataModel get data;

  /// Create a copy of VerifyUserResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyUserResponseModelImplCopyWith<_$VerifyUserResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VerifyUserDataModel _$VerifyUserDataModelFromJson(Map<String, dynamic> json) {
  return _VerifyUserDataModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyUserDataModel {
  RedemptionUserModel get user => throw _privateConstructorUsedError;
  List<EligibleCouponModel> get eligibleCoupons =>
      throw _privateConstructorUsedError;

  /// Serializes this VerifyUserDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyUserDataModelCopyWith<VerifyUserDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyUserDataModelCopyWith<$Res> {
  factory $VerifyUserDataModelCopyWith(
    VerifyUserDataModel value,
    $Res Function(VerifyUserDataModel) then,
  ) = _$VerifyUserDataModelCopyWithImpl<$Res, VerifyUserDataModel>;
  @useResult
  $Res call({
    RedemptionUserModel user,
    List<EligibleCouponModel> eligibleCoupons,
  });

  $RedemptionUserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$VerifyUserDataModelCopyWithImpl<$Res, $Val extends VerifyUserDataModel>
    implements $VerifyUserDataModelCopyWith<$Res> {
  _$VerifyUserDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? eligibleCoupons = null}) {
    return _then(
      _value.copyWith(
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as RedemptionUserModel,
            eligibleCoupons: null == eligibleCoupons
                ? _value.eligibleCoupons
                : eligibleCoupons // ignore: cast_nullable_to_non_nullable
                      as List<EligibleCouponModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RedemptionUserModelCopyWith<$Res> get user {
    return $RedemptionUserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyUserDataModelImplCopyWith<$Res>
    implements $VerifyUserDataModelCopyWith<$Res> {
  factory _$$VerifyUserDataModelImplCopyWith(
    _$VerifyUserDataModelImpl value,
    $Res Function(_$VerifyUserDataModelImpl) then,
  ) = __$$VerifyUserDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RedemptionUserModel user,
    List<EligibleCouponModel> eligibleCoupons,
  });

  @override
  $RedemptionUserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$VerifyUserDataModelImplCopyWithImpl<$Res>
    extends _$VerifyUserDataModelCopyWithImpl<$Res, _$VerifyUserDataModelImpl>
    implements _$$VerifyUserDataModelImplCopyWith<$Res> {
  __$$VerifyUserDataModelImplCopyWithImpl(
    _$VerifyUserDataModelImpl _value,
    $Res Function(_$VerifyUserDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? eligibleCoupons = null}) {
    return _then(
      _$VerifyUserDataModelImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as RedemptionUserModel,
        eligibleCoupons: null == eligibleCoupons
            ? _value._eligibleCoupons
            : eligibleCoupons // ignore: cast_nullable_to_non_nullable
                  as List<EligibleCouponModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyUserDataModelImpl implements _VerifyUserDataModel {
  const _$VerifyUserDataModelImpl({
    required this.user,
    required final List<EligibleCouponModel> eligibleCoupons,
  }) : _eligibleCoupons = eligibleCoupons;

  factory _$VerifyUserDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyUserDataModelImplFromJson(json);

  @override
  final RedemptionUserModel user;
  final List<EligibleCouponModel> _eligibleCoupons;
  @override
  List<EligibleCouponModel> get eligibleCoupons {
    if (_eligibleCoupons is EqualUnmodifiableListView) return _eligibleCoupons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eligibleCoupons);
  }

  @override
  String toString() {
    return 'VerifyUserDataModel(user: $user, eligibleCoupons: $eligibleCoupons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyUserDataModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(
              other._eligibleCoupons,
              _eligibleCoupons,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    const DeepCollectionEquality().hash(_eligibleCoupons),
  );

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyUserDataModelImplCopyWith<_$VerifyUserDataModelImpl> get copyWith =>
      __$$VerifyUserDataModelImplCopyWithImpl<_$VerifyUserDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyUserDataModelImplToJson(this);
  }
}

abstract class _VerifyUserDataModel implements VerifyUserDataModel {
  const factory _VerifyUserDataModel({
    required final RedemptionUserModel user,
    required final List<EligibleCouponModel> eligibleCoupons,
  }) = _$VerifyUserDataModelImpl;

  factory _VerifyUserDataModel.fromJson(Map<String, dynamic> json) =
      _$VerifyUserDataModelImpl.fromJson;

  @override
  RedemptionUserModel get user;
  @override
  List<EligibleCouponModel> get eligibleCoupons;

  /// Create a copy of VerifyUserDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyUserDataModelImplCopyWith<_$VerifyUserDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RedemptionUserModel _$RedemptionUserModelFromJson(Map<String, dynamic> json) {
  return _RedemptionUserModel.fromJson(json);
}

/// @nodoc
mixin _$RedemptionUserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  bool get hasActiveSubscription => throw _privateConstructorUsedError;
  double get availableCoins => throw _privateConstructorUsedError;

  /// Serializes this RedemptionUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedemptionUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedemptionUserModelCopyWith<RedemptionUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedemptionUserModelCopyWith<$Res> {
  factory $RedemptionUserModelCopyWith(
    RedemptionUserModel value,
    $Res Function(RedemptionUserModel) then,
  ) = _$RedemptionUserModelCopyWithImpl<$Res, RedemptionUserModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String phone,
    bool hasActiveSubscription,
    double availableCoins,
  });
}

/// @nodoc
class _$RedemptionUserModelCopyWithImpl<$Res, $Val extends RedemptionUserModel>
    implements $RedemptionUserModelCopyWith<$Res> {
  _$RedemptionUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedemptionUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? hasActiveSubscription = null,
    Object? availableCoins = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            hasActiveSubscription: null == hasActiveSubscription
                ? _value.hasActiveSubscription
                : hasActiveSubscription // ignore: cast_nullable_to_non_nullable
                      as bool,
            availableCoins: null == availableCoins
                ? _value.availableCoins
                : availableCoins // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RedemptionUserModelImplCopyWith<$Res>
    implements $RedemptionUserModelCopyWith<$Res> {
  factory _$$RedemptionUserModelImplCopyWith(
    _$RedemptionUserModelImpl value,
    $Res Function(_$RedemptionUserModelImpl) then,
  ) = __$$RedemptionUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String phone,
    bool hasActiveSubscription,
    double availableCoins,
  });
}

/// @nodoc
class __$$RedemptionUserModelImplCopyWithImpl<$Res>
    extends _$RedemptionUserModelCopyWithImpl<$Res, _$RedemptionUserModelImpl>
    implements _$$RedemptionUserModelImplCopyWith<$Res> {
  __$$RedemptionUserModelImplCopyWithImpl(
    _$RedemptionUserModelImpl _value,
    $Res Function(_$RedemptionUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedemptionUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? hasActiveSubscription = null,
    Object? availableCoins = null,
  }) {
    return _then(
      _$RedemptionUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        hasActiveSubscription: null == hasActiveSubscription
            ? _value.hasActiveSubscription
            : hasActiveSubscription // ignore: cast_nullable_to_non_nullable
                  as bool,
        availableCoins: null == availableCoins
            ? _value.availableCoins
            : availableCoins // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RedemptionUserModelImpl implements _RedemptionUserModel {
  const _$RedemptionUserModelImpl({
    required this.id,
    required this.name,
    required this.phone,
    required this.hasActiveSubscription,
    required this.availableCoins,
  });

  factory _$RedemptionUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedemptionUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String phone;
  @override
  final bool hasActiveSubscription;
  @override
  final double availableCoins;

  @override
  String toString() {
    return 'RedemptionUserModel(id: $id, name: $name, phone: $phone, hasActiveSubscription: $hasActiveSubscription, availableCoins: $availableCoins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedemptionUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.hasActiveSubscription, hasActiveSubscription) ||
                other.hasActiveSubscription == hasActiveSubscription) &&
            (identical(other.availableCoins, availableCoins) ||
                other.availableCoins == availableCoins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    phone,
    hasActiveSubscription,
    availableCoins,
  );

  /// Create a copy of RedemptionUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedemptionUserModelImplCopyWith<_$RedemptionUserModelImpl> get copyWith =>
      __$$RedemptionUserModelImplCopyWithImpl<_$RedemptionUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RedemptionUserModelImplToJson(this);
  }
}

abstract class _RedemptionUserModel implements RedemptionUserModel {
  const factory _RedemptionUserModel({
    required final String id,
    required final String name,
    required final String phone,
    required final bool hasActiveSubscription,
    required final double availableCoins,
  }) = _$RedemptionUserModelImpl;

  factory _RedemptionUserModel.fromJson(Map<String, dynamic> json) =
      _$RedemptionUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get phone;
  @override
  bool get hasActiveSubscription;
  @override
  double get availableCoins;

  /// Create a copy of RedemptionUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedemptionUserModelImplCopyWith<_$RedemptionUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EligibleCouponModel _$EligibleCouponModelFromJson(Map<String, dynamic> json) {
  return _EligibleCouponModel.fromJson(json);
}

/// @nodoc
mixin _$EligibleCouponModel {
  String get id => throw _privateConstructorUsedError;
  String get couponBookId => throw _privateConstructorUsedError;
  String get couponId => throw _privateConstructorUsedError;
  int get usesRemaining => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  RedemptionCouponModel get coupon => throw _privateConstructorUsedError;

  /// Serializes this EligibleCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EligibleCouponModelCopyWith<EligibleCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EligibleCouponModelCopyWith<$Res> {
  factory $EligibleCouponModelCopyWith(
    EligibleCouponModel value,
    $Res Function(EligibleCouponModel) then,
  ) = _$EligibleCouponModelCopyWithImpl<$Res, EligibleCouponModel>;
  @useResult
  $Res call({
    String id,
    String couponBookId,
    String couponId,
    int usesRemaining,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
    RedemptionCouponModel coupon,
  });

  $RedemptionCouponModelCopyWith<$Res> get coupon;
}

/// @nodoc
class _$EligibleCouponModelCopyWithImpl<$Res, $Val extends EligibleCouponModel>
    implements $EligibleCouponModelCopyWith<$Res> {
  _$EligibleCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponBookId = null,
    Object? couponId = null,
    Object? usesRemaining = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? coupon = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            couponBookId: null == couponBookId
                ? _value.couponBookId
                : couponBookId // ignore: cast_nullable_to_non_nullable
                      as String,
            couponId: null == couponId
                ? _value.couponId
                : couponId // ignore: cast_nullable_to_non_nullable
                      as String,
            usesRemaining: null == usesRemaining
                ? _value.usesRemaining
                : usesRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            coupon: null == coupon
                ? _value.coupon
                : coupon // ignore: cast_nullable_to_non_nullable
                      as RedemptionCouponModel,
          )
          as $Val,
    );
  }

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RedemptionCouponModelCopyWith<$Res> get coupon {
    return $RedemptionCouponModelCopyWith<$Res>(_value.coupon, (value) {
      return _then(_value.copyWith(coupon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EligibleCouponModelImplCopyWith<$Res>
    implements $EligibleCouponModelCopyWith<$Res> {
  factory _$$EligibleCouponModelImplCopyWith(
    _$EligibleCouponModelImpl value,
    $Res Function(_$EligibleCouponModelImpl) then,
  ) = __$$EligibleCouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String couponBookId,
    String couponId,
    int usesRemaining,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
    RedemptionCouponModel coupon,
  });

  @override
  $RedemptionCouponModelCopyWith<$Res> get coupon;
}

/// @nodoc
class __$$EligibleCouponModelImplCopyWithImpl<$Res>
    extends _$EligibleCouponModelCopyWithImpl<$Res, _$EligibleCouponModelImpl>
    implements _$$EligibleCouponModelImplCopyWith<$Res> {
  __$$EligibleCouponModelImplCopyWithImpl(
    _$EligibleCouponModelImpl _value,
    $Res Function(_$EligibleCouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponBookId = null,
    Object? couponId = null,
    Object? usesRemaining = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? coupon = null,
  }) {
    return _then(
      _$EligibleCouponModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        couponBookId: null == couponBookId
            ? _value.couponBookId
            : couponBookId // ignore: cast_nullable_to_non_nullable
                  as String,
        couponId: null == couponId
            ? _value.couponId
            : couponId // ignore: cast_nullable_to_non_nullable
                  as String,
        usesRemaining: null == usesRemaining
            ? _value.usesRemaining
            : usesRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        coupon: null == coupon
            ? _value.coupon
            : coupon // ignore: cast_nullable_to_non_nullable
                  as RedemptionCouponModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EligibleCouponModelImpl implements _EligibleCouponModel {
  const _$EligibleCouponModelImpl({
    required this.id,
    required this.couponBookId,
    required this.couponId,
    required this.usesRemaining,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.coupon,
  });

  factory _$EligibleCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EligibleCouponModelImplFromJson(json);

  @override
  final String id;
  @override
  final String couponBookId;
  @override
  final String couponId;
  @override
  final int usesRemaining;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final RedemptionCouponModel coupon;

  @override
  String toString() {
    return 'EligibleCouponModel(id: $id, couponBookId: $couponBookId, couponId: $couponId, usesRemaining: $usesRemaining, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, coupon: $coupon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EligibleCouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.couponBookId, couponBookId) ||
                other.couponBookId == couponBookId) &&
            (identical(other.couponId, couponId) ||
                other.couponId == couponId) &&
            (identical(other.usesRemaining, usesRemaining) ||
                other.usesRemaining == usesRemaining) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.coupon, coupon) || other.coupon == coupon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    couponBookId,
    couponId,
    usesRemaining,
    status,
    createdAt,
    updatedAt,
    coupon,
  );

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EligibleCouponModelImplCopyWith<_$EligibleCouponModelImpl> get copyWith =>
      __$$EligibleCouponModelImplCopyWithImpl<_$EligibleCouponModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EligibleCouponModelImplToJson(this);
  }
}

abstract class _EligibleCouponModel implements EligibleCouponModel {
  const factory _EligibleCouponModel({
    required final String id,
    required final String couponBookId,
    required final String couponId,
    required final int usesRemaining,
    required final String status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final RedemptionCouponModel coupon,
  }) = _$EligibleCouponModelImpl;

  factory _EligibleCouponModel.fromJson(Map<String, dynamic> json) =
      _$EligibleCouponModelImpl.fromJson;

  @override
  String get id;
  @override
  String get couponBookId;
  @override
  String get couponId;
  @override
  int get usesRemaining;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  RedemptionCouponModel get coupon;

  /// Create a copy of EligibleCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EligibleCouponModelImplCopyWith<_$EligibleCouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RedemptionCouponModel _$RedemptionCouponModelFromJson(
  Map<String, dynamic> json,
) {
  return _RedemptionCouponModel.fromJson(json);
}

/// @nodoc
mixin _$RedemptionCouponModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  double get discountPct => throw _privateConstructorUsedError;
  double get adminCommissionPct => throw _privateConstructorUsedError;
  double get minSpend => throw _privateConstructorUsedError;
  int get maxUsesPerBook => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isBaseCoupon => throw _privateConstructorUsedError;

  /// Serializes this RedemptionCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedemptionCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedemptionCouponModelCopyWith<RedemptionCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedemptionCouponModelCopyWith<$Res> {
  factory $RedemptionCouponModelCopyWith(
    RedemptionCouponModel value,
    $Res Function(RedemptionCouponModel) then,
  ) = _$RedemptionCouponModelCopyWithImpl<$Res, RedemptionCouponModel>;
  @useResult
  $Res call({
    String id,
    String sellerId,
    double discountPct,
    double adminCommissionPct,
    double minSpend,
    int maxUsesPerBook,
    String type,
    String status,
    bool isBaseCoupon,
  });
}

/// @nodoc
class _$RedemptionCouponModelCopyWithImpl<
  $Res,
  $Val extends RedemptionCouponModel
>
    implements $RedemptionCouponModelCopyWith<$Res> {
  _$RedemptionCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedemptionCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? discountPct = null,
    Object? adminCommissionPct = null,
    Object? minSpend = null,
    Object? maxUsesPerBook = null,
    Object? type = null,
    Object? status = null,
    Object? isBaseCoupon = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sellerId: null == sellerId
                ? _value.sellerId
                : sellerId // ignore: cast_nullable_to_non_nullable
                      as String,
            discountPct: null == discountPct
                ? _value.discountPct
                : discountPct // ignore: cast_nullable_to_non_nullable
                      as double,
            adminCommissionPct: null == adminCommissionPct
                ? _value.adminCommissionPct
                : adminCommissionPct // ignore: cast_nullable_to_non_nullable
                      as double,
            minSpend: null == minSpend
                ? _value.minSpend
                : minSpend // ignore: cast_nullable_to_non_nullable
                      as double,
            maxUsesPerBook: null == maxUsesPerBook
                ? _value.maxUsesPerBook
                : maxUsesPerBook // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            isBaseCoupon: null == isBaseCoupon
                ? _value.isBaseCoupon
                : isBaseCoupon // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RedemptionCouponModelImplCopyWith<$Res>
    implements $RedemptionCouponModelCopyWith<$Res> {
  factory _$$RedemptionCouponModelImplCopyWith(
    _$RedemptionCouponModelImpl value,
    $Res Function(_$RedemptionCouponModelImpl) then,
  ) = __$$RedemptionCouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sellerId,
    double discountPct,
    double adminCommissionPct,
    double minSpend,
    int maxUsesPerBook,
    String type,
    String status,
    bool isBaseCoupon,
  });
}

/// @nodoc
class __$$RedemptionCouponModelImplCopyWithImpl<$Res>
    extends
        _$RedemptionCouponModelCopyWithImpl<$Res, _$RedemptionCouponModelImpl>
    implements _$$RedemptionCouponModelImplCopyWith<$Res> {
  __$$RedemptionCouponModelImplCopyWithImpl(
    _$RedemptionCouponModelImpl _value,
    $Res Function(_$RedemptionCouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedemptionCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? discountPct = null,
    Object? adminCommissionPct = null,
    Object? minSpend = null,
    Object? maxUsesPerBook = null,
    Object? type = null,
    Object? status = null,
    Object? isBaseCoupon = null,
  }) {
    return _then(
      _$RedemptionCouponModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sellerId: null == sellerId
            ? _value.sellerId
            : sellerId // ignore: cast_nullable_to_non_nullable
                  as String,
        discountPct: null == discountPct
            ? _value.discountPct
            : discountPct // ignore: cast_nullable_to_non_nullable
                  as double,
        adminCommissionPct: null == adminCommissionPct
            ? _value.adminCommissionPct
            : adminCommissionPct // ignore: cast_nullable_to_non_nullable
                  as double,
        minSpend: null == minSpend
            ? _value.minSpend
            : minSpend // ignore: cast_nullable_to_non_nullable
                  as double,
        maxUsesPerBook: null == maxUsesPerBook
            ? _value.maxUsesPerBook
            : maxUsesPerBook // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        isBaseCoupon: null == isBaseCoupon
            ? _value.isBaseCoupon
            : isBaseCoupon // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RedemptionCouponModelImpl implements _RedemptionCouponModel {
  const _$RedemptionCouponModelImpl({
    required this.id,
    required this.sellerId,
    required this.discountPct,
    required this.adminCommissionPct,
    required this.minSpend,
    required this.maxUsesPerBook,
    required this.type,
    required this.status,
    required this.isBaseCoupon,
  });

  factory _$RedemptionCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedemptionCouponModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final double discountPct;
  @override
  final double adminCommissionPct;
  @override
  final double minSpend;
  @override
  final int maxUsesPerBook;
  @override
  final String type;
  @override
  final String status;
  @override
  final bool isBaseCoupon;

  @override
  String toString() {
    return 'RedemptionCouponModel(id: $id, sellerId: $sellerId, discountPct: $discountPct, adminCommissionPct: $adminCommissionPct, minSpend: $minSpend, maxUsesPerBook: $maxUsesPerBook, type: $type, status: $status, isBaseCoupon: $isBaseCoupon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedemptionCouponModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct) &&
            (identical(other.adminCommissionPct, adminCommissionPct) ||
                other.adminCommissionPct == adminCommissionPct) &&
            (identical(other.minSpend, minSpend) ||
                other.minSpend == minSpend) &&
            (identical(other.maxUsesPerBook, maxUsesPerBook) ||
                other.maxUsesPerBook == maxUsesPerBook) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isBaseCoupon, isBaseCoupon) ||
                other.isBaseCoupon == isBaseCoupon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sellerId,
    discountPct,
    adminCommissionPct,
    minSpend,
    maxUsesPerBook,
    type,
    status,
    isBaseCoupon,
  );

  /// Create a copy of RedemptionCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedemptionCouponModelImplCopyWith<_$RedemptionCouponModelImpl>
  get copyWith =>
      __$$RedemptionCouponModelImplCopyWithImpl<_$RedemptionCouponModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RedemptionCouponModelImplToJson(this);
  }
}

abstract class _RedemptionCouponModel implements RedemptionCouponModel {
  const factory _RedemptionCouponModel({
    required final String id,
    required final String sellerId,
    required final double discountPct,
    required final double adminCommissionPct,
    required final double minSpend,
    required final int maxUsesPerBook,
    required final String type,
    required final String status,
    required final bool isBaseCoupon,
  }) = _$RedemptionCouponModelImpl;

  factory _RedemptionCouponModel.fromJson(Map<String, dynamic> json) =
      _$RedemptionCouponModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  double get discountPct;
  @override
  double get adminCommissionPct;
  @override
  double get minSpend;
  @override
  int get maxUsesPerBook;
  @override
  String get type;
  @override
  String get status;
  @override
  bool get isBaseCoupon;

  /// Create a copy of RedemptionCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedemptionCouponModelImplCopyWith<_$RedemptionCouponModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
