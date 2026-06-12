import 'package:equatable/equatable.dart';

class AuthResultEntity extends Equatable {
  final bool isRegistered;
  final String? registrationToken;
  final String? status;
  final String? agreementStatus;

  const AuthResultEntity({
    required this.isRegistered,
    this.registrationToken,
    this.status,
    this.agreementStatus,
  });

  @override
  List<Object?> get props => [isRegistered, registrationToken, status, agreementStatus];
}
