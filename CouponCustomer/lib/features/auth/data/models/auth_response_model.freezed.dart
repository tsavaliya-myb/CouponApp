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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SendOtpResponseModel _$SendOtpResponseModelFromJson(Map<String, dynamic> json) {
  return _SendOtpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$SendOtpResponseModel {
  bool get success => throw _privateConstructorUsedError;
  SendOtpDataModel get data => throw _privateConstructorUsedError;

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
  factory $SendOtpResponseModelCopyWith(SendOtpResponseModel value,
          $Res Function(SendOtpResponseModel) then) =
      _$SendOtpResponseModelCopyWithImpl<$Res, SendOtpResponseModel>;
  @useResult
  $Res call({bool success, SendOtpDataModel data});

  $SendOtpDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$SendOtpResponseModelCopyWithImpl<$Res,
        $Val extends SendOtpResponseModel>
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
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SendOtpDataModel,
    ) as $Val);
  }

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SendOtpDataModelCopyWith<$Res> get data {
    return $SendOtpDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SendOtpResponseModelImplCopyWith<$Res>
    implements $SendOtpResponseModelCopyWith<$Res> {
  factory _$$SendOtpResponseModelImplCopyWith(_$SendOtpResponseModelImpl value,
          $Res Function(_$SendOtpResponseModelImpl) then) =
      __$$SendOtpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, SendOtpDataModel data});

  @override
  $SendOtpDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$SendOtpResponseModelImplCopyWithImpl<$Res>
    extends _$SendOtpResponseModelCopyWithImpl<$Res, _$SendOtpResponseModelImpl>
    implements _$$SendOtpResponseModelImplCopyWith<$Res> {
  __$$SendOtpResponseModelImplCopyWithImpl(_$SendOtpResponseModelImpl _value,
      $Res Function(_$SendOtpResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$SendOtpResponseModelImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SendOtpDataModel,
    ));
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
  final SendOtpDataModel data;

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
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOtpResponseModelImplToJson(
      this,
    );
  }
}

abstract class _SendOtpResponseModel implements SendOtpResponseModel {
  const factory _SendOtpResponseModel(
      {required final bool success,
      required final SendOtpDataModel data}) = _$SendOtpResponseModelImpl;

  factory _SendOtpResponseModel.fromJson(Map<String, dynamic> json) =
      _$SendOtpResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  SendOtpDataModel get data;

  /// Create a copy of SendOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpResponseModelImplCopyWith<_$SendOtpResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SendOtpDataModel _$SendOtpDataModelFromJson(Map<String, dynamic> json) {
  return _SendOtpDataModel.fromJson(json);
}

