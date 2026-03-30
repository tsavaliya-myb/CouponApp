import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class DashboardResponseModel with _$DashboardResponseModel {
  const factory DashboardResponseModel({
    required bool success,
    required DashboardDataModel data,
  }) = _DashboardResponseModel;

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseModelFromJson(json);
}

@freezed
class DashboardDataModel with _$DashboardDataModel {
  const factory DashboardDataModel({
    required int totalRedemptions,
    required String status,
    required double commissionPct,
    required int todaysRedemptions,
    required int thisWeekRedemptions,
    required double commissionOwed,
    required double coinReceivable,
    required List<RecentRedemptionModel> recentRedemptions,
    String? businessName,
    String? city,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);
}

@freezed
class RecentRedemptionModel with _$RecentRedemptionModel {
  const factory RecentRedemptionModel({
    required String id,
    required String couponName,
    required double amount,
    required DateTime createdAt,
  }) = _RecentRedemptionModel;

  factory RecentRedemptionModel.fromJson(Map<String, dynamic> json) =>
      _$RecentRedemptionModelFromJson(json);
}
