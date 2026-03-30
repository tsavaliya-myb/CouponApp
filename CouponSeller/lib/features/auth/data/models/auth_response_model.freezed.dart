// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SendOtpResponseModel _$SendOtpResponseModelFromJson(Map<String, dynamic> json) {
  return _SendOtpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SendOtpResponseModel {
  bool get success => throw _privateConstructorUsedError;
  SendOtpData get data => throw _privateConstructorUsedError;

  /// Serializes this SendOtpResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendOtpResponseModelCopyWith<SendOtpResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendOtpResponseModelCopyWith<$Res> {
  factory $SendOtpResponseModelCopyWith(
    SendOtpResponseModel value,
    $Res Function(SendOtpResponseModel) then,
  ) = _$SendOtpResponseModelCopyWithImpl<$Res, SendOtpResponseModel>;
  @useResult
  $Res call({bool success, SendOtpData data});

  $SendOtpDataCopyWith<$Res> get data;
}

/// @nodoc
class _$SendOtpResponseModelCopyWithImpl<
  $Res,
  $Val extends SendOtpResponseModel
>
    implements $SendOtpResponseModelCopyWith<$Res> {
  _$SendOtpResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendOtpResponseModel
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
                      as SendOtpData,
          )
          as $Val,
    );
  }

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SendOtpDataCopyWith<$Res> get data {
    return $SendOtpDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SendOtpResponseModelImplCopyWith<$Res>
    implements $SendOtpResponseModelCopyWith<$Res> {
  factory _$$SendOtpResponseModelImplCopyWith(
    _$SendOtpResponseModelImpl value,
    $Res Function(_$SendOtpResponseModelImpl) then,
  ) = __$$SendOtpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, SendOtpData data});

  @override
  $SendOtpDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$SendOtpResponseModelImplCopyWithImpl<$Res>
    extends _$SendOtpResponseModelCopyWithImpl<$Res, _$SendOtpResponseModelImpl>
    implements _$$SendOtpResponseModelImplCopyWith<$Res> {
  __$$SendOtpResponseModelImplCopyWithImpl(
    _$SendOtpResponseModelImpl _value,
    $Res Function(_$SendOtpResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$SendOtpResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as SendOtpData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendOtpResponseModelImpl implements _SendOtpResponseModel {
  const _$SendOtpResponseModelImpl({required this.success, required this.data});

  factory _$SendOtpResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendOtpResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final SendOtpData data;

  @override
  String toString() {
    return 'SendOtpResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOtpResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOtpResponseModelImplCopyWith<_$SendOtpResponseModelImpl>
  get copyWith =>
      __$$SendOtpResponseModelImplCopyWithImpl<_$SendOtpResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOtpResponseModelImplToJson(this);
  }
}

abstract class _SendOtpResponseModel implements SendOtpResponseModel {
  const factory _SendOtpResponseModel({
    required final bool success,
    required final SendOtpData data,
  }) = _$SendOtpResponseModelImpl;

  factory _SendOtpResponseModel.fromJson(Map<String, dynamic> json) =
      _$SendOtpResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  SendOtpData get data;

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpResponseModelImplCopyWith<_$SendOtpResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SendOtpData _$SendOtpDataFromJson(Map<String, dynamic> json) {
  return _SendOtpData.fromJson(json);
}

/// @nodoc
mixin _$SendOtpData {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this SendOtpData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendOtpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendOtpDataCopyWith<SendOtpData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendOtpDataCopyWith<$Res> {
  factory $SendOtpDataCopyWith(
    SendOtpData value,
    $Res Function(SendOtpData) then,
  ) = _$SendOtpDataCopyWithImpl<$Res, SendOtpData>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$SendOtpDataCopyWithImpl<$Res, $Val extends SendOtpData>
    implements $SendOtpDataCopyWith<$Res> {
  _$SendOtpDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendOtpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendOtpDataImplCopyWith<$Res>
    implements $SendOtpDataCopyWith<$Res> {
  factory _$$SendOtpDataImplCopyWith(
    _$SendOtpDataImpl value,
    $Res Function(_$SendOtpDataImpl) then,
  ) = __$$SendOtpDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SendOtpDataImplCopyWithImpl<$Res>
    extends _$SendOtpDataCopyWithImpl<$Res, _$SendOtpDataImpl>
    implements _$$SendOtpDataImplCopyWith<$Res> {
  __$$SendOtpDataImplCopyWithImpl(
    _$SendOtpDataImpl _value,
    $Res Function(_$SendOtpDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendOtpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SendOtpDataImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SendOtpDataImpl implements _SendOtpData {
  const _$SendOtpDataImpl({required this.message});

  factory _$SendOtpDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendOtpDataImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'SendOtpData(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOtpDataImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SendOtpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOtpDataImplCopyWith<_$SendOtpDataImpl> get copyWith =>
      __$$SendOtpDataImplCopyWithImpl<_$SendOtpDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOtpDataImplToJson(this);
  }
}

abstract class _SendOtpData implements SendOtpData {
  const factory _SendOtpData({required final String message}) =
      _$SendOtpDataImpl;

  factory _SendOtpData.fromJson(Map<String, dynamic> json) =
      _$SendOtpDataImpl.fromJson;

  @override
  String get message;

  /// Create a copy of SendOtpData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpDataImplCopyWith<_$SendOtpDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _VerifyOtpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpResponseModel {
  bool get success => throw _privateConstructorUsedError;
  VerifyOtpData get data => throw _privateConstructorUsedError;

  /// Serializes this VerifyOtpResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyOtpResponseModelCopyWith<VerifyOtpResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpResponseModelCopyWith<$Res> {
  factory $VerifyOtpResponseModelCopyWith(
    VerifyOtpResponseModel value,
    $Res Function(VerifyOtpResponseModel) then,
  ) = _$VerifyOtpResponseModelCopyWithImpl<$Res, VerifyOtpResponseModel>;
  @useResult
  $Res call({bool success, VerifyOtpData data});

  $VerifyOtpDataCopyWith<$Res> get data;
}

/// @nodoc
class _$VerifyOtpResponseModelCopyWithImpl<
  $Res,
  $Val extends VerifyOtpResponseModel
>
    implements $VerifyOtpResponseModelCopyWith<$Res> {
  _$VerifyOtpResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyOtpResponseModel
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
                      as VerifyOtpData,
          )
          as $Val,
    );
  }

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerifyOtpDataCopyWith<$Res> get data {
    return $VerifyOtpDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyOtpResponseModelImplCopyWith<$Res>
    implements $VerifyOtpResponseModelCopyWith<$Res> {
  factory _$$VerifyOtpResponseModelImplCopyWith(
    _$VerifyOtpResponseModelImpl value,
    $Res Function(_$VerifyOtpResponseModelImpl) then,
  ) = __$$VerifyOtpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, VerifyOtpData data});

  @override
  $VerifyOtpDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$VerifyOtpResponseModelImplCopyWithImpl<$Res>
    extends
        _$VerifyOtpResponseModelCopyWithImpl<$Res, _$VerifyOtpResponseModelImpl>
    implements _$$VerifyOtpResponseModelImplCopyWith<$Res> {
  __$$VerifyOtpResponseModelImplCopyWithImpl(
    _$VerifyOtpResponseModelImpl _value,
    $Res Function(_$VerifyOtpResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$VerifyOtpResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as VerifyOtpData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpResponseModelImpl implements _VerifyOtpResponseModel {
  const _$VerifyOtpResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$VerifyOtpResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final VerifyOtpData data;

  @override
  String toString() {
    return 'VerifyOtpResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpResponseModelImplCopyWith<_$VerifyOtpResponseModelImpl>
  get copyWith =>
      __$$VerifyOtpResponseModelImplCopyWithImpl<_$VerifyOtpResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpResponseModelImplToJson(this);
  }
}

abstract class _VerifyOtpResponseModel implements VerifyOtpResponseModel {
  const factory _VerifyOtpResponseModel({
    required final bool success,
    required final VerifyOtpData data,
  }) = _$VerifyOtpResponseModelImpl;

  factory _VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  VerifyOtpData get data;

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpResponseModelImplCopyWith<_$VerifyOtpResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

VerifyOtpData _$VerifyOtpDataFromJson(Map<String, dynamic> json) {
  return _VerifyOtpData.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpData {
  bool get isRegistered => throw _privateConstructorUsedError;
  String? get registrationToken => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this VerifyOtpData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyOtpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyOtpDataCopyWith<VerifyOtpData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpDataCopyWith<$Res> {
  factory $VerifyOtpDataCopyWith(
    VerifyOtpData value,
    $Res Function(VerifyOtpData) then,
  ) = _$VerifyOtpDataCopyWithImpl<$Res, VerifyOtpData>;
  @useResult
  $Res call({
    bool isRegistered,
    String? registrationToken,
    String? status,
    String? accessToken,
    String? refreshToken,
  });
}

/// @nodoc
class _$VerifyOtpDataCopyWithImpl<$Res, $Val extends VerifyOtpData>
    implements $VerifyOtpDataCopyWith<$Res> {
  _$VerifyOtpDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyOtpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRegistered = null,
    Object? registrationToken = freezed,
    Object? status = freezed,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            isRegistered: null == isRegistered
                ? _value.isRegistered
                : isRegistered // ignore: cast_nullable_to_non_nullable
                      as bool,
            registrationToken: freezed == registrationToken
                ? _value.registrationToken
                : registrationToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            accessToken: freezed == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerifyOtpDataImplCopyWith<$Res>
    implements $VerifyOtpDataCopyWith<$Res> {
  factory _$$VerifyOtpDataImplCopyWith(
    _$VerifyOtpDataImpl value,
    $Res Function(_$VerifyOtpDataImpl) then,
  ) = __$$VerifyOtpDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isRegistered,
    String? registrationToken,
    String? status,
    String? accessToken,
    String? refreshToken,
  });
}

/// @nodoc
class __$$VerifyOtpDataImplCopyWithImpl<$Res>
    extends _$VerifyOtpDataCopyWithImpl<$Res, _$VerifyOtpDataImpl>
    implements _$$VerifyOtpDataImplCopyWith<$Res> {
  __$$VerifyOtpDataImplCopyWithImpl(
    _$VerifyOtpDataImpl _value,
    $Res Function(_$VerifyOtpDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerifyOtpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRegistered = null,
    Object? registrationToken = freezed,
    Object? status = freezed,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _$VerifyOtpDataImpl(
        isRegistered: null == isRegistered
            ? _value.isRegistered
            : isRegistered // ignore: cast_nullable_to_non_nullable
                  as bool,
        registrationToken: freezed == registrationToken
            ? _value.registrationToken
            : registrationToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        accessToken: freezed == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpDataImpl implements _VerifyOtpData {
  const _$VerifyOtpDataImpl({
    required this.isRegistered,
    this.registrationToken,
    this.status,
    this.accessToken,
    this.refreshToken,
  });

  factory _$VerifyOtpDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpDataImplFromJson(json);

  @override
  final bool isRegistered;
  @override
  final String? registrationToken;
  @override
  final String? status;
  @override
  final String? accessToken;
  @override
  final String? refreshToken;

  @override
  String toString() {
    return 'VerifyOtpData(isRegistered: $isRegistered, registrationToken: $registrationToken, status: $status, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpDataImpl &&
            (identical(other.isRegistered, isRegistered) ||
                other.isRegistered == isRegistered) &&
            (identical(other.registrationToken, registrationToken) ||
                other.registrationToken == registrationToken) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isRegistered,
    registrationToken,
    status,
    accessToken,
    refreshToken,
  );

  /// Create a copy of VerifyOtpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpDataImplCopyWith<_$VerifyOtpDataImpl> get copyWith =>
      __$$VerifyOtpDataImplCopyWithImpl<_$VerifyOtpDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpDataImplToJson(this);
  }
}

abstract class _VerifyOtpData implements VerifyOtpData {
  const factory _VerifyOtpData({
    required final bool isRegistered,
    final String? registrationToken,
    final String? status,
    final String? accessToken,
    final String? refreshToken,
  }) = _$VerifyOtpDataImpl;

  factory _VerifyOtpData.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpDataImpl.fromJson;

  @override
  bool get isRegistered;
  @override
  String? get registrationToken;
  @override
  String? get status;
  @override
  String? get accessToken;
  @override
  String? get refreshToken;

  /// Create a copy of VerifyOtpData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpDataImplCopyWith<_$VerifyOtpDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterSellerResponseModel _$RegisterSellerResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _RegisterSellerResponseModel.fromJson(json);
}

/// @nodoc
mixin _$RegisterSellerResponseModel {
  bool get success => throw _privateConstructorUsedError;
  RegisterSellerData get data => throw _privateConstructorUsedError;

  /// Serializes this RegisterSellerResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterSellerResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterSellerResponseModelCopyWith<RegisterSellerResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterSellerResponseModelCopyWith<$Res> {
  factory $RegisterSellerResponseModelCopyWith(
    RegisterSellerResponseModel value,
    $Res Function(RegisterSellerResponseModel) then,
  ) =
      _$RegisterSellerResponseModelCopyWithImpl<
        $Res,
        RegisterSellerResponseModel
      >;
  @useResult
  $Res call({bool success, RegisterSellerData data});

  $RegisterSellerDataCopyWith<$Res> get data;
}

/// @nodoc
class _$RegisterSellerResponseModelCopyWithImpl<
  $Res,
  $Val extends RegisterSellerResponseModel
>
    implements $RegisterSellerResponseModelCopyWith<$Res> {
  _$RegisterSellerResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterSellerResponseModel
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
                      as RegisterSellerData,
          )
          as $Val,
    );
  }

  /// Create a copy of RegisterSellerResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterSellerDataCopyWith<$Res> get data {
    return $RegisterSellerDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegisterSellerResponseModelImplCopyWith<$Res>
    implements $RegisterSellerResponseModelCopyWith<$Res> {
  factory _$$RegisterSellerResponseModelImplCopyWith(
    _$RegisterSellerResponseModelImpl value,
    $Res Function(_$RegisterSellerResponseModelImpl) then,
  ) = __$$RegisterSellerResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, RegisterSellerData data});

  @override
  $RegisterSellerDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$RegisterSellerResponseModelImplCopyWithImpl<$Res>
    extends
        _$RegisterSellerResponseModelCopyWithImpl<
          $Res,
          _$RegisterSellerResponseModelImpl
        >
    implements _$$RegisterSellerResponseModelImplCopyWith<$Res> {
  __$$RegisterSellerResponseModelImplCopyWithImpl(
    _$RegisterSellerResponseModelImpl _value,
    $Res Function(_$RegisterSellerResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterSellerResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$RegisterSellerResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as RegisterSellerData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterSellerResponseModelImpl
    implements _RegisterSellerResponseModel {
  const _$RegisterSellerResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$RegisterSellerResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$RegisterSellerResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final RegisterSellerData data;

  @override
  String toString() {
    return 'RegisterSellerResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterSellerResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of RegisterSellerResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterSellerResponseModelImplCopyWith<_$RegisterSellerResponseModelImpl>
  get copyWith =>
      __$$RegisterSellerResponseModelImplCopyWithImpl<
        _$RegisterSellerResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterSellerResponseModelImplToJson(this);
  }
}

abstract class _RegisterSellerResponseModel
    implements RegisterSellerResponseModel {
  const factory _RegisterSellerResponseModel({
    required final bool success,
    required final RegisterSellerData data,
  }) = _$RegisterSellerResponseModelImpl;

  factory _RegisterSellerResponseModel.fromJson(Map<String, dynamic> json) =
      _$RegisterSellerResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  RegisterSellerData get data;

  /// Create a copy of RegisterSellerResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterSellerResponseModelImplCopyWith<_$RegisterSellerResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RegisterSellerData _$RegisterSellerDataFromJson(Map<String, dynamic> json) {
  return _RegisterSellerData.fromJson(json);
}

/// @nodoc
mixin _$RegisterSellerData {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  SellerModel get seller => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this RegisterSellerData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterSellerDataCopyWith<RegisterSellerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterSellerDataCopyWith<$Res> {
  factory $RegisterSellerDataCopyWith(
    RegisterSellerData value,
    $Res Function(RegisterSellerData) then,
  ) = _$RegisterSellerDataCopyWithImpl<$Res, RegisterSellerData>;
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    SellerModel seller,
    String message,
  });

  $SellerModelCopyWith<$Res> get seller;
}

/// @nodoc
class _$RegisterSellerDataCopyWithImpl<$Res, $Val extends RegisterSellerData>
    implements $RegisterSellerDataCopyWith<$Res> {
  _$RegisterSellerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? seller = null,
    Object? message = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            seller: null == seller
                ? _value.seller
                : seller // ignore: cast_nullable_to_non_nullable
                      as SellerModel,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerModelCopyWith<$Res> get seller {
    return $SellerModelCopyWith<$Res>(_value.seller, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegisterSellerDataImplCopyWith<$Res>
    implements $RegisterSellerDataCopyWith<$Res> {
  factory _$$RegisterSellerDataImplCopyWith(
    _$RegisterSellerDataImpl value,
    $Res Function(_$RegisterSellerDataImpl) then,
  ) = __$$RegisterSellerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    String refreshToken,
    SellerModel seller,
    String message,
  });

  @override
  $SellerModelCopyWith<$Res> get seller;
}

/// @nodoc
class __$$RegisterSellerDataImplCopyWithImpl<$Res>
    extends _$RegisterSellerDataCopyWithImpl<$Res, _$RegisterSellerDataImpl>
    implements _$$RegisterSellerDataImplCopyWith<$Res> {
  __$$RegisterSellerDataImplCopyWithImpl(
    _$RegisterSellerDataImpl _value,
    $Res Function(_$RegisterSellerDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? seller = null,
    Object? message = null,
  }) {
    return _then(
      _$RegisterSellerDataImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        seller: null == seller
            ? _value.seller
            : seller // ignore: cast_nullable_to_non_nullable
                  as SellerModel,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterSellerDataImpl implements _RegisterSellerData {
  const _$RegisterSellerDataImpl({
    required this.accessToken,
    required this.refreshToken,
    required this.seller,
    required this.message,
  });

  factory _$RegisterSellerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterSellerDataImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final SellerModel seller;
  @override
  final String message;

  @override
  String toString() {
    return 'RegisterSellerData(accessToken: $accessToken, refreshToken: $refreshToken, seller: $seller, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterSellerDataImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, seller, message);

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterSellerDataImplCopyWith<_$RegisterSellerDataImpl> get copyWith =>
      __$$RegisterSellerDataImplCopyWithImpl<_$RegisterSellerDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterSellerDataImplToJson(this);
  }
}

abstract class _RegisterSellerData implements RegisterSellerData {
  const factory _RegisterSellerData({
    required final String accessToken,
    required final String refreshToken,
    required final SellerModel seller,
    required final String message,
  }) = _$RegisterSellerDataImpl;

  factory _RegisterSellerData.fromJson(Map<String, dynamic> json) =
      _$RegisterSellerDataImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  SellerModel get seller;
  @override
  String get message;

  /// Create a copy of RegisterSellerData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterSellerDataImplCopyWith<_$RegisterSellerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) {
  return _SellerModel.fromJson(json);
}

/// @nodoc
mixin _$SellerModel {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get cityId => throw _privateConstructorUsedError;
  String get areaId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get upiId => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;

  /// Serializes this SellerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerModelCopyWith<SellerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerModelCopyWith<$Res> {
  factory $SellerModelCopyWith(
    SellerModel value,
    $Res Function(SellerModel) then,
  ) = _$SellerModelCopyWithImpl<$Res, SellerModel>;
  @useResult
  $Res call({
    String id,
    String phone,
    String businessName,
    String category,
    String cityId,
    String areaId,
    String status,
    String address,
    String email,
    String upiId,
    double lat,
    double lng,
  });
}

/// @nodoc
class _$SellerModelCopyWithImpl<$Res, $Val extends SellerModel>
    implements $SellerModelCopyWith<$Res> {
  _$SellerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? businessName = null,
    Object? category = null,
    Object? cityId = null,
    Object? areaId = null,
    Object? status = null,
    Object? address = null,
    Object? email = null,
    Object? upiId = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            upiId: null == upiId
                ? _value.upiId
                : upiId // ignore: cast_nullable_to_non_nullable
                      as String,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SellerModelImplCopyWith<$Res>
    implements $SellerModelCopyWith<$Res> {
  factory _$$SellerModelImplCopyWith(
    _$SellerModelImpl value,
    $Res Function(_$SellerModelImpl) then,
  ) = __$$SellerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String phone,
    String businessName,
    String category,
    String cityId,
    String areaId,
    String status,
    String address,
    String email,
    String upiId,
    double lat,
    double lng,
  });
}

/// @nodoc
class __$$SellerModelImplCopyWithImpl<$Res>
    extends _$SellerModelCopyWithImpl<$Res, _$SellerModelImpl>
    implements _$$SellerModelImplCopyWith<$Res> {
  __$$SellerModelImplCopyWithImpl(
    _$SellerModelImpl _value,
    $Res Function(_$SellerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SellerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? businessName = null,
    Object? category = null,
    Object? cityId = null,
    Object? areaId = null,
    Object? status = null,
    Object? address = null,
    Object? email = null,
    Object? upiId = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(
      _$SellerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        upiId: null == upiId
            ? _value.upiId
            : upiId // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerModelImpl implements _SellerModel {
  const _$SellerModelImpl({
    required this.id,
    required this.phone,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    required this.status,
    required this.address,
    required this.email,
    required this.upiId,
    required this.lat,
    required this.lng,
  });

  factory _$SellerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String phone;
  @override
  final String businessName;
  @override
  final String category;
  @override
  final String cityId;
  @override
  final String areaId;
  @override
  final String status;
  @override
  final String address;
  @override
  final String email;
  @override
  final String upiId;
  @override
  final double lat;
  @override
  final double lng;

  @override
  String toString() {
    return 'SellerModel(id: $id, phone: $phone, businessName: $businessName, category: $category, cityId: $cityId, areaId: $areaId, status: $status, address: $address, email: $email, upiId: $upiId, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    phone,
    businessName,
    category,
    cityId,
    areaId,
    status,
    address,
    email,
    upiId,
    lat,
    lng,
  );

  /// Create a copy of SellerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerModelImplCopyWith<_$SellerModelImpl> get copyWith =>
      __$$SellerModelImplCopyWithImpl<_$SellerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerModelImplToJson(this);
  }
}

abstract class _SellerModel implements SellerModel {
  const factory _SellerModel({
    required final String id,
    required final String phone,
    required final String businessName,
    required final String category,
    required final String cityId,
    required final String areaId,
    required final String status,
    required final String address,
    required final String email,
    required final String upiId,
    required final double lat,
    required final double lng,
  }) = _$SellerModelImpl;

  factory _SellerModel.fromJson(Map<String, dynamic> json) =
      _$SellerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get phone;
  @override
  String get businessName;
  @override
  String get category;
  @override
  String get cityId;
  @override
  String get areaId;
  @override
  String get status;
  @override
  String get address;
  @override
  String get email;
  @override
  String get upiId;
  @override
  double get lat;
  @override
  double get lng;

  /// Create a copy of SellerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerModelImplCopyWith<_$SellerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
