// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SellerProfileResponseModel _$SellerProfileResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _SellerProfileResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SellerProfileResponseModel {
  bool get success => throw _privateConstructorUsedError;
  SellerProfileModel get data => throw _privateConstructorUsedError;

  /// Serializes this SellerProfileResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerProfileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerProfileResponseModelCopyWith<SellerProfileResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerProfileResponseModelCopyWith<$Res> {
  factory $SellerProfileResponseModelCopyWith(
    SellerProfileResponseModel value,
    $Res Function(SellerProfileResponseModel) then,
  ) =
      _$SellerProfileResponseModelCopyWithImpl<
        $Res,
        SellerProfileResponseModel
      >;
  @useResult
  $Res call({bool success, SellerProfileModel data});

  $SellerProfileModelCopyWith<$Res> get data;
}

/// @nodoc
class _$SellerProfileResponseModelCopyWithImpl<
  $Res,
  $Val extends SellerProfileResponseModel
>
    implements $SellerProfileResponseModelCopyWith<$Res> {
  _$SellerProfileResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerProfileResponseModel
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
                      as SellerProfileModel,
          )
          as $Val,
    );
  }

  /// Create a copy of SellerProfileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerProfileModelCopyWith<$Res> get data {
    return $SellerProfileModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SellerProfileResponseModelImplCopyWith<$Res>
    implements $SellerProfileResponseModelCopyWith<$Res> {
  factory _$$SellerProfileResponseModelImplCopyWith(
    _$SellerProfileResponseModelImpl value,
    $Res Function(_$SellerProfileResponseModelImpl) then,
  ) = __$$SellerProfileResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, SellerProfileModel data});

  @override
  $SellerProfileModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$SellerProfileResponseModelImplCopyWithImpl<$Res>
    extends
        _$SellerProfileResponseModelCopyWithImpl<
          $Res,
          _$SellerProfileResponseModelImpl
        >
    implements _$$SellerProfileResponseModelImplCopyWith<$Res> {
  __$$SellerProfileResponseModelImplCopyWithImpl(
    _$SellerProfileResponseModelImpl _value,
    $Res Function(_$SellerProfileResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerProfileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$SellerProfileResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as SellerProfileModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerProfileResponseModelImpl implements _SellerProfileResponseModel {
  const _$SellerProfileResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$SellerProfileResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$SellerProfileResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final SellerProfileModel data;

  @override
  String toString() {
    return 'SellerProfileResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerProfileResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of SellerProfileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerProfileResponseModelImplCopyWith<_$SellerProfileResponseModelImpl>
  get copyWith =>
      __$$SellerProfileResponseModelImplCopyWithImpl<
        _$SellerProfileResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerProfileResponseModelImplToJson(this);
  }
}

abstract class _SellerProfileResponseModel
    implements SellerProfileResponseModel {
  const factory _SellerProfileResponseModel({
    required final bool success,
    required final SellerProfileModel data,
  }) = _$SellerProfileResponseModelImpl;

  factory _SellerProfileResponseModel.fromJson(Map<String, dynamic> json) =
      _$SellerProfileResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  SellerProfileModel get data;

  /// Create a copy of SellerProfileResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerProfileResponseModelImplCopyWith<_$SellerProfileResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SellerProfileModel _$SellerProfileModelFromJson(Map<String, dynamic> json) {
  return _SellerProfileModel.fromJson(json);
}

/// @nodoc
mixin _$SellerProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;
  String get areaId => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get upiId => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get operatingHours => throw _privateConstructorUsedError;
  double get commissionPct => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get onesignalPlayerId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  SellerCityModel get city => throw _privateConstructorUsedError;
  SellerAreaModel get area => throw _privateConstructorUsedError;
  SellerMediaModel? get media => throw _privateConstructorUsedError;

  /// Serializes this SellerProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerProfileModelCopyWith<SellerProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerProfileModelCopyWith<$Res> {
  factory $SellerProfileModelCopyWith(
    SellerProfileModel value,
    $Res Function(SellerProfileModel) then,
  ) = _$SellerProfileModelCopyWithImpl<$Res, SellerProfileModel>;
  @useResult
  $Res call({
    String id,
    String businessName,
    String category,
    String cityId,
    String areaId,
    String? address,
    String phone,
    String? email,
    String? upiId,
    double? latitude,
    double? longitude,
    String? operatingHours,
    double commissionPct,
    String status,
    String? onesignalPlayerId,
    String createdAt,
    String updatedAt,
    SellerCityModel city,
    SellerAreaModel area,
    SellerMediaModel? media,
  });

  $SellerCityModelCopyWith<$Res> get city;
  $SellerAreaModelCopyWith<$Res> get area;
  $SellerMediaModelCopyWith<$Res>? get media;
}

/// @nodoc
class _$SellerProfileModelCopyWithImpl<$Res, $Val extends SellerProfileModel>
    implements $SellerProfileModelCopyWith<$Res> {
  _$SellerProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? cityId = null,
    Object? areaId = null,
    Object? address = freezed,
    Object? phone = null,
    Object? email = freezed,
    Object? upiId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? operatingHours = freezed,
    Object? commissionPct = null,
    Object? status = null,
    Object? onesignalPlayerId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? city = null,
    Object? area = null,
    Object? media = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            areaId: null == areaId
                ? _value.areaId
                : areaId // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            upiId: freezed == upiId
                ? _value.upiId
                : upiId // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            commissionPct: null == commissionPct
                ? _value.commissionPct
                : commissionPct // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            onesignalPlayerId: freezed == onesignalPlayerId
                ? _value.onesignalPlayerId
                : onesignalPlayerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as SellerCityModel,
            area: null == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as SellerAreaModel,
            media: freezed == media
                ? _value.media
                : media // ignore: cast_nullable_to_non_nullable
                      as SellerMediaModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerCityModelCopyWith<$Res> get city {
    return $SellerCityModelCopyWith<$Res>(_value.city, (value) {
      return _then(_value.copyWith(city: value) as $Val);
    });
  }

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerAreaModelCopyWith<$Res> get area {
    return $SellerAreaModelCopyWith<$Res>(_value.area, (value) {
      return _then(_value.copyWith(area: value) as $Val);
    });
  }

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerMediaModelCopyWith<$Res>? get media {
    if (_value.media == null) {
      return null;
    }

    return $SellerMediaModelCopyWith<$Res>(_value.media!, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SellerProfileModelImplCopyWith<$Res>
    implements $SellerProfileModelCopyWith<$Res> {
  factory _$$SellerProfileModelImplCopyWith(
    _$SellerProfileModelImpl value,
    $Res Function(_$SellerProfileModelImpl) then,
  ) = __$$SellerProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String businessName,
    String category,
    String cityId,
    String areaId,
    String? address,
    String phone,
    String? email,
    String? upiId,
    double? latitude,
    double? longitude,
    String? operatingHours,
    double commissionPct,
    String status,
    String? onesignalPlayerId,
    String createdAt,
    String updatedAt,
    SellerCityModel city,
    SellerAreaModel area,
    SellerMediaModel? media,
  });

  @override
  $SellerCityModelCopyWith<$Res> get city;
  @override
  $SellerAreaModelCopyWith<$Res> get area;
  @override
  $SellerMediaModelCopyWith<$Res>? get media;
}

/// @nodoc
class __$$SellerProfileModelImplCopyWithImpl<$Res>
    extends _$SellerProfileModelCopyWithImpl<$Res, _$SellerProfileModelImpl>
    implements _$$SellerProfileModelImplCopyWith<$Res> {
  __$$SellerProfileModelImplCopyWithImpl(
    _$SellerProfileModelImpl _value,
    $Res Function(_$SellerProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? cityId = null,
    Object? areaId = null,
    Object? address = freezed,
    Object? phone = null,
    Object? email = freezed,
    Object? upiId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? operatingHours = freezed,
    Object? commissionPct = null,
    Object? status = null,
    Object? onesignalPlayerId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? city = null,
    Object? area = null,
    Object? media = freezed,
  }) {
    return _then(
      _$SellerProfileModelImpl(
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
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        areaId: null == areaId
            ? _value.areaId
            : areaId // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        upiId: freezed == upiId
            ? _value.upiId
            : upiId // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        commissionPct: null == commissionPct
            ? _value.commissionPct
            : commissionPct // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        onesignalPlayerId: freezed == onesignalPlayerId
            ? _value.onesignalPlayerId
            : onesignalPlayerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as SellerCityModel,
        area: null == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as SellerAreaModel,
        media: freezed == media
            ? _value.media
            : media // ignore: cast_nullable_to_non_nullable
                  as SellerMediaModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerProfileModelImpl implements _SellerProfileModel {
  const _$SellerProfileModelImpl({
    required this.id,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    this.address,
    required this.phone,
    this.email,
    this.upiId,
    this.latitude,
    this.longitude,
    this.operatingHours,
    required this.commissionPct,
    required this.status,
    this.onesignalPlayerId,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
    required this.area,
    this.media,
  });

  factory _$SellerProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String businessName;
  @override
  final String category;
  @override
  final String cityId;
  @override
  final String areaId;
  @override
  final String? address;
  @override
  final String phone;
  @override
  final String? email;
  @override
  final String? upiId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? operatingHours;
  @override
  final double commissionPct;
  @override
  final String status;
  @override
  final String? onesignalPlayerId;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final SellerCityModel city;
  @override
  final SellerAreaModel area;
  @override
  final SellerMediaModel? media;

  @override
  String toString() {
    return 'SellerProfileModel(id: $id, businessName: $businessName, category: $category, cityId: $cityId, areaId: $areaId, address: $address, phone: $phone, email: $email, upiId: $upiId, latitude: $latitude, longitude: $longitude, operatingHours: $operatingHours, commissionPct: $commissionPct, status: $status, onesignalPlayerId: $onesignalPlayerId, createdAt: $createdAt, updatedAt: $updatedAt, city: $city, area: $area, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.commissionPct, commissionPct) ||
                other.commissionPct == commissionPct) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.onesignalPlayerId, onesignalPlayerId) ||
                other.onesignalPlayerId == onesignalPlayerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.media, media) || other.media == media));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    businessName,
    category,
    cityId,
    areaId,
    address,
    phone,
    email,
    upiId,
    latitude,
    longitude,
    operatingHours,
    commissionPct,
    status,
    onesignalPlayerId,
    createdAt,
    updatedAt,
    city,
    area,
    media,
  ]);

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerProfileModelImplCopyWith<_$SellerProfileModelImpl> get copyWith =>
      __$$SellerProfileModelImplCopyWithImpl<_$SellerProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerProfileModelImplToJson(this);
  }
}

