// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) {
  return _UserSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$UserSettingsModel {
  int get subscriptionPrice => throw _privateConstructorUsedError;
  int get bookValidityDays => throw _privateConstructorUsedError;
  int get maxCoinsPerTransaction => throw _privateConstructorUsedError;
  int get totalActiveCoupons => throw _privateConstructorUsedError;

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsModelCopyWith<UserSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsModelCopyWith<$Res> {
  factory $UserSettingsModelCopyWith(
          UserSettingsModel value, $Res Function(UserSettingsModel) then) =
      _$UserSettingsModelCopyWithImpl<$Res, UserSettingsModel>;
  @useResult
  $Res call(
      {int subscriptionPrice,
      int bookValidityDays,
      int maxCoinsPerTransaction,
      int totalActiveCoupons});
}

/// @nodoc
class _$UserSettingsModelCopyWithImpl<$Res, $Val extends UserSettingsModel>
    implements $UserSettingsModelCopyWith<$Res> {
  _$UserSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionPrice = null,
    Object? bookValidityDays = null,
    Object? maxCoinsPerTransaction = null,
    Object? totalActiveCoupons = null,
  }) {
    return _then(_value.copyWith(
      subscriptionPrice: null == subscriptionPrice
          ? _value.subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as int,
      bookValidityDays: null == bookValidityDays
          ? _value.bookValidityDays
          : bookValidityDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxCoinsPerTransaction: null == maxCoinsPerTransaction
          ? _value.maxCoinsPerTransaction
          : maxCoinsPerTransaction // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveCoupons: null == totalActiveCoupons
          ? _value.totalActiveCoupons
          : totalActiveCoupons // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsModelImplCopyWith<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  factory _$$UserSettingsModelImplCopyWith(_$UserSettingsModelImpl value,
          $Res Function(_$UserSettingsModelImpl) then) =
      __$$UserSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int subscriptionPrice,
      int bookValidityDays,
      int maxCoinsPerTransaction,
      int totalActiveCoupons});
}

/// @nodoc
class __$$UserSettingsModelImplCopyWithImpl<$Res>
    extends _$UserSettingsModelCopyWithImpl<$Res, _$UserSettingsModelImpl>
    implements _$$UserSettingsModelImplCopyWith<$Res> {
  __$$UserSettingsModelImplCopyWithImpl(_$UserSettingsModelImpl _value,
      $Res Function(_$UserSettingsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptionPrice = null,
    Object? bookValidityDays = null,
    Object? maxCoinsPerTransaction = null,
    Object? totalActiveCoupons = null,
  }) {
    return _then(_$UserSettingsModelImpl(
      subscriptionPrice: null == subscriptionPrice
          ? _value.subscriptionPrice
          : subscriptionPrice // ignore: cast_nullable_to_non_nullable
              as int,
      bookValidityDays: null == bookValidityDays
          ? _value.bookValidityDays
          : bookValidityDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxCoinsPerTransaction: null == maxCoinsPerTransaction
          ? _value.maxCoinsPerTransaction
          : maxCoinsPerTransaction // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveCoupons: null == totalActiveCoupons
          ? _value.totalActiveCoupons
          : totalActiveCoupons // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsModelImpl implements _UserSettingsModel {
  const _$UserSettingsModelImpl(
      {this.subscriptionPrice = 0,
      this.bookValidityDays = 0,
      this.maxCoinsPerTransaction = 0,
      this.totalActiveCoupons = 0});

  factory _$UserSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final int subscriptionPrice;
  @override
  @JsonKey()
  final int bookValidityDays;
  @override
  @JsonKey()
  final int maxCoinsPerTransaction;
  @override
  @JsonKey()
  final int totalActiveCoupons;

  @override
  String toString() {
    return 'UserSettingsModel(subscriptionPrice: $subscriptionPrice, bookValidityDays: $bookValidityDays, maxCoinsPerTransaction: $maxCoinsPerTransaction, totalActiveCoupons: $totalActiveCoupons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsModelImpl &&
            (identical(other.subscriptionPrice, subscriptionPrice) ||
                other.subscriptionPrice == subscriptionPrice) &&
            (identical(other.bookValidityDays, bookValidityDays) ||
                other.bookValidityDays == bookValidityDays) &&
            (identical(other.maxCoinsPerTransaction, maxCoinsPerTransaction) ||
                other.maxCoinsPerTransaction == maxCoinsPerTransaction) &&
            (identical(other.totalActiveCoupons, totalActiveCoupons) ||
                other.totalActiveCoupons == totalActiveCoupons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subscriptionPrice,
      bookValidityDays, maxCoinsPerTransaction, totalActiveCoupons);

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsModelImplCopyWith<_$UserSettingsModelImpl> get copyWith =>
      __$$UserSettingsModelImplCopyWithImpl<_$UserSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _UserSettingsModel implements UserSettingsModel {
  const factory _UserSettingsModel(
      {final int subscriptionPrice,
      final int bookValidityDays,
      final int maxCoinsPerTransaction,
      final int totalActiveCoupons}) = _$UserSettingsModelImpl;

  factory _UserSettingsModel.fromJson(Map<String, dynamic> json) =
      _$UserSettingsModelImpl.fromJson;

  @override
  int get subscriptionPrice;
  @override
  int get bookValidityDays;
  @override
  int get maxCoinsPerTransaction;
  @override
  int get totalActiveCoupons;

  /// Create a copy of UserSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsModelImplCopyWith<_$UserSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
