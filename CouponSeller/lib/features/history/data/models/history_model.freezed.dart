// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HistoryResponseModel _$HistoryResponseModelFromJson(Map<String, dynamic> json) {
  return _HistoryResponseModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryResponseModel {
  bool get success => throw _privateConstructorUsedError;
  List<RedemptionModel> get data => throw _privateConstructorUsedError;
  MetaDataModel get meta => throw _privateConstructorUsedError;

  /// Serializes this HistoryResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryResponseModelCopyWith<HistoryResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryResponseModelCopyWith<$Res> {
  factory $HistoryResponseModelCopyWith(
    HistoryResponseModel value,
    $Res Function(HistoryResponseModel) then,
  ) = _$HistoryResponseModelCopyWithImpl<$Res, HistoryResponseModel>;
  @useResult
  $Res call({bool success, List<RedemptionModel> data, MetaDataModel meta});

  $MetaDataModelCopyWith<$Res> get meta;
}

/// @nodoc
class _$HistoryResponseModelCopyWithImpl<
  $Res,
  $Val extends HistoryResponseModel
>
    implements $HistoryResponseModelCopyWith<$Res> {
  _$HistoryResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<RedemptionModel>,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as MetaDataModel,
          )
          as $Val,
    );
  }

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaDataModelCopyWith<$Res> get meta {
    return $MetaDataModelCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HistoryResponseModelImplCopyWith<$Res>
    implements $HistoryResponseModelCopyWith<$Res> {
  factory _$$HistoryResponseModelImplCopyWith(
    _$HistoryResponseModelImpl value,
    $Res Function(_$HistoryResponseModelImpl) then,
  ) = __$$HistoryResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<RedemptionModel> data, MetaDataModel meta});

  @override
  $MetaDataModelCopyWith<$Res> get meta;
}

