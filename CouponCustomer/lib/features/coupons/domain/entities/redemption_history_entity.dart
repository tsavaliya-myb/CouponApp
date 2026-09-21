class RedemptionHistoryEntity {
  final String id;
  final String businessName;
  final String? areaName;
  final double billAmount;
  final double discountAmount;
  final int coinsUsed;
  final double finalAmount;
  final String type; // 'STANDARD' or 'BOGO'
  final double discountPct;
  final DateTime redeemedAt;

  RedemptionHistoryEntity({
    required this.id,
    required this.businessName,
    this.areaName,
    required this.billAmount,
    required this.discountAmount,
    required this.coinsUsed,
    required this.finalAmount,
    required this.type,
    required this.discountPct,
    required this.redeemedAt,
  });

  factory RedemptionHistoryEntity.fromJson(Map<String, dynamic> json) {
    return RedemptionHistoryEntity(
      id: json['id'],
      businessName: json['seller']['businessName'],
      areaName: json['seller']['area']?['name'],
      billAmount: (json['billAmount'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      coinsUsed: (json['coinsUsed'] as num).toInt(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
      type: json['userCoupon']['coupon']['type'],
      discountPct: (json['userCoupon']['coupon']['discountPct'] as num).toDouble(),
      redeemedAt: DateTime.parse(json['redeemedAt']),
    );
  }
}

