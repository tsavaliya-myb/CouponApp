// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CityResponseModel _$CityResponseModelFromJson(Map<String, dynamic> json) {
  return _CityResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CityResponseModel {
  bool get success => throw _privateConstructorUsedError;
  List<CityModel> get data => throw _privateConstructorUsedError;

  /// Serializes this CityResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityResponseModelCopyWith<CityResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityResponseModelCopyWith<$Res> {
  factory $CityResponseModelCopyWith(
    CityResponseModel value,
    $Res Function(CityResponseModel) then,
  ) = _$CityResponseModelCopyWithImpl<$Res, CityResponseModel>;
  @useResult
  $Res call({bool success, List<CityModel> data});
}

/// @nodoc
class _$CityResponseModelCopyWithImpl<$Res, $Val extends CityResponseModel>
    implements $CityResponseModelCopyWith<$Res> {
  _$CityResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityResponseModel
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
                      as List<CityModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityResponseModelImplCopyWith<$Res>
    implements $CityResponseModelCopyWith<$Res> {
  factory _$$CityResponseModelImplCopyWith(
    _$CityResponseModelImpl value,
    $Res Function(_$CityResponseModelImpl) then,
  ) = __$$CityResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<CityModel> data});
}

/// @nodoc
class __$$CityResponseModelImplCopyWithImpl<$Res>
    extends _$CityResponseModelCopyWithImpl<$Res, _$CityResponseModelImpl>
    implements _$$CityResponseModelImplCopyWith<$Res> {
  __$$CityResponseModelImplCopyWithImpl(
    _$CityResponseModelImpl _value,
    $Res Function(_$CityResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$CityResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<CityModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityResponseModelImpl implements _CityResponseModel {
  const _$CityResponseModelImpl({
    required this.success,
    required final List<CityModel> data,
  }) : _data = data;

  factory _$CityResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityResponseModelImplFromJson(json);

  @override
  final bool success;
  final List<CityModel> _data;
  @override
  List<CityModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'CityResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of CityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityResponseModelImplCopyWith<_$CityResponseModelImpl> get copyWith =>
      __$$CityResponseModelImplCopyWithImpl<_$CityResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CityResponseModelImplToJson(this);
  }
}

abstract class _CityResponseModel implements CityResponseModel {
  const factory _CityResponseModel({
    required final bool success,
    required final List<CityModel> data,
  }) = _$CityResponseModelImpl;

  factory _CityResponseModel.fromJson(Map<String, dynamic> json) =
      _$CityResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  List<CityModel> get data;

  /// Create a copy of CityResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityResponseModelImplCopyWith<_$CityResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AreaResponseModel _$AreaResponseModelFromJson(Map<String, dynamic> json) {
  return _AreaResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AreaResponseModel {
  bool get success => throw _privateConstructorUsedError;
  List<AreaModel> get data => throw _privateConstructorUsedError;

  /// Serializes this AreaResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AreaResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AreaResponseModelCopyWith<AreaResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaResponseModelCopyWith<$Res> {
  factory $AreaResponseModelCopyWith(
    AreaResponseModel value,
    $Res Function(AreaResponseModel) then,
  ) = _$AreaResponseModelCopyWithImpl<$Res, AreaResponseModel>;
  @useResult
  $Res call({bool success, List<AreaModel> data});
}

/// @nodoc
class _$AreaResponseModelCopyWithImpl<$Res, $Val extends AreaResponseModel>
    implements $AreaResponseModelCopyWith<$Res> {
  _$AreaResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AreaResponseModel
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
                      as List<AreaModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AreaResponseModelImplCopyWith<$Res>
    implements $AreaResponseModelCopyWith<$Res> {
  factory _$$AreaResponseModelImplCopyWith(
    _$AreaResponseModelImpl value,
    $Res Function(_$AreaResponseModelImpl) then,
  ) = __$$AreaResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<AreaModel> data});
}

/// @nodoc
class __$$AreaResponseModelImplCopyWithImpl<$Res>
    extends _$AreaResponseModelCopyWithImpl<$Res, _$AreaResponseModelImpl>
    implements _$$AreaResponseModelImplCopyWith<$Res> {
  __$$AreaResponseModelImplCopyWithImpl(
    _$AreaResponseModelImpl _value,
    $Res Function(_$AreaResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AreaResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$AreaResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<AreaModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaResponseModelImpl implements _AreaResponseModel {
  const _$AreaResponseModelImpl({
    required this.success,
    required final List<AreaModel> data,
  }) : _data = data;

  factory _$AreaResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AreaResponseModelImplFromJson(json);

  @override
  final bool success;
  final List<AreaModel> _data;
  @override
  List<AreaModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'AreaResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of AreaResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaResponseModelImplCopyWith<_$AreaResponseModelImpl> get copyWith =>
      __$$AreaResponseModelImplCopyWithImpl<_$AreaResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaResponseModelImplToJson(this);
  }
}

abstract class _AreaResponseModel implements AreaResponseModel {
  const factory _AreaResponseModel({
    required final bool success,
    required final List<AreaModel> data,
  }) = _$AreaResponseModelImpl;

  factory _AreaResponseModel.fromJson(Map<String, dynamic> json) =
      _$AreaResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  List<AreaModel> get data;

  /// Create a copy of AreaResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AreaResponseModelImplCopyWith<_$AreaResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CityModel _$CityModelFromJson(Map<String, dynamic> json) {
  return _CityModel.fromJson(json);
}

/// @nodoc
mixin _$CityModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this CityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CityModelCopyWith<CityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CityModelCopyWith<$Res> {
  factory $CityModelCopyWith(CityModel value, $Res Function(CityModel) then) =
      _$CityModelCopyWithImpl<$Res, CityModel>;
  @useResult
  $Res call({String id, String name, String status});
}

/// @nodoc
class _$CityModelCopyWithImpl<$Res, $Val extends CityModel>
    implements $CityModelCopyWith<$Res> {
  _$CityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? status = null}) {
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CityModelImplCopyWith<$Res>
    implements $CityModelCopyWith<$Res> {
  factory _$$CityModelImplCopyWith(
    _$CityModelImpl value,
    $Res Function(_$CityModelImpl) then,
  ) = __$$CityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String status});
}

/// @nodoc
class __$$CityModelImplCopyWithImpl<$Res>
    extends _$CityModelCopyWithImpl<$Res, _$CityModelImpl>
    implements _$$CityModelImplCopyWith<$Res> {
  __$$CityModelImplCopyWithImpl(
    _$CityModelImpl _value,
    $Res Function(_$CityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? status = null}) {
    return _then(
      _$CityModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CityModelImpl implements _CityModel {
  const _$CityModelImpl({
    required this.id,
    required this.name,
    required this.status,
  });

  factory _$CityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CityModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String status;

  @override
  String toString() {
    return 'CityModel(id: $id, name: $name, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, status);

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CityModelImplCopyWith<_$CityModelImpl> get copyWith =>
      __$$CityModelImplCopyWithImpl<_$CityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CityModelImplToJson(this);
  }
}

abstract class _CityModel implements CityModel {
  const factory _CityModel({
    required final String id,
    required final String name,
    required final String status,
  }) = _$CityModelImpl;

  factory _CityModel.fromJson(Map<String, dynamic> json) =
      _$CityModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get status;

  /// Create a copy of CityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CityModelImplCopyWith<_$CityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AreaModel _$AreaModelFromJson(Map<String, dynamic> json) {
  return _AreaModel.fromJson(json);
}

/// @nodoc
mixin _$AreaModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this AreaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AreaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AreaModelCopyWith<AreaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaModelCopyWith<$Res> {
  factory $AreaModelCopyWith(AreaModel value, $Res Function(AreaModel) then) =
      _$AreaModelCopyWithImpl<$Res, AreaModel>;
  @useResult
  $Res call({String id, String name, String cityId, bool isActive});
}

/// @nodoc
class _$AreaModelCopyWithImpl<$Res, $Val extends AreaModel>
    implements $AreaModelCopyWith<$Res> {
  _$AreaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AreaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cityId = null,
    Object? isActive = null,
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
            cityId: null == cityId
                ? _value.cityId
                : cityId // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AreaModelImplCopyWith<$Res>
    implements $AreaModelCopyWith<$Res> {
  factory _$$AreaModelImplCopyWith(
    _$AreaModelImpl value,
    $Res Function(_$AreaModelImpl) then,
  ) = __$$AreaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String cityId, bool isActive});
}

/// @nodoc
class __$$AreaModelImplCopyWithImpl<$Res>
    extends _$AreaModelCopyWithImpl<$Res, _$AreaModelImpl>
    implements _$$AreaModelImplCopyWith<$Res> {
  __$$AreaModelImplCopyWithImpl(
    _$AreaModelImpl _value,
    $Res Function(_$AreaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AreaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? cityId = null,
    Object? isActive = null,
  }) {
    return _then(
      _$AreaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        cityId: null == cityId
            ? _value.cityId
            : cityId // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AreaModelImpl implements _AreaModel {
  const _$AreaModelImpl({
    required this.id,
    required this.name,
    required this.cityId,
    required this.isActive,
  });

  factory _$AreaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AreaModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String cityId;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'AreaModel(id: $id, name: $name, cityId: $cityId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, cityId, isActive);

  /// Create a copy of AreaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaModelImplCopyWith<_$AreaModelImpl> get copyWith =>
      __$$AreaModelImplCopyWithImpl<_$AreaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AreaModelImplToJson(this);
  }
}

abstract class _AreaModel implements AreaModel {
  const factory _AreaModel({
    required final String id,
    required final String name,
    required final String cityId,
    required final bool isActive,
  }) = _$AreaModelImpl;

  factory _AreaModel.fromJson(Map<String, dynamic> json) =
      _$AreaModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get cityId;
  @override
  bool get isActive;

  /// Create a copy of AreaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AreaModelImplCopyWith<_$AreaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
