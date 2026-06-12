// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferralStatsModelImpl _$$ReferralStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReferralStatsModelImpl(
      referralCode: json['referralCode'] as String?,
      successfulReferrals: (json['successfulReferrals'] as num?)?.toInt() ?? 0,
      maxLimit: (json['maxLimit'] as num?)?.toInt() ?? 10,
      totalEarnedCoins: (json['totalEarnedCoins'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReferralStatsModelImplToJson(
        _$ReferralStatsModelImpl instance) =>
    <String, dynamic>{
      'referralCode': instance.referralCode,
      'successfulReferrals': instance.successfulReferrals,
      'maxLimit': instance.maxLimit,
      'totalEarnedCoins': instance.totalEarnedCoins,
    };