abstract class _SellerProfileModel implements SellerProfileModel {
  const factory _SellerProfileModel({
    required final String id,
    required final String businessName,
    required final String category,
    required final String cityId,
    required final String areaId,
    final String? address,
    required final String phone,
    final String? email,
    final String? upiId,
    final double? latitude,
    final double? longitude,
    final String? operatingHours,
    required final double commissionPct,
    required final String status,
    final String? onesignalPlayerId,
    required final String createdAt,
    required final String updatedAt,
    required final SellerCityModel city,
    required final SellerAreaModel area,
    final SellerMediaModel? media,
  }) = _$SellerProfileModelImpl;

  factory _SellerProfileModel.fromJson(Map<String, dynamic> json) =
      _$SellerProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get businessName;
  @override
  String get category;
  @override
  String get cityId;
  @override
  String get areaId;
  @override
  String? get address;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String? get upiId;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get operatingHours;
  @override
  double get commissionPct;
  @override
  String get status;
  @override
  String? get onesignalPlayerId;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  SellerCityModel get city;
  @override
  SellerAreaModel get area;
  @override
  SellerMediaModel? get media;

  /// Create a copy of SellerProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerProfileModelImplCopyWith<_$SellerProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SellerCityModel _$SellerCityModelFromJson(Map<String, dynamic> json) {
  return _SellerCityModel.fromJson(json);
}

