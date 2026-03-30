import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement_model.freezed.dart';
part 'settlement_model.g.dart';

@freezed
class SettlementResponseModel with _$SettlementResponseModel {
  const factory SettlementResponseModel({
    required bool success,
    required List<SettlementItemModel> data,
    required SettlementMetaModel meta,
  }) = _SettlementResponseModel;

  factory SettlementResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementResponseModelFromJson(json);
}

@freezed
class SettlementItemModel with _$SettlementItemModel {
  const factory SettlementItemModel({
    required String id,
    required String sellerId,
    required DateTime weekStart,
    required DateTime weekEnd,
    required double commissionTotal,
    required String commissionStatus,
    DateTime? commissionPaidAt,
    required double coinCompensationTotal,
    required String coinCompStatus,
    DateTime? coinCompPaidAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SettlementItemModel;

  factory SettlementItemModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementItemModelFromJson(json);
}

@freezed
class SettlementMetaModel with _$SettlementMetaModel {
  const factory SettlementMetaModel({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _SettlementMetaModel;

  factory SettlementMetaModel.fromJson(Map<String, dynamic> json) =>
      _$SettlementMetaModelFromJson(json);
}
