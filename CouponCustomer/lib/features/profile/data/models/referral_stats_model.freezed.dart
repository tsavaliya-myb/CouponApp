// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'referral_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReferralStatsModel _$ReferralStatsModelFromJson(Map<String, dynamic> json) {
  return _ReferralStatsModel.fromJson(json);
}

/// @nodoc
mixin _$ReferralStatsModel {
  String? get referralCode => throw _privateConstructorUsedError;
  int get successfulReferrals => throw _privateConstructorUsedError;
  int get maxLimit => throw _privateConstructorUsedError;
  int get totalEarnedCoins => throw _privateConstructorUsedError;

  /// Serializes this ReferralStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReferralStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReferralStatsModelCopyWith<ReferralStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReferralStatsModelCopyWith<$Res> {
  factory $ReferralStatsModelCopyWith(
          ReferralStatsModel value, $Res Function(ReferralStatsModel) then) =
      _$ReferralStatsModelCopyWithImpl<$Res, ReferralStatsModel>;
  @useResult
  $Res call(
      {String? referralCode,
      int successfulReferrals,
      int maxLimit,
      int totalEarnedCoins});
}

/// @nodoc
class _$ReferralStatsModelCopyWithImpl<$Res, $Val extends ReferralStatsModel>
    implements $ReferralStatsModelCopyWith<$Res> {
  _$ReferralStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReferralStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = freezed,
    Object? successfulReferrals = null,
    Object? maxLimit = null,
    Object? totalEarnedCoins = null,
  }) {
    return _then(_value.copyWith(
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      successfulReferrals: null == successfulReferrals
          ? _value.successfulReferrals
          : successfulReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      maxLimit: null == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      totalEarnedCoins: null == totalEarnedCoins
          ? _value.totalEarnedCoins
          : totalEarnedCoins // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReferralStatsModelImplCopyWith<$Res>
    implements $ReferralStatsModelCopyWith<$Res> {
  factory _$$ReferralStatsModelImplCopyWith(_$ReferralStatsModelImpl value,
          $Res Function(_$ReferralStatsModelImpl) then) =
      __$$ReferralStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? referralCode,
      int successfulReferrals,
      int maxLimit,
      int totalEarnedCoins});
}

/// @nodoc
class __$$ReferralStatsModelImplCopyWithImpl<$Res>
    extends _$ReferralStatsModelCopyWithImpl<$Res, _$ReferralStatsModelImpl>
    implements _$$ReferralStatsModelImplCopyWith<$Res> {
  __$$ReferralStatsModelImplCopyWithImpl(_$ReferralStatsModelImpl _value,
      $Res Function(_$ReferralStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReferralStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? referralCode = freezed,
    Object? successfulReferrals = null,
    Object? maxLimit = null,
    Object? totalEarnedCoins = null,
  }) {
    return _then(_$ReferralStatsModelImpl(
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      successfulReferrals: null == successfulReferrals
          ? _value.successfulReferrals
          : successfulReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      maxLimit: null == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      totalEarnedCoins: null == totalEarnedCoins
          ? _value.totalEarnedCoins
          : totalEarnedCoins // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReferralStatsModelImpl implements _ReferralStatsModel {
  const _$ReferralStatsModelImpl(
      {this.referralCode,
      this.successfulReferrals = 0,
      this.maxLimit = 10,
      this.totalEarnedCoins = 0});

  factory _$ReferralStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReferralStatsModelImplFromJson(json);

  @override
  final String? referralCode;
  @override
  @JsonKey()
  final int successfulReferrals;
  @override
  @JsonKey()
  final int maxLimit;
  @override
  @JsonKey()
  final int totalEarnedCoins;

  @override
  String toString() {
    return 'ReferralStatsModel(referralCode: $referralCode, successfulReferrals: $successfulReferrals, maxLimit: $maxLimit, totalEarnedCoins: $totalEarnedCoins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReferralStatsModelImpl &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.successfulReferrals, successfulReferrals) ||
                other.successfulReferrals == successfulReferrals) &&
            (identical(other.maxLimit, maxLimit) ||
                other.maxLimit == maxLimit) &&
            (identical(other.totalEarnedCoins, totalEarnedCoins) ||
                other.totalEarnedCoins == totalEarnedCoins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, referralCode,
      successfulReferrals, maxLimit, totalEarnedCoins);

  /// Create a copy of ReferralStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReferralStatsModelImplCopyWith<_$ReferralStatsModelImpl> get copyWith =>
      __$$ReferralStatsModelImplCopyWithImpl<_$ReferralStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReferralStatsModelImplToJson(
      this,
    );
  }
}

abstract class _ReferralStatsModel implements ReferralStatsModel {
  const factory _ReferralStatsModel(
      {final String? referralCode,
      final int successfulReferrals,
      final int maxLimit,
      final int totalEarnedCoins}) = _$ReferralStatsModelImpl;

  factory _ReferralStatsModel.fromJson(Map<String, dynamic> json) =
      _$ReferralStatsModelImpl.fromJson;

  @override
  String? get referralCode;
  @override
  int get successfulReferrals;
  @override
  int get maxLimit;
  @override
  int get totalEarnedCoins;

  /// Create a copy of ReferralStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReferralStatsModelImplCopyWith<_$ReferralStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