/// @nodoc
mixin _$SellerCityModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SellerCityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerCityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerCityModelCopyWith<SellerCityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerCityModelCopyWith<$Res> {
  factory $SellerCityModelCopyWith(
    SellerCityModel value,
    $Res Function(SellerCityModel) then,
  ) = _$SellerCityModelCopyWithImpl<$Res, SellerCityModel>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$SellerCityModelCopyWithImpl<$Res, $Val extends SellerCityModel>
    implements $SellerCityModelCopyWith<$Res> {
  _$SellerCityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerCityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellerCityModelImplCopyWith<$Res>
    implements $SellerCityModelCopyWith<$Res> {
  factory _$$SellerCityModelImplCopyWith(
    _$SellerCityModelImpl value,
    $Res Function(_$SellerCityModelImpl) then,
  ) = __$$SellerCityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$SellerCityModelImplCopyWithImpl<$Res>
    extends _$SellerCityModelCopyWithImpl<$Res, _$SellerCityModelImpl>
    implements _$$SellerCityModelImplCopyWith<$Res> {
  __$$SellerCityModelImplCopyWithImpl(
    _$SellerCityModelImpl _value,
    $Res Function(_$SellerCityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerCityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$SellerCityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerCityModelImpl implements _SellerCityModel {
  const _$SellerCityModelImpl({required this.id, required this.name});

  factory _$SellerCityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerCityModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'SellerCityModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerCityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SellerCityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerCityModelImplCopyWith<_$SellerCityModelImpl> get copyWith =>
      __$$SellerCityModelImplCopyWithImpl<_$SellerCityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerCityModelImplToJson(this);
  }
}

abstract class _SellerCityModel implements SellerCityModel {
  const factory _SellerCityModel({
    required final String id,
    required final String name,
  }) = _$SellerCityModelImpl;

  factory _SellerCityModel.fromJson(Map<String, dynamic> json) =
      _$SellerCityModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of SellerCityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerCityModelImplCopyWith<_$SellerCityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SellerAreaModel _$SellerAreaModelFromJson(Map<String, dynamic> json) {
  return _SellerAreaModel.fromJson(json);
}

/// @nodoc
mixin _$SellerAreaModel {
  String get id => throw _privateConstructorUsedError;
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
    SellerAreaModel value,
    $Res Function(SellerAreaModel) then,
  ) = _$SellerAreaModelCopyWithImpl<$Res, SellerAreaModel>;
  @useResult
  $Res call({String id, String name});
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
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellerAreaModelImplCopyWith<$Res>
    implements $SellerAreaModelCopyWith<$Res> {
  factory _$$SellerAreaModelImplCopyWith(
    _$SellerAreaModelImpl value,
    $Res Function(_$SellerAreaModelImpl) then,
  ) = __$$SellerAreaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$SellerAreaModelImplCopyWithImpl<$Res>
    extends _$SellerAreaModelCopyWithImpl<$Res, _$SellerAreaModelImpl>
    implements _$$SellerAreaModelImplCopyWith<$Res> {
  __$$SellerAreaModelImplCopyWithImpl(
    _$SellerAreaModelImpl _value,
    $Res Function(_$SellerAreaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$SellerAreaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerAreaModelImpl implements _SellerAreaModel {
  const _$SellerAreaModelImpl({required this.id, required this.name});

  factory _$SellerAreaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerAreaModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'SellerAreaModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerAreaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerAreaModelImplCopyWith<_$SellerAreaModelImpl> get copyWith =>
      __$$SellerAreaModelImplCopyWithImpl<_$SellerAreaModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerAreaModelImplToJson(this);
  }
}

abstract class _SellerAreaModel implements SellerAreaModel {
  const factory _SellerAreaModel({
    required final String id,
    required final String name,
  }) = _$SellerAreaModelImpl;

  factory _SellerAreaModel.fromJson(Map<String, dynamic> json) =
      _$SellerAreaModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of SellerAreaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerAreaModelImplCopyWith<_$SellerAreaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SellerMediaModel _$SellerMediaModelFromJson(Map<String, dynamic> json) {
  return _SellerMediaModel.fromJson(json);
}

/// @nodoc
mixin _$SellerMediaModel {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get photoUrl1 => throw _privateConstructorUsedError;
  String? get photoUrl2 => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError;

  /// Serializes this SellerMediaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerMediaModelCopyWith<SellerMediaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerMediaModelCopyWith<$Res> {
  factory $SellerMediaModelCopyWith(
    SellerMediaModel value,
    $Res Function(SellerMediaModel) then,
  ) = _$SellerMediaModelCopyWithImpl<$Res, SellerMediaModel>;
  @useResult
  $Res call({
    String id,
    String sellerId,
    String? logoUrl,
    String? photoUrl1,
    String? photoUrl2,
    String? videoUrl,
  });
}

/// @nodoc
class _$SellerMediaModelCopyWithImpl<$Res, $Val extends SellerMediaModel>
    implements $SellerMediaModelCopyWith<$Res> {
  _$SellerMediaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? logoUrl = freezed,
    Object? photoUrl1 = freezed,
    Object? photoUrl2 = freezed,
    Object? videoUrl = freezed,
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
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl1: freezed == photoUrl1
                ? _value.photoUrl1
                : photoUrl1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl2: freezed == photoUrl2
                ? _value.photoUrl2
                : photoUrl2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellerMediaModelImplCopyWith<$Res>
    implements $SellerMediaModelCopyWith<$Res> {
  factory _$$SellerMediaModelImplCopyWith(
    _$SellerMediaModelImpl value,
    $Res Function(_$SellerMediaModelImpl) then,
  ) = __$$SellerMediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sellerId,
    String? logoUrl,
    String? photoUrl1,
    String? photoUrl2,
    String? videoUrl,
  });
}

/// @nodoc
class __$$SellerMediaModelImplCopyWithImpl<$Res>
    extends _$SellerMediaModelCopyWithImpl<$Res, _$SellerMediaModelImpl>
    implements _$$SellerMediaModelImplCopyWith<$Res> {
  __$$SellerMediaModelImplCopyWithImpl(
    _$SellerMediaModelImpl _value,
    $Res Function(_$SellerMediaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? logoUrl = freezed,
    Object? photoUrl1 = freezed,
    Object? photoUrl2 = freezed,
    Object? videoUrl = freezed,
  }) {
    return _then(
      _$SellerMediaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sellerId: null == sellerId
            ? _value.sellerId
            : sellerId // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl1: freezed == photoUrl1
            ? _value.photoUrl1
            : photoUrl1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl2: freezed == photoUrl2
            ? _value.photoUrl2
            : photoUrl2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerMediaModelImpl implements _SellerMediaModel {
  const _$SellerMediaModelImpl({
    required this.id,
    required this.sellerId,
    this.logoUrl,
    this.photoUrl1,
    this.photoUrl2,
    this.videoUrl,
  });

  factory _$SellerMediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerMediaModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sellerId;
  @override
  final String? logoUrl;
  @override
  final String? photoUrl1;
  @override
  final String? photoUrl2;
  @override
  final String? videoUrl;

  @override
  String toString() {
    return 'SellerMediaModel(id: $id, sellerId: $sellerId, logoUrl: $logoUrl, photoUrl1: $photoUrl1, photoUrl2: $photoUrl2, videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerMediaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.photoUrl1, photoUrl1) ||
                other.photoUrl1 == photoUrl1) &&
            (identical(other.photoUrl2, photoUrl2) ||
                other.photoUrl2 == photoUrl2) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sellerId,
    logoUrl,
    photoUrl1,
    photoUrl2,
    videoUrl,
  );

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerMediaModelImplCopyWith<_$SellerMediaModelImpl> get copyWith =>
      __$$SellerMediaModelImplCopyWithImpl<_$SellerMediaModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerMediaModelImplToJson(this);
  }
}

abstract class _SellerMediaModel implements SellerMediaModel {
  const factory _SellerMediaModel({
    required final String id,
    required final String sellerId,
    final String? logoUrl,
    final String? photoUrl1,
    final String? photoUrl2,
    final String? videoUrl,
  }) = _$SellerMediaModelImpl;

  factory _SellerMediaModel.fromJson(Map<String, dynamic> json) =
      _$SellerMediaModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  String? get logoUrl;
  @override
  String? get photoUrl1;
  @override
  String? get photoUrl2;
  @override
  String? get videoUrl;

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerMediaModelImplCopyWith<_$SellerMediaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
