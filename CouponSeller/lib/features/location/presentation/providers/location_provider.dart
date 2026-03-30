import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';

part 'location_provider.g.dart';

@riverpod
class CitiesNotifier extends _$CitiesNotifier {
  late final LocationRepository _repository;

  @override
  FutureOr<List<CityEntity>> build() async {
    _repository = getIt<LocationRepository>();
    return _fetchCities();
  }

  Future<List<CityEntity>> _fetchCities() async {
    final result = await _repository.getCities();
    return result.fold(
      (failure) {
        throw failure.message; // Let Riverpod handle the error state
      },
      (cities) => cities,
    );
  }
}

@riverpod
class AreasNotifier extends _$AreasNotifier {
  late final LocationRepository _repository;

  @override
  FutureOr<List<AreaEntity>> build(String cityId) async {
    if (cityId.isEmpty) return [];
    
    _repository = getIt<LocationRepository>();
    return _fetchAreas(cityId);
  }

  Future<List<AreaEntity>> _fetchAreas(String cityId) async {
    final result = await _repository.getAreas(cityId);
    return result.fold(
      (failure) {
        throw failure.message;
      },
      (areas) => areas,
    );
  }
}
