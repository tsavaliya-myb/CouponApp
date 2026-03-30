import 'package:equatable/equatable.dart';

class SellerEntity extends Equatable {
  final String id;
  final String phone;
  final String businessName;
  final String category;
  final String cityId;
  final String areaId;
  final String status;
  final String address;
  final String email;
  final String upiId;
  final double lat;
  final double lng;

  const SellerEntity({
    required this.id,
    required this.phone,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    required this.status,
    required this.address,
    required this.email,
    required this.upiId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
        id,
        phone,
        businessName,
        category,
        cityId,
        areaId,
        status,
        address,
        email,
        upiId,
        lat,
        lng,
      ];
}

class RegisterSellerParams extends Equatable {
  final String registrationToken;
  final String businessName;
  final String category;
  final String cityId;
  final String areaId;
  final String address;
  final String email;
  final String upiId;
  final double lat;
  final double lng;

  const RegisterSellerParams({
    required this.registrationToken,
    required this.businessName,
    required this.category,
    required this.cityId,
    required this.areaId,
    required this.address,
    required this.email,
    required this.upiId,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
        registrationToken,
        businessName,
        category,
        cityId,
        areaId,
        address,
        email,
        upiId,
        lat,
        lng,
      ];
}
