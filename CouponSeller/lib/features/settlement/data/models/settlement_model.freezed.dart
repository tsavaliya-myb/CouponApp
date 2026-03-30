// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SettlementResponseModel _$SettlementResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _SettlementResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SettlementResponseModel {
  bool get success => throw _privateConstructorUsedError;
  List<SettlementItemModel> get data => throw _privateConstructorUsedError;
  SettlementMetaModel get meta => throw _privateConstructorUsedError;

  /// Serializes this SettlementResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementResponseModelCopyWith<SettlementResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementResponseModelCopyWith<$Res> {
  factory $SettlementResponseModelCopyWith(
    SettlementResponseModel value,
    $Res Function(SettlementResponseModel) then,
  ) = _$SettlementResponseModelCopyWithImpl<$Res, SettlementResponseModel>;
  @useResult
  $Res call({
    bool success,
    List<SettlementItemModel> data,
    SettlementMetaModel meta,
  });

  $SettlementMetaModelCopyWith<$Res> get meta;
}

/// @nodoc
class _$SettlementResponseModelCopyWithImpl<
  $Res,
  $Val extends SettlementResponseModel
>
    implements $SettlementResponseModelCopyWith<$Res> {
  _$SettlementResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementResponseModel
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
                      as List<SettlementItemModel>,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as SettlementMetaModel,
          )
          as $Val,
    );
  }

  /// Create a copy of SettlementResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettlementMetaModelCopyWith<$Res> get meta {
    return $SettlementMetaModelCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettlementResponseModelImplCopyWith<$Res>
    implements $SettlementResponseModelCopyWith<$Res> {
  factory _$$SettlementResponseModelImplCopyWith(
    _$SettlementResponseModelImpl value,
    $Res Function(_$SettlementResponseModelImpl) then,
  ) = __$$SettlementResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    List<SettlementItemModel> data,
    SettlementMetaModel meta,
  });

  @override
  $SettlementMetaModelCopyWith<$Res> get meta;
}

