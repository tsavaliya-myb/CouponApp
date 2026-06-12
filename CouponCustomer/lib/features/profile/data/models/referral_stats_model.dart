import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_stats_model.freezed.dart';
part 'referral_stats_model.g.dart';

@freezed
class ReferralStatsModel with _$ReferralStatsModel {
  const factory ReferralStatsModel({
    String? referralCode,
    @Default(0) int successfulReferrals,
    @Default(10) int maxLimit,
    @Default(0) int totalEarnedCoins,
  }) = _ReferralStatsModel;

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralStatsModelFromJson(json);
}
