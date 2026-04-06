// lib/features/auth/domain/entities/user_entity.dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? cityId;
  final String? areaId;
  final String status;
  final String subscriptionStatus;
  final bool isNewUser;

  const UserEntity({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.cityId,
    this.areaId,
    this.status = 'ACTIVE',
    this.subscriptionStatus = 'NONE',
    this.isNewUser = false,
  });

  bool get isProfileComplete => name != null && areaId != null;

  @override
  List<Object?> get props => [id, phone];
}
