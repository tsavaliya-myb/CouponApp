import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String id;
  final String name;
  final String status;

  const CityEntity({
    required this.id,
    required this.name,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, status];
}

class AreaEntity extends Equatable {
  final String id;
  final String name;
  final String cityId;
  final bool isActive;

  const AreaEntity({
    required this.id,
    required this.name,
    required this.cityId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, cityId, isActive];
}
