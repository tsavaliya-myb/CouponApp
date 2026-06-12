import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final String id;
  final String phone;
  final String? fullName;
  final String businessName;
  final String category;
  final String cityId;
  final String areaId;
  final String status;
  final String address;
  final String? pincode;
  final String email;
  final String upiId;
  final double lat;
  final double lng;

  const SellerEntity({
    required this.id,
    required this.phone,
    this.fullName,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    required this.status,
    required this.address,
    this.pincode,
    required this.email,
    required this.upiId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
        id,
        phone,
        fullName,
        businessName,
        category,
        cityId,
        areaId,
        status,
        address,
        pincode,
        email,
        upiId,
        lat,
        lng,
      ];
}

class RegisterSellerParams extends Equatable {
  final String registrationToken;
  final String fullName;
  final String businessName;
  final String categoryId;
  final String cityId;
  final String areaId;
  final String address;
  final String pincode;
  final String email;
  final String upiId;
  final double lat;
  final double lng;

  const RegisterSellerParams({
    required this.registrationToken,
    required this.fullName,
    required this.businessName,
    required this.categoryId,
    required this.cityId,
    required this.areaId,
    required this.address,
    required this.pincode,
    required this.email,
    required this.upiId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
        registrationToken,
        fullName,
        businessName,
        categoryId,
        cityId,
        areaId,
        address,
        pincode,
        email,
        upiId,
        lat,
        lng,
      ];
}
