// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_seller_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerMediaModel _$SellerMediaModelFromJson(Map<String, dynamic> json) {
  return _SellerMediaModel.fromJson(json);
}

/// @nodoc
mixin _$SellerMediaModel {
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
          SellerMediaModel value, $Res Function(SellerMediaModel) then) =
      _$SellerMediaModelCopyWithImpl<$Res, SellerMediaModel>;
  @useResult
  $Res call(
      {String? logoUrl,
      String? photoUrl1,
      String? photoUrl2,
      String? videoUrl});
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
    Object? logoUrl = freezed,
    Object? photoUrl1 = freezed,
    Object? photoUrl2 = freezed,
    Object? videoUrl = freezed,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerMediaModelImplCopyWith<$Res>
    implements $SellerMediaModelCopyWith<$Res> {
  factory _$$SellerMediaModelImplCopyWith(_$SellerMediaModelImpl value,
          $Res Function(_$SellerMediaModelImpl) then) =
      __$$SellerMediaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? logoUrl,
      String? photoUrl1,
      String? photoUrl2,
      String? videoUrl});
}

/// @nodoc
class __$$SellerMediaModelImplCopyWithImpl<$Res>
    extends _$SellerMediaModelCopyWithImpl<$Res, _$SellerMediaModelImpl>
    implements _$$SellerMediaModelImplCopyWith<$Res> {
  __$$SellerMediaModelImplCopyWithImpl(_$SellerMediaModelImpl _value,
      $Res Function(_$SellerMediaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logoUrl = freezed,
    Object? photoUrl1 = freezed,
    Object? photoUrl2 = freezed,
    Object? videoUrl = freezed,
  }) {
    return _then(_$SellerMediaModelImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerMediaModelImpl implements _SellerMediaModel {
  const _$SellerMediaModelImpl(
      {this.logoUrl, this.photoUrl1, this.photoUrl2, this.videoUrl});

  factory _$SellerMediaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerMediaModelImplFromJson(json);

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
    return 'SellerMediaModel(logoUrl: $logoUrl, photoUrl1: $photoUrl1, photoUrl2: $photoUrl2, videoUrl: $videoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerMediaModelImpl &&
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
  int get hashCode =>
      Object.hash(runtimeType, logoUrl, photoUrl1, photoUrl2, videoUrl);

  /// Create a copy of SellerMediaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerMediaModelImplCopyWith<_$SellerMediaModelImpl> get copyWith =>
      __$$SellerMediaModelImplCopyWithImpl<_$SellerMediaModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerMediaModelImplToJson(
      this,
    );
  }
}

abstract class _SellerMediaModel implements SellerMediaModel {
  const factory _SellerMediaModel(
      {final String? logoUrl,
      final String? photoUrl1,
      final String? photoUrl2,
      final String? videoUrl}) = _$SellerMediaModelImpl;

  factory _SellerMediaModel.fromJson(Map<String, dynamic> json) =
      _$SellerMediaModelImpl.fromJson;

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

NearbySellerModel _$NearbySellerModelFromJson(Map<String, dynamic> json) {
  return _NearbySellerModel.fromJson(json);
}

/// @nodoc
mixin _$NearbySellerModel {
  String get id => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get area => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  SellerMediaModel? get media => throw _privateConstructorUsedError;

  /// Serializes this NearbySellerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbySellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbySellerModelCopyWith<NearbySellerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbySellerModelCopyWith<$Res> {
  factory $NearbySellerModelCopyWith(
          NearbySellerModel value, $Res Function(NearbySellerModel) then) =
      _$NearbySellerModelCopyWithImpl<$Res, NearbySellerModel>;
  @useResult
  $Res call(
      {String id,
      String businessName,
      String category,
      String area,
      double lat,
      double lng,
      double? distanceKm,
      String? logoUrl,
      SellerMediaModel? media});

  $SellerMediaModelCopyWith<$Res>? get media;
}

/// @nodoc
class _$NearbySellerModelCopyWithImpl<$Res, $Val extends NearbySellerModel>
    implements $NearbySellerModelCopyWith<$Res> {
  _$NearbySellerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbySellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? area = null,
    Object? lat = null,
    Object? lng = null,
    Object? distanceKm = freezed,
    Object? logoUrl = freezed,
    Object? media = freezed,
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
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as SellerMediaModel?,
    ) as $Val);
  }

  /// Create a copy of NearbySellerModel
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
abstract class _$$NearbySellerModelImplCopyWith<$Res>
    implements $NearbySellerModelCopyWith<$Res> {
  factory _$$NearbySellerModelImplCopyWith(_$NearbySellerModelImpl value,
          $Res Function(_$NearbySellerModelImpl) then) =
      __$$NearbySellerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String businessName,
      String category,
      String area,
      double lat,
      double lng,
      double? distanceKm,
      String? logoUrl,
      SellerMediaModel? media});

  @override
  $SellerMediaModelCopyWith<$Res>? get media;
}

/// @nodoc
class __$$NearbySellerModelImplCopyWithImpl<$Res>
    extends _$NearbySellerModelCopyWithImpl<$Res, _$NearbySellerModelImpl>
    implements _$$NearbySellerModelImplCopyWith<$Res> {
  __$$NearbySellerModelImplCopyWithImpl(_$NearbySellerModelImpl _value,
      $Res Function(_$NearbySellerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NearbySellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessName = null,
    Object? category = null,
    Object? area = null,
    Object? lat = null,
    Object? lng = null,
    Object? distanceKm = freezed,
    Object? logoUrl = freezed,
    Object? media = freezed,
  }) {
    return _then(_$NearbySellerModelImpl(
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
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as SellerMediaModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbySellerModelImpl implements _NearbySellerModel {
  const _$NearbySellerModelImpl(
      {required this.id,
      required this.businessName,
      required this.category,
      required this.area,
      required this.lat,
      required this.lng,
      this.distanceKm,
      this.logoUrl,
      this.media});

  factory _$NearbySellerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbySellerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String businessName;
  @override
  final String category;
  @override
  final String area;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final double? distanceKm;
  @override
  final String? logoUrl;
  @override
  final SellerMediaModel? media;

  @override
  String toString() {
    return 'NearbySellerModel(id: $id, businessName: $businessName, category: $category, area: $area, lat: $lat, lng: $lng, distanceKm: $distanceKm, logoUrl: $logoUrl, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbySellerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.media, media) || other.media == media));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, businessName, category, area,
      lat, lng, distanceKm, logoUrl, media);

  /// Create a copy of NearbySellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbySellerModelImplCopyWith<_$NearbySellerModelImpl> get copyWith =>
      __$$NearbySellerModelImplCopyWithImpl<_$NearbySellerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbySellerModelImplToJson(
      this,
    );
  }
}

abstract class _NearbySellerModel implements NearbySellerModel {
  const factory _NearbySellerModel(
      {required final String id,
      required final String businessName,
      required final String category,
      required final String area,
      required final double lat,
      required final double lng,
      final double? distanceKm,
      final String? logoUrl,
      final SellerMediaModel? media}) = _$NearbySellerModelImpl;

  factory _NearbySellerModel.fromJson(Map<String, dynamic> json) =
      _$NearbySellerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get businessName;
  @override
  String get category;
  @override
  String get area;
  @override
  double get lat;
  @override
  double get lng;
  @override
  double? get distanceKm;
  @override
  String? get logoUrl;
  @override
  SellerMediaModel? get media;

  /// Create a copy of NearbySellerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbySellerModelImplCopyWith<_$NearbySellerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
