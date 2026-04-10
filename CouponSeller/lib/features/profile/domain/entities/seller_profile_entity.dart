import 'package:equatable/equatable.dart';

class SellerProfileEntity extends Equatable {
  final String id;
  final String businessName;
  final String category;
  final String cityId;
  final String areaId;
  final String? address;
  final String phone;
  final String? email;
  final String? upiId;
  final double? latitude;
  final double? longitude;
  final String? logoUrl;
  final String? photoUrl1;
  final String? photoUrl2;
  final String? videoUrl;
  final double commissionPct;
  final String status;
  final String createdAt;
  final String cityName;
  final String areaName;

  const SellerProfileEntity({
    required this.id,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    this.address,
    required this.phone,
    this.email,
    this.upiId,
    this.latitude,
    this.longitude,
    this.logoUrl,
    this.photoUrl1,
    this.photoUrl2,
    this.videoUrl,
    required this.commissionPct,
    required this.status,
    required this.createdAt,
    required this.cityName,
    required this.areaName,
  });

  bool get isActive => status == 'ACTIVE';

  String get formattedPhone => '+91 ${phone.substring(0, 5)} ${phone.substring(5)}';

  String get displayAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    parts.add(areaName);
    parts.add(cityName);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        id,
        businessName,
        phone,
        status,
        logoUrl,
        photoUrl1,
        photoUrl2,
        videoUrl,
      ];
}