/// @nodoc
class __$$SettlementResponseModelImplCopyWithImpl<$Res>
    extends
        _$SettlementResponseModelCopyWithImpl<
          $Res,
          _$SettlementResponseModelImpl
        >
    implements _$$SettlementResponseModelImplCopyWith<$Res> {
  __$$SettlementResponseModelImplCopyWithImpl(
    _$SettlementResponseModelImpl _value,
    $Res Function(_$SettlementResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? meta = null,
  }) {
    return _then(
      _$SettlementResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<SettlementItemModel>,
        meta: null == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as SettlementMetaModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementResponseModelImpl implements _SettlementResponseModel {
  const _$SettlementResponseModelImpl({
    required this.success,
    required final List<SettlementItemModel> data,
    required this.meta,
  }) : _data = data;

  factory _$SettlementResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementResponseModelImplFromJson(json);

  @override
  final bool success;
  final List<SettlementItemModel> _data;
  @override
  List<SettlementItemModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final SettlementMetaModel meta;

  @override
  String toString() {
    return 'SettlementResponseModel(success: $success, data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementResponseModelImpl &&
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

  /// Create a copy of SettlementResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementResponseModelImplCopyWith<_$SettlementResponseModelImpl>
  get copyWith =>
      __$$SettlementResponseModelImplCopyWithImpl<
        _$SettlementResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementResponseModelImplToJson(this);
  }
}

abstract class _SettlementResponseModel implements SettlementResponseModel {
  const factory _SettlementResponseModel({
    required final bool success,
    required final List<SettlementItemModel> data,
    required final SettlementMetaModel meta,
  }) = _$SettlementResponseModelImpl;

  factory _SettlementResponseModel.fromJson(Map<String, dynamic> json) =
      _$SettlementResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  List<SettlementItemModel> get data;
  @override
  SettlementMetaModel get meta;

  /// Create a copy of SettlementResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementResponseModelImplCopyWith<_$SettlementResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SettlementItemModel _$SettlementItemModelFromJson(Map<String, dynamic> json) {
  return _SettlementItemModel.fromJson(json);
}

/// @nodoc
mixin _$SettlementItemModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  DateTime get weekStart => throw _privateConstructorUsedError;
  DateTime get weekEnd => throw _privateConstructorUsedError;
  double get commissionTotal => throw _privateConstructorUsedError;
  String get commissionStatus => throw _privateConstructorUsedError;
  DateTime? get commissionPaidAt => throw _privateConstructorUsedError;
  double get coinCompensationTotal => throw _privateConstructorUsedError;
  String get coinCompStatus => throw _privateConstructorUsedError;
  DateTime? get coinCompPaidAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SettlementItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementItemModelCopyWith<SettlementItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementItemModelCopyWith<$Res> {
  factory $SettlementItemModelCopyWith(
    SettlementItemModel value,
    $Res Function(SettlementItemModel) then,
  ) = _$SettlementItemModelCopyWithImpl<$Res, SettlementItemModel>;
  @useResult
  $Res call({
    String id,
    String sellerId,
    DateTime weekStart,
    DateTime weekEnd,
    double commissionTotal,
    String commissionStatus,
    DateTime? commissionPaidAt,
    double coinCompensationTotal,
    String coinCompStatus,
    DateTime? coinCompPaidAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$SettlementItemModelCopyWithImpl<$Res, $Val extends SettlementItemModel>
    implements $SettlementItemModelCopyWith<$Res> {
  _$SettlementItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? commissionTotal = null,
    Object? commissionStatus = null,
    Object? commissionPaidAt = freezed,
    Object? coinCompensationTotal = null,
    Object? coinCompStatus = null,
    Object? coinCompPaidAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            weekStart: null == weekStart
                ? _value.weekStart
                : weekStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            weekEnd: null == weekEnd
                ? _value.weekEnd
                : weekEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            commissionTotal: null == commissionTotal
                ? _value.commissionTotal
                : commissionTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            commissionStatus: null == commissionStatus
                ? _value.commissionStatus
                : commissionStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            commissionPaidAt: freezed == commissionPaidAt
                ? _value.commissionPaidAt
                : commissionPaidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            coinCompensationTotal: null == coinCompensationTotal
                ? _value.coinCompensationTotal
                : coinCompensationTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            coinCompStatus: null == coinCompStatus
                ? _value.coinCompStatus
                : coinCompStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            coinCompPaidAt: freezed == coinCompPaidAt
                ? _value.coinCompPaidAt
                : coinCompPaidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettlementItemModelImplCopyWith<$Res>
    implements $SettlementItemModelCopyWith<$Res> {
  factory _$$SettlementItemModelImplCopyWith(
    _$SettlementItemModelImpl value,
    $Res Function(_$SettlementItemModelImpl) then,
  ) = __$$SettlementItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sellerId,
    DateTime weekStart,
    DateTime weekEnd,
    double commissionTotal,
    String commissionStatus,
    DateTime? commissionPaidAt,
    double coinCompensationTotal,
    String coinCompStatus,
    DateTime? coinCompPaidAt,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$SettlementItemModelImplCopyWithImpl<$Res>
    extends _$SettlementItemModelCopyWithImpl<$Res, _$SettlementItemModelImpl>
    implements _$$SettlementItemModelImplCopyWith<$Res> {
  __$$SettlementItemModelImplCopyWithImpl(
    _$SettlementItemModelImpl _value,
    $Res Function(_$SettlementItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? commissionTotal = null,
    Object? commissionStatus = null,
    Object? commissionPaidAt = freezed,
    Object? coinCompensationTotal = null,
    Object? coinCompStatus = null,
    Object? coinCompPaidAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SettlementItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sellerId: null == sellerId
            ? _value.sellerId
            : sellerId // ignore: cast_nullable_to_non_nullable
                  as String,
        weekStart: null == weekStart
            ? _value.weekStart
            : weekStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        weekEnd: null == weekEnd
            ? _value.weekEnd
            : weekEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        commissionTotal: null == commissionTotal
            ? _value.commissionTotal
            : commissionTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        commissionStatus: null == commissionStatus
            ? _value.commissionStatus
            : commissionStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        commissionPaidAt: freezed == commissionPaidAt
            ? _value.commissionPaidAt
            : commissionPaidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        coinCompensationTotal: null == coinCompensationTotal
            ? _value.coinCompensationTotal
            : coinCompensationTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        coinCompStatus: null == coinCompStatus
            ? _value.coinCompStatus
            : coinCompStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        coinCompPaidAt: freezed == coinCompPaidAt
            ? _value.coinCompPaidAt
            : coinCompPaidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementItemModelImpl implements _SettlementItemModel {
  const _$SettlementItemModelImpl({
    required this.id,
    required this.sellerId,
    required this.weekStart,
    required this.weekEnd,
    required this.commissionTotal,
    required this.commissionStatus,
    this.commissionPaidAt,
    required this.coinCompensationTotal,
    required this.coinCompStatus,
    this.coinCompPaidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$SettlementItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementItemModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final DateTime weekStart;
  @override
  final DateTime weekEnd;
  @override
  final double commissionTotal;
  @override
  final String commissionStatus;
  @override
  final DateTime? commissionPaidAt;
  @override
  final double coinCompensationTotal;
  @override
  final String coinCompStatus;
  @override
  final DateTime? coinCompPaidAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SettlementItemModel(id: $id, sellerId: $sellerId, weekStart: $weekStart, weekEnd: $weekEnd, commissionTotal: $commissionTotal, commissionStatus: $commissionStatus, commissionPaidAt: $commissionPaidAt, coinCompensationTotal: $coinCompensationTotal, coinCompStatus: $coinCompStatus, coinCompPaidAt: $coinCompPaidAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd) &&
            (identical(other.commissionTotal, commissionTotal) ||
                other.commissionTotal == commissionTotal) &&
            (identical(other.commissionStatus, commissionStatus) ||
                other.commissionStatus == commissionStatus) &&
            (identical(other.commissionPaidAt, commissionPaidAt) ||
                other.commissionPaidAt == commissionPaidAt) &&
            (identical(other.coinCompensationTotal, coinCompensationTotal) ||
                other.coinCompensationTotal == coinCompensationTotal) &&
            (identical(other.coinCompStatus, coinCompStatus) ||
                other.coinCompStatus == coinCompStatus) &&
            (identical(other.coinCompPaidAt, coinCompPaidAt) ||
                other.coinCompPaidAt == coinCompPaidAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sellerId,
    weekStart,
    weekEnd,
    commissionTotal,
    commissionStatus,
    commissionPaidAt,
    coinCompensationTotal,
    coinCompStatus,
    coinCompPaidAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SettlementItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementItemModelImplCopyWith<_$SettlementItemModelImpl> get copyWith =>
      __$$SettlementItemModelImplCopyWithImpl<_$SettlementItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementItemModelImplToJson(this);
  }
}

abstract class _SettlementItemModel implements SettlementItemModel {
  const factory _SettlementItemModel({
    required final String id,
    required final String sellerId,
    required final DateTime weekStart,
    required final DateTime weekEnd,
    required final double commissionTotal,
    required final String commissionStatus,
    final DateTime? commissionPaidAt,
    required final double coinCompensationTotal,
    required final String coinCompStatus,
    final DateTime? coinCompPaidAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$SettlementItemModelImpl;

  factory _SettlementItemModel.fromJson(Map<String, dynamic> json) =
      _$SettlementItemModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  DateTime get weekStart;
  @override
  DateTime get weekEnd;
  @override
  double get commissionTotal;
  @override
  String get commissionStatus;
  @override
  DateTime? get commissionPaidAt;
  @override
  double get coinCompensationTotal;
  @override
  String get coinCompStatus;
  @override
  DateTime? get coinCompPaidAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of SettlementItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementItemModelImplCopyWith<_$SettlementItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SettlementMetaModel _$SettlementMetaModelFromJson(Map<String, dynamic> json) {
  return _SettlementMetaModel.fromJson(json);
}

/// @nodoc
mixin _$SettlementMetaModel {
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this SettlementMetaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettlementMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementMetaModelCopyWith<SettlementMetaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementMetaModelCopyWith<$Res> {
  factory $SettlementMetaModelCopyWith(
    SettlementMetaModel value,
    $Res Function(SettlementMetaModel) then,
  ) = _$SettlementMetaModelCopyWithImpl<$Res, SettlementMetaModel>;
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class _$SettlementMetaModelCopyWithImpl<$Res, $Val extends SettlementMetaModel>
    implements $SettlementMetaModelCopyWith<$Res> {
  _$SettlementMetaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettlementMetaModel
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
abstract class _$$SettlementMetaModelImplCopyWith<$Res>
    implements $SettlementMetaModelCopyWith<$Res> {
  factory _$$SettlementMetaModelImplCopyWith(
    _$SettlementMetaModelImpl value,
    $Res Function(_$SettlementMetaModelImpl) then,
  ) = __$$SettlementMetaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int page, int limit, int totalPages});
}

/// @nodoc
class __$$SettlementMetaModelImplCopyWithImpl<$Res>
    extends _$SettlementMetaModelCopyWithImpl<$Res, _$SettlementMetaModelImpl>
    implements _$$SettlementMetaModelImplCopyWith<$Res> {
  __$$SettlementMetaModelImplCopyWithImpl(
    _$SettlementMetaModelImpl _value,
    $Res Function(_$SettlementMetaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettlementMetaModel
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
      _$SettlementMetaModelImpl(
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
class _$SettlementMetaModelImpl implements _SettlementMetaModel {
  const _$SettlementMetaModelImpl({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory _$SettlementMetaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementMetaModelImplFromJson(json);

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
    return 'SettlementMetaModel(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementMetaModelImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, page, limit, totalPages);

  /// Create a copy of SettlementMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementMetaModelImplCopyWith<_$SettlementMetaModelImpl> get copyWith =>
      __$$SettlementMetaModelImplCopyWithImpl<_$SettlementMetaModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementMetaModelImplToJson(this);
  }
}

abstract class _SettlementMetaModel implements SettlementMetaModel {
  const factory _SettlementMetaModel({
    required final int total,
    required final int page,
    required final int limit,
    required final int totalPages,
  }) = _$SettlementMetaModelImpl;

  factory _SettlementMetaModel.fromJson(Map<String, dynamic> json) =
      _$SettlementMetaModelImpl.fromJson;

  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of SettlementMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementMetaModelImplCopyWith<_$SettlementMetaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
