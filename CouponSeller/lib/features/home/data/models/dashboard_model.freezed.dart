// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardResponseModel _$DashboardResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardResponseModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardResponseModel {
  bool get success => throw _privateConstructorUsedError;
  DashboardDataModel get data => throw _privateConstructorUsedError;

  /// Serializes this DashboardResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardResponseModelCopyWith<DashboardResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardResponseModelCopyWith<$Res> {
  factory $DashboardResponseModelCopyWith(
    DashboardResponseModel value,
    $Res Function(DashboardResponseModel) then,
  ) = _$DashboardResponseModelCopyWithImpl<$Res, DashboardResponseModel>;
  @useResult
  $Res call({bool success, DashboardDataModel data});

  $DashboardDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$DashboardResponseModelCopyWithImpl<
  $Res,
  $Val extends DashboardResponseModel
>
    implements $DashboardResponseModelCopyWith<$Res> {
  _$DashboardResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardResponseModel
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
                      as DashboardDataModel,
          )
          as $Val,
    );
  }

  /// Create a copy of DashboardResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardDataModelCopyWith<$Res> get data {
    return $DashboardDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardResponseModelImplCopyWith<$Res>
    implements $DashboardResponseModelCopyWith<$Res> {
  factory _$$DashboardResponseModelImplCopyWith(
    _$DashboardResponseModelImpl value,
    $Res Function(_$DashboardResponseModelImpl) then,
  ) = __$$DashboardResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, DashboardDataModel data});

  @override
  $DashboardDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$DashboardResponseModelImplCopyWithImpl<$Res>
    extends
        _$DashboardResponseModelCopyWithImpl<$Res, _$DashboardResponseModelImpl>
    implements _$$DashboardResponseModelImplCopyWith<$Res> {
  __$$DashboardResponseModelImplCopyWithImpl(
    _$DashboardResponseModelImpl _value,
    $Res Function(_$DashboardResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$DashboardResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as DashboardDataModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardResponseModelImpl implements _DashboardResponseModel {
  const _$DashboardResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$DashboardResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final DashboardDataModel data;

  @override
  String toString() {
    return 'DashboardResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of DashboardResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardResponseModelImplCopyWith<_$DashboardResponseModelImpl>
  get copyWith =>
      __$$DashboardResponseModelImplCopyWithImpl<_$DashboardResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardResponseModelImplToJson(this);
  }
}

abstract class _DashboardResponseModel implements DashboardResponseModel {
  const factory _DashboardResponseModel({
    required final bool success,
    required final DashboardDataModel data,
  }) = _$DashboardResponseModelImpl;

  factory _DashboardResponseModel.fromJson(Map<String, dynamic> json) =
      _$DashboardResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  DashboardDataModel get data;

  /// Create a copy of DashboardResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardResponseModelImplCopyWith<_$DashboardResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) {
  return _DashboardDataModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardDataModel {
  int get totalRedemptions => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get commissionPct => throw _privateConstructorUsedError;
  int get todaysRedemptions => throw _privateConstructorUsedError;
  int get thisWeekRedemptions => throw _privateConstructorUsedError;
  double get commissionOwed => throw _privateConstructorUsedError;
  double get coinReceivable => throw _privateConstructorUsedError;
  List<RecentRedemptionModel> get recentRedemptions =>
      throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;

  /// Serializes this DashboardDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardDataModelCopyWith<DashboardDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataModelCopyWith<$Res> {
  factory $DashboardDataModelCopyWith(
    DashboardDataModel value,
    $Res Function(DashboardDataModel) then,
  ) = _$DashboardDataModelCopyWithImpl<$Res, DashboardDataModel>;
  @useResult
  $Res call({
    int totalRedemptions,
    String status,
    double commissionPct,
    int todaysRedemptions,
    int thisWeekRedemptions,
    double commissionOwed,
    double coinReceivable,
    List<RecentRedemptionModel> recentRedemptions,
    String? businessName,
    String? city,
  });
}

/// @nodoc
class _$DashboardDataModelCopyWithImpl<$Res, $Val extends DashboardDataModel>
    implements $DashboardDataModelCopyWith<$Res> {
  _$DashboardDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRedemptions = null,
    Object? status = null,
    Object? commissionPct = null,
    Object? todaysRedemptions = null,
    Object? thisWeekRedemptions = null,
    Object? commissionOwed = null,
    Object? coinReceivable = null,
    Object? recentRedemptions = null,
    Object? businessName = freezed,
    Object? city = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalRedemptions: null == totalRedemptions
                ? _value.totalRedemptions
                : totalRedemptions // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            commissionPct: null == commissionPct
                ? _value.commissionPct
                : commissionPct // ignore: cast_nullable_to_non_nullable
                      as double,
            todaysRedemptions: null == todaysRedemptions
                ? _value.todaysRedemptions
                : todaysRedemptions // ignore: cast_nullable_to_non_nullable
                      as int,
            thisWeekRedemptions: null == thisWeekRedemptions
                ? _value.thisWeekRedemptions
                : thisWeekRedemptions // ignore: cast_nullable_to_non_nullable
                      as int,
            commissionOwed: null == commissionOwed
                ? _value.commissionOwed
                : commissionOwed // ignore: cast_nullable_to_non_nullable
                      as double,
            coinReceivable: null == coinReceivable
                ? _value.coinReceivable
                : coinReceivable // ignore: cast_nullable_to_non_nullable
                      as double,
            recentRedemptions: null == recentRedemptions
                ? _value.recentRedemptions
                : recentRedemptions // ignore: cast_nullable_to_non_nullable
                      as List<RecentRedemptionModel>,
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardDataModelImplCopyWith<$Res>
    implements $DashboardDataModelCopyWith<$Res> {
  factory _$$DashboardDataModelImplCopyWith(
    _$DashboardDataModelImpl value,
    $Res Function(_$DashboardDataModelImpl) then,
  ) = __$$DashboardDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalRedemptions,
    String status,
    double commissionPct,
    int todaysRedemptions,
    int thisWeekRedemptions,
    double commissionOwed,
    double coinReceivable,
    List<RecentRedemptionModel> recentRedemptions,
    String? businessName,
    String? city,
  });
}

/// @nodoc
class __$$DashboardDataModelImplCopyWithImpl<$Res>
    extends _$DashboardDataModelCopyWithImpl<$Res, _$DashboardDataModelImpl>
    implements _$$DashboardDataModelImplCopyWith<$Res> {
  __$$DashboardDataModelImplCopyWithImpl(
    _$DashboardDataModelImpl _value,
    $Res Function(_$DashboardDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRedemptions = null,
    Object? status = null,
    Object? commissionPct = null,
    Object? todaysRedemptions = null,
    Object? thisWeekRedemptions = null,
    Object? commissionOwed = null,
    Object? coinReceivable = null,
    Object? recentRedemptions = null,
    Object? businessName = freezed,
    Object? city = freezed,
  }) {
    return _then(
      _$DashboardDataModelImpl(
        totalRedemptions: null == totalRedemptions
            ? _value.totalRedemptions
            : totalRedemptions // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        commissionPct: null == commissionPct
            ? _value.commissionPct
            : commissionPct // ignore: cast_nullable_to_non_nullable
                  as double,
        todaysRedemptions: null == todaysRedemptions
            ? _value.todaysRedemptions
            : todaysRedemptions // ignore: cast_nullable_to_non_nullable
                  as int,
        thisWeekRedemptions: null == thisWeekRedemptions
            ? _value.thisWeekRedemptions
            : thisWeekRedemptions // ignore: cast_nullable_to_non_nullable
                  as int,
        commissionOwed: null == commissionOwed
            ? _value.commissionOwed
            : commissionOwed // ignore: cast_nullable_to_non_nullable
                  as double,
        coinReceivable: null == coinReceivable
            ? _value.coinReceivable
            : coinReceivable // ignore: cast_nullable_to_non_nullable
                  as double,
        recentRedemptions: null == recentRedemptions
            ? _value._recentRedemptions
            : recentRedemptions // ignore: cast_nullable_to_non_nullable
                  as List<RecentRedemptionModel>,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataModelImpl implements _DashboardDataModel {
  const _$DashboardDataModelImpl({
    required this.totalRedemptions,
    required this.status,
    required this.commissionPct,
    required this.todaysRedemptions,
    required this.thisWeekRedemptions,
    required this.commissionOwed,
    required this.coinReceivable,
    required final List<RecentRedemptionModel> recentRedemptions,
    this.businessName,
    this.city,
  }) : _recentRedemptions = recentRedemptions;

  factory _$DashboardDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataModelImplFromJson(json);

  @override
  final int totalRedemptions;
  @override
  final String status;
  @override
  final double commissionPct;
  @override
  final int todaysRedemptions;
  @override
  final int thisWeekRedemptions;
  @override
  final double commissionOwed;
  @override
  final double coinReceivable;
  final List<RecentRedemptionModel> _recentRedemptions;
  @override
  List<RecentRedemptionModel> get recentRedemptions {
    if (_recentRedemptions is EqualUnmodifiableListView)
      return _recentRedemptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentRedemptions);
  }

  @override
  final String? businessName;
  @override
  final String? city;

  @override
  String toString() {
    return 'DashboardDataModel(totalRedemptions: $totalRedemptions, status: $status, commissionPct: $commissionPct, todaysRedemptions: $todaysRedemptions, thisWeekRedemptions: $thisWeekRedemptions, commissionOwed: $commissionOwed, coinReceivable: $coinReceivable, recentRedemptions: $recentRedemptions, businessName: $businessName, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataModelImpl &&
            (identical(other.totalRedemptions, totalRedemptions) ||
                other.totalRedemptions == totalRedemptions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.commissionPct, commissionPct) ||
                other.commissionPct == commissionPct) &&
            (identical(other.todaysRedemptions, todaysRedemptions) ||
                other.todaysRedemptions == todaysRedemptions) &&
            (identical(other.thisWeekRedemptions, thisWeekRedemptions) ||
                other.thisWeekRedemptions == thisWeekRedemptions) &&
            (identical(other.commissionOwed, commissionOwed) ||
                other.commissionOwed == commissionOwed) &&
            (identical(other.coinReceivable, coinReceivable) ||
                other.coinReceivable == coinReceivable) &&
            const DeepCollectionEquality().equals(
              other._recentRedemptions,
              _recentRedemptions,
            ) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRedemptions,
    status,
    commissionPct,
    todaysRedemptions,
    thisWeekRedemptions,
    commissionOwed,
    coinReceivable,
    const DeepCollectionEquality().hash(_recentRedemptions),
    businessName,
    city,
  );

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataModelImplCopyWith<_$DashboardDataModelImpl> get copyWith =>
      __$$DashboardDataModelImplCopyWithImpl<_$DashboardDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataModelImplToJson(this);
  }
}

abstract class _DashboardDataModel implements DashboardDataModel {
  const factory _DashboardDataModel({
    required final int totalRedemptions,
    required final String status,
    required final double commissionPct,
    required final int todaysRedemptions,
    required final int thisWeekRedemptions,
    required final double commissionOwed,
    required final double coinReceivable,
    required final List<RecentRedemptionModel> recentRedemptions,
    final String? businessName,
    final String? city,
  }) = _$DashboardDataModelImpl;

  factory _DashboardDataModel.fromJson(Map<String, dynamic> json) =
      _$DashboardDataModelImpl.fromJson;

  @override
  int get totalRedemptions;
  @override
  String get status;
  @override
  double get commissionPct;
  @override
  int get todaysRedemptions;
  @override
  int get thisWeekRedemptions;
  @override
  double get commissionOwed;
  @override
  double get coinReceivable;
  @override
  List<RecentRedemptionModel> get recentRedemptions;
  @override
  String? get businessName;
  @override
  String? get city;

  /// Create a copy of DashboardDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardDataModelImplCopyWith<_$DashboardDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentRedemptionModel _$RecentRedemptionModelFromJson(
  Map<String, dynamic> json,
) {
  return _RecentRedemptionModel.fromJson(json);
}

/// @nodoc
mixin _$RecentRedemptionModel {
  String get id => throw _privateConstructorUsedError;
  String get couponName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecentRedemptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentRedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentRedemptionModelCopyWith<RecentRedemptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentRedemptionModelCopyWith<$Res> {
  factory $RecentRedemptionModelCopyWith(
    RecentRedemptionModel value,
    $Res Function(RecentRedemptionModel) then,
  ) = _$RecentRedemptionModelCopyWithImpl<$Res, RecentRedemptionModel>;
  @useResult
  $Res call({String id, String couponName, double amount, DateTime createdAt});
}

/// @nodoc
class _$RecentRedemptionModelCopyWithImpl<
  $Res,
  $Val extends RecentRedemptionModel
>
    implements $RecentRedemptionModelCopyWith<$Res> {
  _$RecentRedemptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentRedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponName = null,
    Object? amount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            couponName: null == couponName
                ? _value.couponName
                : couponName // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentRedemptionModelImplCopyWith<$Res>
    implements $RecentRedemptionModelCopyWith<$Res> {
  factory _$$RecentRedemptionModelImplCopyWith(
    _$RecentRedemptionModelImpl value,
    $Res Function(_$RecentRedemptionModelImpl) then,
  ) = __$$RecentRedemptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String couponName, double amount, DateTime createdAt});
}

/// @nodoc
class __$$RecentRedemptionModelImplCopyWithImpl<$Res>
    extends
        _$RecentRedemptionModelCopyWithImpl<$Res, _$RecentRedemptionModelImpl>
    implements _$$RecentRedemptionModelImplCopyWith<$Res> {
  __$$RecentRedemptionModelImplCopyWithImpl(
    _$RecentRedemptionModelImpl _value,
    $Res Function(_$RecentRedemptionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentRedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? couponName = null,
    Object? amount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RecentRedemptionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        couponName: null == couponName
            ? _value.couponName
            : couponName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentRedemptionModelImpl implements _RecentRedemptionModel {
  const _$RecentRedemptionModelImpl({
    required this.id,
    required this.couponName,
    required this.amount,
    required this.createdAt,
  });

  factory _$RecentRedemptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentRedemptionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String couponName;
  @override
  final double amount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecentRedemptionModel(id: $id, couponName: $couponName, amount: $amount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentRedemptionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.couponName, couponName) ||
                other.couponName == couponName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, couponName, amount, createdAt);

  /// Create a copy of RecentRedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentRedemptionModelImplCopyWith<_$RecentRedemptionModelImpl>
  get copyWith =>
      __$$RecentRedemptionModelImplCopyWithImpl<_$RecentRedemptionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentRedemptionModelImplToJson(this);
  }
}

abstract class _RecentRedemptionModel implements RecentRedemptionModel {
  const factory _RecentRedemptionModel({
    required final String id,
    required final String couponName,
    required final double amount,
    required final DateTime createdAt,
  }) = _$RecentRedemptionModelImpl;

  factory _RecentRedemptionModel.fromJson(Map<String, dynamic> json) =
      _$RecentRedemptionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get couponName;
  @override
  double get amount;
  @override
  DateTime get createdAt;

  /// Create a copy of RecentRedemptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentRedemptionModelImplCopyWith<_$RecentRedemptionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