/// @nodoc
mixin _$SendOtpDataModel {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this SendOtpDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SendOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendOtpDataModelCopyWith<SendOtpDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendOtpDataModelCopyWith<$Res> {
  factory $SendOtpDataModelCopyWith(
          SendOtpDataModel value, $Res Function(SendOtpDataModel) then) =
      _$SendOtpDataModelCopyWithImpl<$Res, SendOtpDataModel>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$SendOtpDataModelCopyWithImpl<$Res, $Val extends SendOtpDataModel>
    implements $SendOtpDataModelCopyWith<$Res> {
  _$SendOtpDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendOtpDataModelImplCopyWith<$Res>
    implements $SendOtpDataModelCopyWith<$Res> {
  factory _$$SendOtpDataModelImplCopyWith(_$SendOtpDataModelImpl value,
          $Res Function(_$SendOtpDataModelImpl) then) =
      __$$SendOtpDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SendOtpDataModelImplCopyWithImpl<$Res>
    extends _$SendOtpDataModelCopyWithImpl<$Res, _$SendOtpDataModelImpl>
    implements _$$SendOtpDataModelImplCopyWith<$Res> {
  __$$SendOtpDataModelImplCopyWithImpl(_$SendOtpDataModelImpl _value,
      $Res Function(_$SendOtpDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SendOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SendOtpDataModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendOtpDataModelImpl implements _SendOtpDataModel {
  const _$SendOtpDataModelImpl({required this.message});

  factory _$SendOtpDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendOtpDataModelImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'SendOtpDataModel(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendOtpDataModelImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SendOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendOtpDataModelImplCopyWith<_$SendOtpDataModelImpl> get copyWith =>
      __$$SendOtpDataModelImplCopyWithImpl<_$SendOtpDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendOtpDataModelImplToJson(
      this,
    );
  }
}

abstract class _SendOtpDataModel implements SendOtpDataModel {
  const factory _SendOtpDataModel({required final String message}) =
      _$SendOtpDataModelImpl;

  factory _SendOtpDataModel.fromJson(Map<String, dynamic> json) =
      _$SendOtpDataModelImpl.fromJson;

  @override
  String get message;

  /// Create a copy of SendOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendOtpDataModelImplCopyWith<_$SendOtpDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyOtpResponseModel _$VerifyOtpResponseModelFromJson(
    Map<String, dynamic> json) {
  return _VerifyOtpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpResponseModel {
  bool get success => throw _privateConstructorUsedError;
  VerifyOtpDataModel get data => throw _privateConstructorUsedError;

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
  factory $VerifyOtpResponseModelCopyWith(VerifyOtpResponseModel value,
          $Res Function(VerifyOtpResponseModel) then) =
      _$VerifyOtpResponseModelCopyWithImpl<$Res, VerifyOtpResponseModel>;
  @useResult
  $Res call({bool success, VerifyOtpDataModel data});

  $VerifyOtpDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$VerifyOtpResponseModelCopyWithImpl<$Res,
        $Val extends VerifyOtpResponseModel>
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
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VerifyOtpDataModel,
    ) as $Val);
  }

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerifyOtpDataModelCopyWith<$Res> get data {
    return $VerifyOtpDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyOtpResponseModelImplCopyWith<$Res>
    implements $VerifyOtpResponseModelCopyWith<$Res> {
  factory _$$VerifyOtpResponseModelImplCopyWith(
          _$VerifyOtpResponseModelImpl value,
          $Res Function(_$VerifyOtpResponseModelImpl) then) =
      __$$VerifyOtpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, VerifyOtpDataModel data});

  @override
  $VerifyOtpDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$VerifyOtpResponseModelImplCopyWithImpl<$Res>
    extends _$VerifyOtpResponseModelCopyWithImpl<$Res,
        _$VerifyOtpResponseModelImpl>
    implements _$$VerifyOtpResponseModelImplCopyWith<$Res> {
  __$$VerifyOtpResponseModelImplCopyWithImpl(
      _$VerifyOtpResponseModelImpl _value,
      $Res Function(_$VerifyOtpResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
  }) {
    return _then(_$VerifyOtpResponseModelImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VerifyOtpDataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpResponseModelImpl implements _VerifyOtpResponseModel {
  const _$VerifyOtpResponseModelImpl(
      {required this.success, required this.data});

  factory _$VerifyOtpResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final VerifyOtpDataModel data;

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
      get copyWith => __$$VerifyOtpResponseModelImplCopyWithImpl<
          _$VerifyOtpResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpResponseModelImplToJson(
      this,
    );
  }
}

abstract class _VerifyOtpResponseModel implements VerifyOtpResponseModel {
  const factory _VerifyOtpResponseModel(
      {required final bool success,
      required final VerifyOtpDataModel data}) = _$VerifyOtpResponseModelImpl;

  factory _VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  VerifyOtpDataModel get data;

  /// Create a copy of VerifyOtpResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpResponseModelImplCopyWith<_$VerifyOtpResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerifyOtpDataModel _$VerifyOtpDataModelFromJson(Map<String, dynamic> json) {
  return _VerifyOtpDataModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpDataModel {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  AuthUserModel? get user => throw _privateConstructorUsedError;
  bool get isNewUser => throw _privateConstructorUsedError;
  String get subscriptionStatus => throw _privateConstructorUsedError;

  /// Serializes this VerifyOtpDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyOtpDataModelCopyWith<VerifyOtpDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpDataModelCopyWith<$Res> {
  factory $VerifyOtpDataModelCopyWith(
          VerifyOtpDataModel value, $Res Function(VerifyOtpDataModel) then) =
      _$VerifyOtpDataModelCopyWithImpl<$Res, VerifyOtpDataModel>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      AuthUserModel? user,
      bool isNewUser,
      String subscriptionStatus});

  $AuthUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$VerifyOtpDataModelCopyWithImpl<$Res, $Val extends VerifyOtpDataModel>
    implements $VerifyOtpDataModelCopyWith<$Res> {
  _$VerifyOtpDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = freezed,
    Object? isNewUser = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserModel?,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $AuthUserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyOtpDataModelImplCopyWith<$Res>
    implements $VerifyOtpDataModelCopyWith<$Res> {
  factory _$$VerifyOtpDataModelImplCopyWith(_$VerifyOtpDataModelImpl value,
          $Res Function(_$VerifyOtpDataModelImpl) then) =
      __$$VerifyOtpDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      AuthUserModel? user,
      bool isNewUser,
      String subscriptionStatus});

  @override
  $AuthUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$VerifyOtpDataModelImplCopyWithImpl<$Res>
    extends _$VerifyOtpDataModelCopyWithImpl<$Res, _$VerifyOtpDataModelImpl>
    implements _$$VerifyOtpDataModelImplCopyWith<$Res> {
  __$$VerifyOtpDataModelImplCopyWithImpl(_$VerifyOtpDataModelImpl _value,
      $Res Function(_$VerifyOtpDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = freezed,
    Object? isNewUser = null,
    Object? subscriptionStatus = null,
  }) {
    return _then(_$VerifyOtpDataModelImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUserModel?,
      isNewUser: null == isNewUser
          ? _value.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpDataModelImpl implements _VerifyOtpDataModel {
  const _$VerifyOtpDataModelImpl(
      {required this.accessToken,
      required this.refreshToken,
      this.user,
      this.isNewUser = false,
      this.subscriptionStatus = 'NONE'});

  factory _$VerifyOtpDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpDataModelImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final AuthUserModel? user;
  @override
  @JsonKey()
  final bool isNewUser;
  @override
  @JsonKey()
  final String subscriptionStatus;

  @override
  String toString() {
    return 'VerifyOtpDataModel(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, isNewUser: $isNewUser, subscriptionStatus: $subscriptionStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpDataModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken, user,
      isNewUser, subscriptionStatus);

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpDataModelImplCopyWith<_$VerifyOtpDataModelImpl> get copyWith =>
      __$$VerifyOtpDataModelImplCopyWithImpl<_$VerifyOtpDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpDataModelImplToJson(
      this,
    );
  }
}

abstract class _VerifyOtpDataModel implements VerifyOtpDataModel {
  const factory _VerifyOtpDataModel(
      {required final String accessToken,
      required final String refreshToken,
      final AuthUserModel? user,
      final bool isNewUser,
      final String subscriptionStatus}) = _$VerifyOtpDataModelImpl;

  factory _VerifyOtpDataModel.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpDataModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  AuthUserModel? get user;
  @override
  bool get isNewUser;
  @override
  String get subscriptionStatus;

  /// Create a copy of VerifyOtpDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyOtpDataModelImplCopyWith<_$VerifyOtpDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) {
  return _AuthUserModel.fromJson(json);
}

/// @nodoc
mixin _$AuthUserModel {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get cityId => throw _privateConstructorUsedError;
  String? get areaId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this AuthUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserModelCopyWith<AuthUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserModelCopyWith<$Res> {
  factory $AuthUserModelCopyWith(
          AuthUserModel value, $Res Function(AuthUserModel) then) =
      _$AuthUserModelCopyWithImpl<$Res, AuthUserModel>;
  @useResult
  $Res call(
      {String id,
      String phone,
      String? name,
      String? email,
      String? cityId,
      String? areaId,
      String status});
}

/// @nodoc
class _$AuthUserModelCopyWithImpl<$Res, $Val extends AuthUserModel>
    implements $AuthUserModelCopyWith<$Res> {
  _$AuthUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? cityId = freezed,
    Object? areaId = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaId: freezed == areaId
          ? _value.areaId
          : areaId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserModelImplCopyWith<$Res>
    implements $AuthUserModelCopyWith<$Res> {
  factory _$$AuthUserModelImplCopyWith(
          _$AuthUserModelImpl value, $Res Function(_$AuthUserModelImpl) then) =
      __$$AuthUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phone,
      String? name,
      String? email,
      String? cityId,
      String? areaId,
      String status});
}

/// @nodoc
class __$$AuthUserModelImplCopyWithImpl<$Res>
    extends _$AuthUserModelCopyWithImpl<$Res, _$AuthUserModelImpl>
    implements _$$AuthUserModelImplCopyWith<$Res> {
  __$$AuthUserModelImplCopyWithImpl(
      _$AuthUserModelImpl _value, $Res Function(_$AuthUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = freezed,
    Object? email = freezed,
    Object? cityId = freezed,
    Object? areaId = freezed,
    Object? status = null,
  }) {
    return _then(_$AuthUserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      areaId: freezed == areaId
          ? _value.areaId
          : areaId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserModelImpl implements _AuthUserModel {
  const _$AuthUserModelImpl(
      {required this.id,
      required this.phone,
      this.name,
      this.email,
      this.cityId,
      this.areaId,
      this.status = 'ACTIVE'});

  factory _$AuthUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String phone;
  @override
  final String? name;
  @override
  final String? email;
  @override
  final String? cityId;
  @override
  final String? areaId;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'AuthUserModel(id: $id, phone: $phone, name: $name, email: $email, cityId: $cityId, areaId: $areaId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.areaId, areaId) || other.areaId == areaId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, phone, name, email, cityId, areaId, status);

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserModelImplCopyWith<_$AuthUserModelImpl> get copyWith =>
      __$$AuthUserModelImplCopyWithImpl<_$AuthUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserModelImplToJson(
      this,
    );
  }
}

abstract class _AuthUserModel implements AuthUserModel {
  const factory _AuthUserModel(
      {required final String id,
      required final String phone,
      final String? name,
      final String? email,
      final String? cityId,
      final String? areaId,
      final String status}) = _$AuthUserModelImpl;

  factory _AuthUserModel.fromJson(Map<String, dynamic> json) =
      _$AuthUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get phone;
  @override
  String? get name;
  @override
  String? get email;
  @override
  String? get cityId;
  @override
  String? get areaId;
  @override
  String get status;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserModelImplCopyWith<_$AuthUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