/// @nodoc
class __$$HistoryResponseModelImplCopyWithImpl<$Res>
    extends _$HistoryResponseModelCopyWithImpl<$Res, _$HistoryResponseModelImpl>
    implements _$$HistoryResponseModelImplCopyWith<$Res> {
  __$$HistoryResponseModelImplCopyWithImpl(
    _$HistoryResponseModelImpl _value,
    $Res Function(_$HistoryResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(
      _$HistoryResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<RedemptionModel>,
        meta: null == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as MetaDataModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryResponseModelImpl implements _HistoryResponseModel {
  const _$HistoryResponseModelImpl({
    required this.success,
    required final List<RedemptionModel> data,
    required this.meta,
  }) : _data = data;

  factory _$HistoryResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryResponseModelImplFromJson(json);

  @override
  final bool success;
  final List<RedemptionModel> _data;
  @override
  List<RedemptionModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final MetaDataModel meta;

  @override
  String toString() {
    return 'HistoryResponseModel(success: $success, data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    meta,
  );

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryResponseModelImplCopyWith<_$HistoryResponseModelImpl>
  get copyWith =>
      __$$HistoryResponseModelImplCopyWithImpl<_$HistoryResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryResponseModelImplToJson(this);
  }
}

abstract class _HistoryResponseModel implements HistoryResponseModel {
  const factory _HistoryResponseModel({
    required final bool success,
    required final List<RedemptionModel> data,
    required final MetaDataModel meta,
  }) = _$HistoryResponseModelImpl;

  factory _HistoryResponseModel.fromJson(Map<String, dynamic> json) =
      _$HistoryResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  List<RedemptionModel> get data;
  @override
  MetaDataModel get meta;

  /// Create a copy of HistoryResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryResponseModelImplCopyWith<_$HistoryResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RedemptionModel _$RedemptionModelFromJson(Map<String, dynamic> json) {
  return _RedemptionModel.fromJson(json);
}

/// @nodoc
mixin _$RedemptionModel {
  String get id => throw _privateConstructorUsedError;
  String get userCouponId => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get billAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get coinsUsed => throw _privateConstructorUsedError;
  double get finalAmount => throw _privateConstructorUsedError;
  DateTime get redeemedAt => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  UserCouponModel? get userCoupon => throw _privateConstructorUsedError;
  SettlementLineModel? get settlementLine => throw _privateConstructorUsedError;

  /// Serializes this RedemptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedemptionModelCopyWith<RedemptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedemptionModelCopyWith<$Res> {
  factory $RedemptionModelCopyWith(
    RedemptionModel value,
    $Res Function(RedemptionModel) then,
  ) = _$RedemptionModelCopyWithImpl<$Res, RedemptionModel>;
  @useResult
  $Res call({
    String id,
    String userCouponId,
    String sellerId,
    String userId,
    double billAmount,
    double discountAmount,
    double coinsUsed,
    double finalAmount,
    DateTime redeemedAt,
    UserModel? user,
    UserCouponModel? userCoupon,
    SettlementLineModel? settlementLine,
  });

  $UserModelCopyWith<$Res>? get user;
  $UserCouponModelCopyWith<$Res>? get userCoupon;
  $SettlementLineModelCopyWith<$Res>? get settlementLine;
}

/// @nodoc
class _$RedemptionModelCopyWithImpl<$Res, $Val extends RedemptionModel>
    implements $RedemptionModelCopyWith<$Res> {
  _$RedemptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userCouponId = null,
    Object? sellerId = null,
    Object? userId = null,
    Object? billAmount = null,
    Object? discountAmount = null,
    Object? coinsUsed = null,
    Object? finalAmount = null,
    Object? redeemedAt = null,
    Object? user = freezed,
    Object? userCoupon = freezed,
    Object? settlementLine = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userCouponId: null == userCouponId
                ? _value.userCouponId
                : userCouponId // ignore: cast_nullable_to_non_nullable
                      as String,
            sellerId: null == sellerId
                ? _value.sellerId
                : sellerId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
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
            finalAmount: null == finalAmount
                ? _value.finalAmount
                : finalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            redeemedAt: null == redeemedAt
                ? _value.redeemedAt
                : redeemedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            userCoupon: freezed == userCoupon
                ? _value.userCoupon
                : userCoupon // ignore: cast_nullable_to_non_nullable
                      as UserCouponModel?,
            settlementLine: freezed == settlementLine
                ? _value.settlementLine
                : settlementLine // ignore: cast_nullable_to_non_nullable
                      as SettlementLineModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCouponModelCopyWith<$Res>? get userCoupon {
    if (_value.userCoupon == null) {
      return null;
    }

    return $UserCouponModelCopyWith<$Res>(_value.userCoupon!, (value) {
      return _then(_value.copyWith(userCoupon: value) as $Val);
    });
  }

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettlementLineModelCopyWith<$Res>? get settlementLine {
    if (_value.settlementLine == null) {
      return null;
    }

    return $SettlementLineModelCopyWith<$Res>(_value.settlementLine!, (value) {
      return _then(_value.copyWith(settlementLine: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RedemptionModelImplCopyWith<$Res>
    implements $RedemptionModelCopyWith<$Res> {
  factory _$$RedemptionModelImplCopyWith(
    _$RedemptionModelImpl value,
    $Res Function(_$RedemptionModelImpl) then,
  ) = __$$RedemptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userCouponId,
    String sellerId,
    String userId,
    double billAmount,
    double discountAmount,
    double coinsUsed,
    double finalAmount,
    DateTime redeemedAt,
    UserModel? user,
    UserCouponModel? userCoupon,
    SettlementLineModel? settlementLine,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
  @override
  $UserCouponModelCopyWith<$Res>? get userCoupon;
  @override
  $SettlementLineModelCopyWith<$Res>? get settlementLine;
}

/// @nodoc
class __$$RedemptionModelImplCopyWithImpl<$Res>
    extends _$RedemptionModelCopyWithImpl<$Res, _$RedemptionModelImpl>
    implements _$$RedemptionModelImplCopyWith<$Res> {
  __$$RedemptionModelImplCopyWithImpl(
    _$RedemptionModelImpl _value,
    $Res Function(_$RedemptionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userCouponId = null,
    Object? sellerId = null,
    Object? userId = null,
    Object? billAmount = null,
    Object? discountAmount = null,
    Object? coinsUsed = null,
    Object? finalAmount = null,
    Object? redeemedAt = null,
    Object? user = freezed,
    Object? userCoupon = freezed,
    Object? settlementLine = freezed,
  }) {
    return _then(
      _$RedemptionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userCouponId: null == userCouponId
            ? _value.userCouponId
            : userCouponId // ignore: cast_nullable_to_non_nullable
                  as String,
        sellerId: null == sellerId
            ? _value.sellerId
            : sellerId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
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
        finalAmount: null == finalAmount
            ? _value.finalAmount
            : finalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        redeemedAt: null == redeemedAt
            ? _value.redeemedAt
            : redeemedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        userCoupon: freezed == userCoupon
            ? _value.userCoupon
            : userCoupon // ignore: cast_nullable_to_non_nullable
                  as UserCouponModel?,
        settlementLine: freezed == settlementLine
            ? _value.settlementLine
            : settlementLine // ignore: cast_nullable_to_non_nullable
                  as SettlementLineModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RedemptionModelImpl implements _RedemptionModel {
  const _$RedemptionModelImpl({
    required this.id,
    required this.userCouponId,
    required this.sellerId,
    required this.userId,
    required this.billAmount,
    required this.discountAmount,
    required this.coinsUsed,
    required this.finalAmount,
    required this.redeemedAt,
    this.user,
    this.userCoupon,
    this.settlementLine,
  });

  factory _$RedemptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedemptionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userCouponId;
  @override
  final String sellerId;
  @override
  final String userId;
  @override
  final double billAmount;
  @override
  final double discountAmount;
  @override
  final double coinsUsed;
  @override
  final double finalAmount;
  @override
  final DateTime redeemedAt;
  @override
  final UserModel? user;
  @override
  final UserCouponModel? userCoupon;
  @override
  final SettlementLineModel? settlementLine;

  @override
  String toString() {
    return 'RedemptionModel(id: $id, userCouponId: $userCouponId, sellerId: $sellerId, userId: $userId, billAmount: $billAmount, discountAmount: $discountAmount, coinsUsed: $coinsUsed, finalAmount: $finalAmount, redeemedAt: $redeemedAt, user: $user, userCoupon: $userCoupon, settlementLine: $settlementLine)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedemptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userCouponId, userCouponId) ||
                other.userCouponId == userCouponId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.billAmount, billAmount) ||
                other.billAmount == billAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.coinsUsed, coinsUsed) ||
                other.coinsUsed == coinsUsed) &&
            (identical(other.finalAmount, finalAmount) ||
                other.finalAmount == finalAmount) &&
            (identical(other.redeemedAt, redeemedAt) ||
                other.redeemedAt == redeemedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userCoupon, userCoupon) ||
                other.userCoupon == userCoupon) &&
            (identical(other.settlementLine, settlementLine) ||
                other.settlementLine == settlementLine));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userCouponId,
    sellerId,
    userId,
    billAmount,
    discountAmount,
    coinsUsed,
    finalAmount,
    redeemedAt,
    user,
    userCoupon,
    settlementLine,
  );

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedemptionModelImplCopyWith<_$RedemptionModelImpl> get copyWith =>
      __$$RedemptionModelImplCopyWithImpl<_$RedemptionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RedemptionModelImplToJson(this);
  }
}

abstract class _RedemptionModel implements RedemptionModel {
  const factory _RedemptionModel({
    required final String id,
    required final String userCouponId,
    required final String sellerId,
    required final String userId,
    required final double billAmount,
    required final double discountAmount,
    required final double coinsUsed,
    required final double finalAmount,
    required final DateTime redeemedAt,
    final UserModel? user,
    final UserCouponModel? userCoupon,
    final SettlementLineModel? settlementLine,
  }) = _$RedemptionModelImpl;

  factory _RedemptionModel.fromJson(Map<String, dynamic> json) =
      _$RedemptionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userCouponId;
  @override
  String get sellerId;
  @override
  String get userId;
  @override
  double get billAmount;
  @override
  double get discountAmount;
  @override
  double get coinsUsed;
  @override
  double get finalAmount;
  @override
  DateTime get redeemedAt;
  @override
  UserModel? get user;
  @override
  UserCouponModel? get userCoupon;
  @override
  SettlementLineModel? get settlementLine;

  /// Create a copy of RedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedemptionModelImplCopyWith<_$RedemptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({String? name, String? phone});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? phone = freezed}) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? phone});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? phone = freezed}) {
    return _then(
      _$UserModelImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({this.name, this.phone});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String? name;
  @override
  final String? phone;

  @override
  String toString() {
    return 'UserModel(name: $name, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, phone);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({final String? name, final String? phone}) =
      _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String? get name;
  @override
  String? get phone;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserCouponModel _$UserCouponModelFromJson(Map<String, dynamic> json) {
  return _UserCouponModel.fromJson(json);
}

/// @nodoc
mixin _$UserCouponModel {
  String get id => throw _privateConstructorUsedError;
  String get couponBookId => throw _privateConstructorUsedError;
  String get couponId => throw _privateConstructorUsedError;
  int get usesRemaining => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  CouponModel? get coupon => throw _privateConstructorUsedError;

  /// Serializes this UserCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCouponModelCopyWith<UserCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCouponModelCopyWith<$Res> {
  factory $UserCouponModelCopyWith(
    UserCouponModel value,
    $Res Function(UserCouponModel) then,
  ) = _$UserCouponModelCopyWithImpl<$Res, UserCouponModel>;
  @useResult
  $Res call({
    String id,
    String couponBookId,
    String couponId,
    int usesRemaining,
    String status,
    DateTime createdAt,
    DateTime updatedAt,
    CouponModel? coupon,
  });

  $CouponModelCopyWith<$Res>? get coupon;
}

/// @nodoc
class _$UserCouponModelCopyWithImpl<$Res, $Val extends UserCouponModel>
    implements $UserCouponModelCopyWith<$Res> {
  _$UserCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCouponModel
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
    Object? coupon = freezed,
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
            coupon: freezed == coupon
                ? _value.coupon
                : coupon // ignore: cast_nullable_to_non_nullable
                      as CouponModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CouponModelCopyWith<$Res>? get coupon {
    if (_value.coupon == null) {
      return null;
    }

    return $CouponModelCopyWith<$Res>(_value.coupon!, (value) {
      return _then(_value.copyWith(coupon: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserCouponModelImplCopyWith<$Res>
    implements $UserCouponModelCopyWith<$Res> {
  factory _$$UserCouponModelImplCopyWith(
    _$UserCouponModelImpl value,
    $Res Function(_$UserCouponModelImpl) then,
  ) = __$$UserCouponModelImplCopyWithImpl<$Res>;
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
    CouponModel? coupon,
  });

  @override
  $CouponModelCopyWith<$Res>? get coupon;
}

/// @nodoc
class __$$UserCouponModelImplCopyWithImpl<$Res>
    extends _$UserCouponModelCopyWithImpl<$Res, _$UserCouponModelImpl>
    implements _$$UserCouponModelImplCopyWith<$Res> {
  __$$UserCouponModelImplCopyWithImpl(
    _$UserCouponModelImpl _value,
    $Res Function(_$UserCouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserCouponModel
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
    Object? coupon = freezed,
  }) {
    return _then(
      _$UserCouponModelImpl(
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
        coupon: freezed == coupon
            ? _value.coupon
            : coupon // ignore: cast_nullable_to_non_nullable
                  as CouponModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCouponModelImpl implements _UserCouponModel {
  const _$UserCouponModelImpl({
    required this.id,
    required this.couponBookId,
    required this.couponId,
    required this.usesRemaining,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.coupon,
  });

  factory _$UserCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCouponModelImplFromJson(json);

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
  final CouponModel? coupon;

  @override
  String toString() {
    return 'UserCouponModel(id: $id, couponBookId: $couponBookId, couponId: $couponId, usesRemaining: $usesRemaining, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, coupon: $coupon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCouponModelImpl &&
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

  /// Create a copy of UserCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCouponModelImplCopyWith<_$UserCouponModelImpl> get copyWith =>
      __$$UserCouponModelImplCopyWithImpl<_$UserCouponModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCouponModelImplToJson(this);
  }
}

abstract class _UserCouponModel implements UserCouponModel {
  const factory _UserCouponModel({
    required final String id,
    required final String couponBookId,
    required final String couponId,
    required final int usesRemaining,
    required final String status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final CouponModel? coupon,
  }) = _$UserCouponModelImpl;

  factory _UserCouponModel.fromJson(Map<String, dynamic> json) =
      _$UserCouponModelImpl.fromJson;

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
  CouponModel? get coupon;

  /// Create a copy of UserCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCouponModelImplCopyWith<_$UserCouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) {
  return _CouponModel.fromJson(json);
}

/// @nodoc
mixin _$CouponModel {
  String get type => throw _privateConstructorUsedError;
  double get discountPct => throw _privateConstructorUsedError;

  /// Serializes this CouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponModelCopyWith<CouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponModelCopyWith<$Res> {
  factory $CouponModelCopyWith(
    CouponModel value,
    $Res Function(CouponModel) then,
  ) = _$CouponModelCopyWithImpl<$Res, CouponModel>;
  @useResult
  $Res call({String type, double discountPct});
}

/// @nodoc
class _$CouponModelCopyWithImpl<$Res, $Val extends CouponModel>
    implements $CouponModelCopyWith<$Res> {
  _$CouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? discountPct = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            discountPct: null == discountPct
                ? _value.discountPct
                : discountPct // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CouponModelImplCopyWith<$Res>
    implements $CouponModelCopyWith<$Res> {
  factory _$$CouponModelImplCopyWith(
    _$CouponModelImpl value,
    $Res Function(_$CouponModelImpl) then,
  ) = __$$CouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, double discountPct});
}

/// @nodoc
class __$$CouponModelImplCopyWithImpl<$Res>
    extends _$CouponModelCopyWithImpl<$Res, _$CouponModelImpl>
    implements _$$CouponModelImplCopyWith<$Res> {
  __$$CouponModelImplCopyWithImpl(
    _$CouponModelImpl _value,
    $Res Function(_$CouponModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? discountPct = null}) {
    return _then(
      _$CouponModelImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        discountPct: null == discountPct
            ? _value.discountPct
            : discountPct // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponModelImpl implements _CouponModel {
  const _$CouponModelImpl({required this.type, required this.discountPct});

  factory _$CouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponModelImplFromJson(json);

  @override
  final String type;
  @override
  final double discountPct;

  @override
  String toString() {
    return 'CouponModel(type: $type, discountPct: $discountPct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.discountPct, discountPct) ||
                other.discountPct == discountPct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, discountPct);

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      __$$CouponModelImplCopyWithImpl<_$CouponModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponModelImplToJson(this);
  }
}

abstract class _CouponModel implements CouponModel {
  const factory _CouponModel({
    required final String type,
    required final double discountPct,
  }) = _$CouponModelImpl;

  factory _CouponModel.fromJson(Map<String, dynamic> json) =
      _$CouponModelImpl.fromJson;

  @override
  String get type;
  @override
  double get discountPct;

  /// Create a copy of CouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponModelImplCopyWith<_$CouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SettlementLineModel _$SettlementLineModelFromJson(Map<String, dynamic> json) {
  return _SettlementLineModel.fromJson(json);
}

/// @nodoc
mixin _$SettlementLineModel {
  double get commissionAmt => throw _privateConstructorUsedError;
  double get coinCompAmt => throw _privateConstructorUsedError;

  /// Serializes this SettlementLineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementLineModelCopyWith<SettlementLineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementLineModelCopyWith<$Res> {
  factory $SettlementLineModelCopyWith(
    SettlementLineModel value,
    $Res Function(SettlementLineModel) then,
  ) = _$SettlementLineModelCopyWithImpl<$Res, SettlementLineModel>;
  @useResult
  $Res call({double commissionAmt, double coinCompAmt});
}

/// @nodoc
class _$SettlementLineModelCopyWithImpl<$Res, $Val extends SettlementLineModel>
    implements $SettlementLineModelCopyWith<$Res> {
  _$SettlementLineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? commissionAmt = null, Object? coinCompAmt = null}) {
    return _then(
      _value.copyWith(
            commissionAmt: null == commissionAmt
                ? _value.commissionAmt
                : commissionAmt // ignore: cast_nullable_to_non_nullable
                      as double,
            coinCompAmt: null == coinCompAmt
                ? _value.coinCompAmt
                : coinCompAmt // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettlementLineModelImplCopyWith<$Res>
    implements $SettlementLineModelCopyWith<$Res> {
  factory _$$SettlementLineModelImplCopyWith(
    _$SettlementLineModelImpl value,
    $Res Function(_$SettlementLineModelImpl) then,
  ) = __$$SettlementLineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double commissionAmt, double coinCompAmt});
}

/// @nodoc
class __$$SettlementLineModelImplCopyWithImpl<$Res>
    extends _$SettlementLineModelCopyWithImpl<$Res, _$SettlementLineModelImpl>
    implements _$$SettlementLineModelImplCopyWith<$Res> {
  __$$SettlementLineModelImplCopyWithImpl(
    _$SettlementLineModelImpl _value,
    $Res Function(_$SettlementLineModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementLineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? commissionAmt = null, Object? coinCompAmt = null}) {
    return _then(
      _$SettlementLineModelImpl(
        commissionAmt: null == commissionAmt
            ? _value.commissionAmt
            : commissionAmt // ignore: cast_nullable_to_non_nullable
                  as double,
        coinCompAmt: null == coinCompAmt
            ? _value.coinCompAmt
            : coinCompAmt // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementLineModelImpl implements _SettlementLineModel {
  const _$SettlementLineModelImpl({
    required this.commissionAmt,
    required this.coinCompAmt,
  });

  factory _$SettlementLineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementLineModelImplFromJson(json);

  @override
  final double commissionAmt;
  @override
  final double coinCompAmt;

  @override
  String toString() {
    return 'SettlementLineModel(commissionAmt: $commissionAmt, coinCompAmt: $coinCompAmt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementLineModelImpl &&
            (identical(other.commissionAmt, commissionAmt) ||
                other.commissionAmt == commissionAmt) &&
            (identical(other.coinCompAmt, coinCompAmt) ||
                other.coinCompAmt == coinCompAmt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, commissionAmt, coinCompAmt);

  /// Create a copy of SettlementLineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementLineModelImplCopyWith<_$SettlementLineModelImpl> get copyWith =>
      __$$SettlementLineModelImplCopyWithImpl<_$SettlementLineModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementLineModelImplToJson(this);
  }
}

abstract class _SettlementLineModel implements SettlementLineModel {
  const factory _SettlementLineModel({
    required final double commissionAmt,
    required final double coinCompAmt,
  }) = _$SettlementLineModelImpl;

  factory _SettlementLineModel.fromJson(Map<String, dynamic> json) =
      _$SettlementLineModelImpl.fromJson;

  @override
  double get commissionAmt;
  @override
  double get coinCompAmt;

  /// Create a copy of SettlementLineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementLineModelImplCopyWith<_$SettlementLineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetaDataModel _$MetaDataModelFromJson(Map<String, dynamic> json) {
  return _MetaDataModel.fromJson(json);
}

/// @nodoc
mixin _$MetaDataModel {
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this MetaDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaDataModelCopyWith<MetaDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaDataModelCopyWith<$Res> {
  factory $MetaDataModelCopyWith(
    MetaDataModel value,
    $Res Function(MetaDataModel) then,
  ) = _$MetaDataModelCopyWithImpl<$Res, MetaDataModel>;
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class _$MetaDataModelCopyWithImpl<$Res, $Val extends MetaDataModel>
    implements $MetaDataModelCopyWith<$Res> {
  _$MetaDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetaDataModelImplCopyWith<$Res>
    implements $MetaDataModelCopyWith<$Res> {
  factory _$$MetaDataModelImplCopyWith(
    _$MetaDataModelImpl value,
    $Res Function(_$MetaDataModelImpl) then,
  ) = __$$MetaDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class __$$MetaDataModelImplCopyWithImpl<$Res>
    extends _$MetaDataModelCopyWithImpl<$Res, _$MetaDataModelImpl>
    implements _$$MetaDataModelImplCopyWith<$Res> {
  __$$MetaDataModelImplCopyWithImpl(
    _$MetaDataModelImpl _value,
    $Res Function(_$MetaDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _$MetaDataModelImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaDataModelImpl implements _MetaDataModel {
  const _$MetaDataModelImpl({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory _$MetaDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaDataModelImplFromJson(json);

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'MetaDataModel(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaDataModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, page, limit, totalPages);

  /// Create a copy of MetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaDataModelImplCopyWith<_$MetaDataModelImpl> get copyWith =>
      __$$MetaDataModelImplCopyWithImpl<_$MetaDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaDataModelImplToJson(this);
  }
}

abstract class _MetaDataModel implements MetaDataModel {
  const factory _MetaDataModel({
    required final int total,
    required final int page,
    required final int limit,
    required final int totalPages,
  }) = _$MetaDataModelImpl;

  factory _MetaDataModel.fromJson(Map<String, dynamic> json) =
      _$MetaDataModelImpl.fromJson;

  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of MetaDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaDataModelImplCopyWith<_$MetaDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
