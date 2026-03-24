// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerAreaModel _$SellerAreaModelFromJson(Map<String, dynamic> json) {
  return _SellerAreaModel.fromJson(json);
}

/// @nodoc
mixin _$SellerAreaModel {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SellerAreaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerAreaModelCopyWith<SellerAreaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerAreaModelCopyWith<$Res> {
  factory $SellerAreaModelCopyWith(
          SellerAreaModel value, $Res Function(SellerAreaModel) then) =
      _$SellerAreaModelCopyWithImpl<$Res, SellerAreaModel>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$SellerAreaModelCopyWithImpl<$Res, $Val extends SellerAreaModel>
    implements $SellerAreaModelCopyWith<$Res> {
  _$SellerAreaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerAreaModelImplCopyWith<$Res>
    implements $SellerAreaModelCopyWith<$Res> {
  factory _$$SellerAreaModelImplCopyWith(_$SellerAreaModelImpl value,
          $Res Function(_$SellerAreaModelImpl) then) =
      __$$SellerAreaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$SellerAreaModelImplCopyWithImpl<$Res>
    extends _$SellerAreaModelCopyWithImpl<$Res, _$SellerAreaModelImpl>
    implements _$$SellerAreaModelImplCopyWith<$Res> {
  __$$SellerAreaModelImplCopyWithImpl(
      _$SellerAreaModelImpl _value, $Res Function(_$SellerAreaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$SellerAreaModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerAreaModelImpl implements _SellerAreaModel {
  const _$SellerAreaModelImpl({required this.name});

  factory _$SellerAreaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerAreaModelImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'SellerAreaModel(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerAreaModelImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerAreaModelImplCopyWith<_$SellerAreaModelImpl> get copyWith =>
      __$$SellerAreaModelImplCopyWithImpl<_$SellerAreaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerAreaModelImplToJson(
      this,
    );
  }
}

abstract class _SellerAreaModel implements SellerAreaModel {
  const factory _SellerAreaModel({required final String name}) =
      _$SellerAreaModelImpl;

  factory _SellerAreaModel.fromJson(Map<String, dynamic> json) =
      _$SellerAreaModelImpl.fromJson;

  @override
  String get name;

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerAreaModelImplCopyWith<_$SellerAreaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CouponSellerModel _$CouponSellerModelFromJson(Map<String, dynamic> json) {
  return _CouponSellerModel.fromJson(json);
}

/// @nodoc
mixin _$CouponSellerModel {
  String get id => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  SellerAreaModel get area => throw _privateConstructorUsedError;

  /// Serializes this CouponSellerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponSellerModelCopyWith<CouponSellerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponSellerModelCopyWith<$Res> {
  factory $CouponSellerModelCopyWith(
          CouponSellerModel value, $Res Function(CouponSellerModel) then) =
      _$CouponSellerModelCopyWithImpl<$Res, CouponSellerModel>;
  @useResult
  $Res call(
      {String id, String businessName, String category, SellerAreaModel area});

  $SellerAreaModelCopyWith<$Res> get area;
}

/// @nodoc
class _$CouponSellerModelCopyWithImpl<$Res, $Val extends CouponSellerModel>
    implements $CouponSellerModelCopyWith<$Res> {
  _$CouponSellerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? area = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as SellerAreaModel,
    ) as $Val);
  }

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerAreaModelCopyWith<$Res> get area {
    return $SellerAreaModelCopyWith<$Res>(_value.area, (value) {
      return _then(_value.copyWith(area: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CouponSellerModelImplCopyWith<$Res>
    implements $CouponSellerModelCopyWith<$Res> {
  factory _$$CouponSellerModelImplCopyWith(_$CouponSellerModelImpl value,
          $Res Function(_$CouponSellerModelImpl) then) =
      __$$CouponSellerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String businessName, String category, SellerAreaModel area});

  @override
  $SellerAreaModelCopyWith<$Res> get area;
}

/// @nodoc
class __$$CouponSellerModelImplCopyWithImpl<$Res>
    extends _$CouponSellerModelCopyWithImpl<$Res, _$CouponSellerModelImpl>
    implements _$$CouponSellerModelImplCopyWith<$Res> {
  __$$CouponSellerModelImplCopyWithImpl(_$CouponSellerModelImpl _value,
      $Res Function(_$CouponSellerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? area = null,
  }) {
    return _then(_$CouponSellerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      area: null == area
          ? _value.area
          : area // ignore: cast_nullable_to_non_nullable
              as SellerAreaModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponSellerModelImpl implements _CouponSellerModel {
  const _$CouponSellerModelImpl(
      {required this.id,
      required this.businessName,
      required this.category,
      required this.area});

  factory _$CouponSellerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponSellerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String businessName;
  @override
  final String category;
  @override
  final SellerAreaModel area;

  @override
  String toString() {
    return 'CouponSellerModel(id: $id, businessName: $businessName, category: $category, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponSellerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.area, area) || other.area == area));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, businessName, category, area);

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponSellerModelImplCopyWith<_$CouponSellerModelImpl> get copyWith =>
      __$$CouponSellerModelImplCopyWithImpl<_$CouponSellerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponSellerModelImplToJson(
      this,
    );
  }
}

abstract class _CouponSellerModel implements CouponSellerModel {
  const factory _CouponSellerModel(
      {required final String id,
      required final String businessName,
      required final String category,
      required final SellerAreaModel area}) = _$CouponSellerModelImpl;

  factory _CouponSellerModel.fromJson(Map<String, dynamic> json) =
      _$CouponSellerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get businessName;
  @override
  String get category;
  @override
  SellerAreaModel get area;

  /// Create a copy of CouponSellerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponSellerModelImplCopyWith<_$CouponSellerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CouponDetailModel _$CouponDetailModelFromJson(Map<String, dynamic> json) {
  return _CouponDetailModel.fromJson(json);
}

/// @nodoc
mixin _$CouponDetailModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  int get discountPct => throw _privateConstructorUsedError;
  int get adminCommissionPct => throw _privateConstructorUsedError;
  int? get minSpend => throw _privateConstructorUsedError;
  int get maxUsesPerBook => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isBaseCoupon => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  CouponSellerModel get seller => throw _privateConstructorUsedError;

  /// Serializes this CouponDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponDetailModelCopyWith<CouponDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponDetailModelCopyWith<$Res> {
  factory $CouponDetailModelCopyWith(
          CouponDetailModel value, $Res Function(CouponDetailModel) then) =
      _$CouponDetailModelCopyWithImpl<$Res, CouponDetailModel>;
  @useResult
  $Res call(
      {String id,
      String sellerId,
      int discountPct,
      int adminCommissionPct,
      int? minSpend,
      int maxUsesPerBook,
      String type,
      String status,
      bool isBaseCoupon,
      String createdAt,
      String updatedAt,
      CouponSellerModel seller});

  $CouponSellerModelCopyWith<$Res> get seller;
}

/// @nodoc
class _$CouponDetailModelCopyWithImpl<$Res, $Val extends CouponDetailModel>
    implements $CouponDetailModelCopyWith<$Res> {
  _$CouponDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? discountPct = null,
    Object? adminCommissionPct = null,
    Object? minSpend = freezed,
    Object? maxUsesPerBook = null,
    Object? type = null,
    Object? status = null,
    Object? isBaseCoupon = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? seller = null,
  }) {
    return _then(_value.copyWith(
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
              as int,
      adminCommissionPct: null == adminCommissionPct
          ? _value.adminCommissionPct
          : adminCommissionPct // ignore: cast_nullable_to_non_nullable
              as int,
      minSpend: freezed == minSpend
          ? _value.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as int?,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      seller: null == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as CouponSellerModel,
    ) as $Val);
  }

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CouponSellerModelCopyWith<$Res> get seller {
    return $CouponSellerModelCopyWith<$Res>(_value.seller, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CouponDetailModelImplCopyWith<$Res>
    implements $CouponDetailModelCopyWith<$Res> {
  factory _$$CouponDetailModelImplCopyWith(_$CouponDetailModelImpl value,
          $Res Function(_$CouponDetailModelImpl) then) =
      __$$CouponDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sellerId,
      int discountPct,
      int adminCommissionPct,
      int? minSpend,
      int maxUsesPerBook,
      String type,
      String status,
      bool isBaseCoupon,
      String createdAt,
      String updatedAt,
      CouponSellerModel seller});

  @override
  $CouponSellerModelCopyWith<$Res> get seller;
}

/// @nodoc
class __$$CouponDetailModelImplCopyWithImpl<$Res>
    extends _$CouponDetailModelCopyWithImpl<$Res, _$CouponDetailModelImpl>
    implements _$$CouponDetailModelImplCopyWith<$Res> {
  __$$CouponDetailModelImplCopyWithImpl(_$CouponDetailModelImpl _value,
      $Res Function(_$CouponDetailModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? discountPct = null,
    Object? adminCommissionPct = null,
    Object? minSpend = freezed,
    Object? maxUsesPerBook = null,
    Object? type = null,
    Object? status = null,
    Object? isBaseCoupon = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? seller = null,
  }) {
    return _then(_$CouponDetailModelImpl(
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
              as int,
      adminCommissionPct: null == adminCommissionPct
          ? _value.adminCommissionPct
          : adminCommissionPct // ignore: cast_nullable_to_non_nullable
              as int,
      minSpend: freezed == minSpend
          ? _value.minSpend
          : minSpend // ignore: cast_nullable_to_non_nullable
              as int?,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      seller: null == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as CouponSellerModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponDetailModelImpl implements _CouponDetailModel {
  const _$CouponDetailModelImpl(
      {required this.id,
      required this.sellerId,
      required this.discountPct,
      required this.adminCommissionPct,
      this.minSpend,
      required this.maxUsesPerBook,
      required this.type,
      required this.status,
      required this.isBaseCoupon,
      required this.createdAt,
      required this.updatedAt,
      required this.seller});

  factory _$CouponDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponDetailModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final int discountPct;
  @override
  final int adminCommissionPct;
  @override
  final int? minSpend;
  @override
  final int maxUsesPerBook;
  @override
  final String type;
  @override
  final String status;
  @override
  final bool isBaseCoupon;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final CouponSellerModel seller;

  @override
  String toString() {
    return 'CouponDetailModel(id: $id, sellerId: $sellerId, discountPct: $discountPct, adminCommissionPct: $adminCommissionPct, minSpend: $minSpend, maxUsesPerBook: $maxUsesPerBook, type: $type, status: $status, isBaseCoupon: $isBaseCoupon, createdAt: $createdAt, updatedAt: $updatedAt, seller: $seller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponDetailModelImpl &&
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
                other.isBaseCoupon == isBaseCoupon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.seller, seller) || other.seller == seller));
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
      createdAt,
      updatedAt,
      seller);

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponDetailModelImplCopyWith<_$CouponDetailModelImpl> get copyWith =>
      __$$CouponDetailModelImplCopyWithImpl<_$CouponDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponDetailModelImplToJson(
      this,
    );
  }
}

abstract class _CouponDetailModel implements CouponDetailModel {
  const factory _CouponDetailModel(
      {required final String id,
      required final String sellerId,
      required final int discountPct,
      required final int adminCommissionPct,
      final int? minSpend,
      required final int maxUsesPerBook,
      required final String type,
      required final String status,
      required final bool isBaseCoupon,
      required final String createdAt,
      required final String updatedAt,
      required final CouponSellerModel seller}) = _$CouponDetailModelImpl;

  factory _CouponDetailModel.fromJson(Map<String, dynamic> json) =
      _$CouponDetailModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  int get discountPct;
  @override
  int get adminCommissionPct;
  @override
  int? get minSpend;
  @override
  int get maxUsesPerBook;
  @override
  String get type;
  @override
  String get status;
  @override
  bool get isBaseCoupon;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  CouponSellerModel get seller;

  /// Create a copy of CouponDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponDetailModelImplCopyWith<_$CouponDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CouponBookModel _$CouponBookModelFromJson(Map<String, dynamic> json) {
  return _CouponBookModel.fromJson(json);
}

/// @nodoc
mixin _$CouponBookModel {
  String get validUntil => throw _privateConstructorUsedError;

  /// Serializes this CouponBookModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CouponBookModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponBookModelCopyWith<CouponBookModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponBookModelCopyWith<$Res> {
  factory $CouponBookModelCopyWith(
          CouponBookModel value, $Res Function(CouponBookModel) then) =
      _$CouponBookModelCopyWithImpl<$Res, CouponBookModel>;
  @useResult
  $Res call({String validUntil});
}

/// @nodoc
class _$CouponBookModelCopyWithImpl<$Res, $Val extends CouponBookModel>
    implements $CouponBookModelCopyWith<$Res> {
  _$CouponBookModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CouponBookModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? validUntil = null,
  }) {
    return _then(_value.copyWith(
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CouponBookModelImplCopyWith<$Res>
    implements $CouponBookModelCopyWith<$Res> {
  factory _$$CouponBookModelImplCopyWith(_$CouponBookModelImpl value,
          $Res Function(_$CouponBookModelImpl) then) =
      __$$CouponBookModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String validUntil});
}

/// @nodoc
class __$$CouponBookModelImplCopyWithImpl<$Res>
    extends _$CouponBookModelCopyWithImpl<$Res, _$CouponBookModelImpl>
    implements _$$CouponBookModelImplCopyWith<$Res> {
  __$$CouponBookModelImplCopyWithImpl(
      _$CouponBookModelImpl _value, $Res Function(_$CouponBookModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CouponBookModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? validUntil = null,
  }) {
    return _then(_$CouponBookModelImpl(
      validUntil: null == validUntil
          ? _value.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CouponBookModelImpl implements _CouponBookModel {
  const _$CouponBookModelImpl({required this.validUntil});

  factory _$CouponBookModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CouponBookModelImplFromJson(json);

  @override
  final String validUntil;

  @override
  String toString() {
    return 'CouponBookModel(validUntil: $validUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponBookModelImpl &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, validUntil);

  /// Create a copy of CouponBookModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponBookModelImplCopyWith<_$CouponBookModelImpl> get copyWith =>
      __$$CouponBookModelImplCopyWithImpl<_$CouponBookModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CouponBookModelImplToJson(
      this,
    );
  }
}

abstract class _CouponBookModel implements CouponBookModel {
  const factory _CouponBookModel({required final String validUntil}) =
      _$CouponBookModelImpl;

  factory _CouponBookModel.fromJson(Map<String, dynamic> json) =
      _$CouponBookModelImpl.fromJson;

  @override
  String get validUntil;

  /// Create a copy of CouponBookModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponBookModelImplCopyWith<_$CouponBookModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeCouponModel _$HomeCouponModelFromJson(Map<String, dynamic> json) {
  return _HomeCouponModel.fromJson(json);
}

/// @nodoc
mixin _$HomeCouponModel {
  String get id => throw _privateConstructorUsedError;
  String get couponBookId => throw _privateConstructorUsedError;
  String get couponId => throw _privateConstructorUsedError;
  int get usesRemaining => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  CouponDetailModel get coupon => throw _privateConstructorUsedError;
  CouponBookModel get couponBook => throw _privateConstructorUsedError;

  /// Serializes this HomeCouponModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeCouponModelCopyWith<HomeCouponModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeCouponModelCopyWith<$Res> {
  factory $HomeCouponModelCopyWith(
          HomeCouponModel value, $Res Function(HomeCouponModel) then) =
      _$HomeCouponModelCopyWithImpl<$Res, HomeCouponModel>;
  @useResult
  $Res call(
      {String id,
      String couponBookId,
      String couponId,
      int usesRemaining,
      String status,
      String createdAt,
      String updatedAt,
      CouponDetailModel coupon,
      CouponBookModel couponBook});

  $CouponDetailModelCopyWith<$Res> get coupon;
  $CouponBookModelCopyWith<$Res> get couponBook;
}

/// @nodoc
class _$HomeCouponModelCopyWithImpl<$Res, $Val extends HomeCouponModel>
    implements $HomeCouponModelCopyWith<$Res> {
  _$HomeCouponModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeCouponModel
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
    Object? couponBook = null,
  }) {
    return _then(_value.copyWith(
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
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      coupon: null == coupon
          ? _value.coupon
          : coupon // ignore: cast_nullable_to_non_nullable
              as CouponDetailModel,
      couponBook: null == couponBook
          ? _value.couponBook
          : couponBook // ignore: cast_nullable_to_non_nullable
              as CouponBookModel,
    ) as $Val);
  }

  /// Create a copy of HomeCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CouponDetailModelCopyWith<$Res> get coupon {
    return $CouponDetailModelCopyWith<$Res>(_value.coupon, (value) {
      return _then(_value.copyWith(coupon: value) as $Val);
    });
  }

  /// Create a copy of HomeCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CouponBookModelCopyWith<$Res> get couponBook {
    return $CouponBookModelCopyWith<$Res>(_value.couponBook, (value) {
      return _then(_value.copyWith(couponBook: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeCouponModelImplCopyWith<$Res>
    implements $HomeCouponModelCopyWith<$Res> {
  factory _$$HomeCouponModelImplCopyWith(_$HomeCouponModelImpl value,
          $Res Function(_$HomeCouponModelImpl) then) =
      __$$HomeCouponModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String couponBookId,
      String couponId,
      int usesRemaining,
      String status,
      String createdAt,
      String updatedAt,
      CouponDetailModel coupon,
      CouponBookModel couponBook});

  @override
  $CouponDetailModelCopyWith<$Res> get coupon;
  @override
  $CouponBookModelCopyWith<$Res> get couponBook;
}

/// @nodoc
class __$$HomeCouponModelImplCopyWithImpl<$Res>
    extends _$HomeCouponModelCopyWithImpl<$Res, _$HomeCouponModelImpl>
    implements _$$HomeCouponModelImplCopyWith<$Res> {
  __$$HomeCouponModelImplCopyWithImpl(
      _$HomeCouponModelImpl _value, $Res Function(_$HomeCouponModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeCouponModel
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
    Object? couponBook = null,
  }) {
    return _then(_$HomeCouponModelImpl(
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
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      coupon: null == coupon
          ? _value.coupon
          : coupon // ignore: cast_nullable_to_non_nullable
              as CouponDetailModel,
      couponBook: null == couponBook
          ? _value.couponBook
          : couponBook // ignore: cast_nullable_to_non_nullable
              as CouponBookModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeCouponModelImpl implements _HomeCouponModel {
  const _$HomeCouponModelImpl(
      {required this.id,
      required this.couponBookId,
      required this.couponId,
      required this.usesRemaining,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.coupon,
      required this.couponBook});

  factory _$HomeCouponModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeCouponModelImplFromJson(json);

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
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final CouponDetailModel coupon;
  @override
  final CouponBookModel couponBook;

  @override
  String toString() {
    return 'HomeCouponModel(id: $id, couponBookId: $couponBookId, couponId: $couponId, usesRemaining: $usesRemaining, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, coupon: $coupon, couponBook: $couponBook)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeCouponModelImpl &&
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
            (identical(other.coupon, coupon) || other.coupon == coupon) &&
            (identical(other.couponBook, couponBook) ||
                other.couponBook == couponBook));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, couponBookId, couponId,
      usesRemaining, status, createdAt, updatedAt, coupon, couponBook);

  /// Create a copy of HomeCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeCouponModelImplCopyWith<_$HomeCouponModelImpl> get copyWith =>
      __$$HomeCouponModelImplCopyWithImpl<_$HomeCouponModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeCouponModelImplToJson(
      this,
    );
  }
}

abstract class _HomeCouponModel implements HomeCouponModel {
  const factory _HomeCouponModel(
      {required final String id,
      required final String couponBookId,
      required final String couponId,
      required final int usesRemaining,
      required final String status,
      required final String createdAt,
      required final String updatedAt,
      required final CouponDetailModel coupon,
      required final CouponBookModel couponBook}) = _$HomeCouponModelImpl;

  factory _HomeCouponModel.fromJson(Map<String, dynamic> json) =
      _$HomeCouponModelImpl.fromJson;

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
  String get createdAt;
  @override
  String get updatedAt;
  @override
  CouponDetailModel get coupon;
  @override
  CouponBookModel get couponBook;

  /// Create a copy of HomeCouponModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeCouponModelImplCopyWith<_$HomeCouponModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
