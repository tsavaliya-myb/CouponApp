// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentHistoryResponse _$PaymentHistoryResponseFromJson(
    Map<String, dynamic> json) {
  return _PaymentHistoryResponse.fromJson(json);
}

/// @nodoc
mixin _$PaymentHistoryResponse {
  SubscriptionDetailsModel? get subscription =>
      throw _privateConstructorUsedError;
  List<PaymentAttemptModel> get history => throw _privateConstructorUsedError;

  /// Serializes this PaymentHistoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentHistoryResponseCopyWith<PaymentHistoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentHistoryResponseCopyWith<$Res> {
  factory $PaymentHistoryResponseCopyWith(PaymentHistoryResponse value,
          $Res Function(PaymentHistoryResponse) then) =
      _$PaymentHistoryResponseCopyWithImpl<$Res, PaymentHistoryResponse>;
  @useResult
  $Res call(
      {SubscriptionDetailsModel? subscription,
      List<PaymentAttemptModel> history});

  $SubscriptionDetailsModelCopyWith<$Res>? get subscription;
}

/// @nodoc
class _$PaymentHistoryResponseCopyWithImpl<$Res,
        $Val extends PaymentHistoryResponse>
    implements $PaymentHistoryResponseCopyWith<$Res> {
  _$PaymentHistoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscription = freezed,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionDetailsModel?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<PaymentAttemptModel>,
    ) as $Val);
  }

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionDetailsModelCopyWith<$Res>? get subscription {
    if (_value.subscription == null) {
      return null;
    }

    return $SubscriptionDetailsModelCopyWith<$Res>(_value.subscription!,
        (value) {
      return _then(_value.copyWith(subscription: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PaymentHistoryResponseImplCopyWith<$Res>
    implements $PaymentHistoryResponseCopyWith<$Res> {
  factory _$$PaymentHistoryResponseImplCopyWith(
          _$PaymentHistoryResponseImpl value,
          $Res Function(_$PaymentHistoryResponseImpl) then) =
      __$$PaymentHistoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SubscriptionDetailsModel? subscription,
      List<PaymentAttemptModel> history});

  @override
  $SubscriptionDetailsModelCopyWith<$Res>? get subscription;
}

/// @nodoc
class __$$PaymentHistoryResponseImplCopyWithImpl<$Res>
    extends _$PaymentHistoryResponseCopyWithImpl<$Res,
        _$PaymentHistoryResponseImpl>
    implements _$$PaymentHistoryResponseImplCopyWith<$Res> {
  __$$PaymentHistoryResponseImplCopyWithImpl(
      _$PaymentHistoryResponseImpl _value,
      $Res Function(_$PaymentHistoryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscription = freezed,
    Object? history = null,
  }) {
    return _then(_$PaymentHistoryResponseImpl(
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionDetailsModel?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<PaymentAttemptModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentHistoryResponseImpl implements _PaymentHistoryResponse {
  const _$PaymentHistoryResponseImpl(
      {this.subscription, final List<PaymentAttemptModel> history = const []})
      : _history = history;

  factory _$PaymentHistoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentHistoryResponseImplFromJson(json);

  @override
  final SubscriptionDetailsModel? subscription;
  final List<PaymentAttemptModel> _history;
  @override
  @JsonKey()
  List<PaymentAttemptModel> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'PaymentHistoryResponse(subscription: $subscription, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentHistoryResponseImpl &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, subscription, const DeepCollectionEquality().hash(_history));

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentHistoryResponseImplCopyWith<_$PaymentHistoryResponseImpl>
      get copyWith => __$$PaymentHistoryResponseImplCopyWithImpl<
          _$PaymentHistoryResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentHistoryResponseImplToJson(
      this,
    );
  }
}

abstract class _PaymentHistoryResponse implements PaymentHistoryResponse {
  const factory _PaymentHistoryResponse(
      {final SubscriptionDetailsModel? subscription,
      final List<PaymentAttemptModel> history}) = _$PaymentHistoryResponseImpl;

  factory _PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentHistoryResponseImpl.fromJson;

  @override
  SubscriptionDetailsModel? get subscription;
  @override
  List<PaymentAttemptModel> get history;

  /// Create a copy of PaymentHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentHistoryResponseImplCopyWith<_$PaymentHistoryResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubscriptionDetailsModel _$SubscriptionDetailsModelFromJson(
    Map<String, dynamic> json) {
  return _SubscriptionDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionDetailsModel {
  String get status => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  bool get isAutopayEnabled => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionDetailsModelCopyWith<SubscriptionDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionDetailsModelCopyWith<$Res> {
  factory $SubscriptionDetailsModelCopyWith(SubscriptionDetailsModel value,
          $Res Function(SubscriptionDetailsModel) then) =
      _$SubscriptionDetailsModelCopyWithImpl<$Res, SubscriptionDetailsModel>;
  @useResult
  $Res call(
      {String status,
      DateTime startDate,
      DateTime endDate,
      bool isAutopayEnabled});
}

/// @nodoc
class _$SubscriptionDetailsModelCopyWithImpl<$Res,
        $Val extends SubscriptionDetailsModel>
    implements $SubscriptionDetailsModelCopyWith<$Res> {
  _$SubscriptionDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isAutopayEnabled = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAutopayEnabled: null == isAutopayEnabled
          ? _value.isAutopayEnabled
          : isAutopayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionDetailsModelImplCopyWith<$Res>
    implements $SubscriptionDetailsModelCopyWith<$Res> {
  factory _$$SubscriptionDetailsModelImplCopyWith(
          _$SubscriptionDetailsModelImpl value,
          $Res Function(_$SubscriptionDetailsModelImpl) then) =
      __$$SubscriptionDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      DateTime startDate,
      DateTime endDate,
      bool isAutopayEnabled});
}

/// @nodoc
class __$$SubscriptionDetailsModelImplCopyWithImpl<$Res>
    extends _$SubscriptionDetailsModelCopyWithImpl<$Res,
        _$SubscriptionDetailsModelImpl>
    implements _$$SubscriptionDetailsModelImplCopyWith<$Res> {
  __$$SubscriptionDetailsModelImplCopyWithImpl(
      _$SubscriptionDetailsModelImpl _value,
      $Res Function(_$SubscriptionDetailsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? isAutopayEnabled = null,
  }) {
    return _then(_$SubscriptionDetailsModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAutopayEnabled: null == isAutopayEnabled
          ? _value.isAutopayEnabled
          : isAutopayEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionDetailsModelImpl implements _SubscriptionDetailsModel {
  const _$SubscriptionDetailsModelImpl(
      {required this.status,
      required this.startDate,
      required this.endDate,
      required this.isAutopayEnabled});

  factory _$SubscriptionDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionDetailsModelImplFromJson(json);

  @override
  final String status;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final bool isAutopayEnabled;

  @override
  String toString() {
    return 'SubscriptionDetailsModel(status: $status, startDate: $startDate, endDate: $endDate, isAutopayEnabled: $isAutopayEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionDetailsModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isAutopayEnabled, isAutopayEnabled) ||
                other.isAutopayEnabled == isAutopayEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, status, startDate, endDate, isAutopayEnabled);

  /// Create a copy of SubscriptionDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionDetailsModelImplCopyWith<_$SubscriptionDetailsModelImpl>
      get copyWith => __$$SubscriptionDetailsModelImplCopyWithImpl<
          _$SubscriptionDetailsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionDetailsModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionDetailsModel implements SubscriptionDetailsModel {
  const factory _SubscriptionDetailsModel(
      {required final String status,
      required final DateTime startDate,
      required final DateTime endDate,
      required final bool isAutopayEnabled}) = _$SubscriptionDetailsModelImpl;

  factory _SubscriptionDetailsModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionDetailsModelImpl.fromJson;

  @override
  String get status;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  bool get isAutopayEnabled;

  /// Create a copy of SubscriptionDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionDetailsModelImplCopyWith<_$SubscriptionDetailsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaymentAttemptModel _$PaymentAttemptModelFromJson(Map<String, dynamic> json) {
  return _PaymentAttemptModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentAttemptModel {
  String get id => throw _privateConstructorUsedError;
  String get txnid => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get kind => throw _privateConstructorUsedError;

  /// Serializes this PaymentAttemptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentAttemptModelCopyWith<PaymentAttemptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentAttemptModelCopyWith<$Res> {
  factory $PaymentAttemptModelCopyWith(
          PaymentAttemptModel value, $Res Function(PaymentAttemptModel) then) =
      _$PaymentAttemptModelCopyWithImpl<$Res, PaymentAttemptModel>;
  @useResult
  $Res call(
      {String id,
      String txnid,
      String amount,
      DateTime createdAt,
      String kind});
}

/// @nodoc
class _$PaymentAttemptModelCopyWithImpl<$Res, $Val extends PaymentAttemptModel>
    implements $PaymentAttemptModelCopyWith<$Res> {
  _$PaymentAttemptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? txnid = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? kind = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      txnid: null == txnid
          ? _value.txnid
          : txnid // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentAttemptModelImplCopyWith<$Res>
    implements $PaymentAttemptModelCopyWith<$Res> {
  factory _$$PaymentAttemptModelImplCopyWith(_$PaymentAttemptModelImpl value,
          $Res Function(_$PaymentAttemptModelImpl) then) =
      __$$PaymentAttemptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String txnid,
      String amount,
      DateTime createdAt,
      String kind});
}

/// @nodoc
class __$$PaymentAttemptModelImplCopyWithImpl<$Res>
    extends _$PaymentAttemptModelCopyWithImpl<$Res, _$PaymentAttemptModelImpl>
    implements _$$PaymentAttemptModelImplCopyWith<$Res> {
  __$$PaymentAttemptModelImplCopyWithImpl(_$PaymentAttemptModelImpl _value,
      $Res Function(_$PaymentAttemptModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? txnid = null,
    Object? amount = null,
    Object? createdAt = null,
    Object? kind = null,
  }) {
    return _then(_$PaymentAttemptModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      txnid: null == txnid
          ? _value.txnid
          : txnid // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentAttemptModelImpl implements _PaymentAttemptModel {
  const _$PaymentAttemptModelImpl(
      {required this.id,
      required this.txnid,
      required this.amount,
      required this.createdAt,
      required this.kind});

  factory _$PaymentAttemptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentAttemptModelImplFromJson(json);

  @override
  final String id;
  @override
  final String txnid;
  @override
  final String amount;
  @override
  final DateTime createdAt;
  @override
  final String kind;

  @override
  String toString() {
    return 'PaymentAttemptModel(id: $id, txnid: $txnid, amount: $amount, createdAt: $createdAt, kind: $kind)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentAttemptModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.txnid, txnid) || other.txnid == txnid) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, txnid, amount, createdAt, kind);

  /// Create a copy of PaymentAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentAttemptModelImplCopyWith<_$PaymentAttemptModelImpl> get copyWith =>
      __$$PaymentAttemptModelImplCopyWithImpl<_$PaymentAttemptModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentAttemptModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentAttemptModel implements PaymentAttemptModel {
  const factory _PaymentAttemptModel(
      {required final String id,
      required final String txnid,
      required final String amount,
      required final DateTime createdAt,
      required final String kind}) = _$PaymentAttemptModelImpl;

  factory _PaymentAttemptModel.fromJson(Map<String, dynamic> json) =
      _$PaymentAttemptModelImpl.fromJson;

  @override
  String get id;
  @override
  String get txnid;
  @override
  String get amount;
  @override
  DateTime get createdAt;
  @override
  String get kind;

  /// Create a copy of PaymentAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentAttemptModelImplCopyWith<_$PaymentAttemptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
