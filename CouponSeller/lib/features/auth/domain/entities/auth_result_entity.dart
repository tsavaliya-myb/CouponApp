import 'package:equatable/equatable.dart';

class AuthResultEntity extends Equatable {
  final bool isRegistered;
  final String? registrationToken;
  final String? status;

  const AuthResultEntity({
    required this.isRegistered,
    this.registrationToken,
    this.status,
  });

  @override
  List<Object?> get props => [isRegistered, registrationToken, status];
}
