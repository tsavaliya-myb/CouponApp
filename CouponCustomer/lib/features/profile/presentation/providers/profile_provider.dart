import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../data/models/user_model.dart';
import '../../data/models/area_model.dart';
import '../../data/models/user_settings_model.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileNotifier extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    ref.keepAlive(); // Never dispose — avoids re-fetching on every tab switch
    final repository = GetIt.I<ProfileRepository>();
    final result = await repository.getUser();
    return result.fold((f) => throw f.message, (u) => u);
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    final repository = GetIt.I<ProfileRepository>();
    final result = await repository.updateUser(data);
    result.fold(
      (f) => throw f.message,
      (u) => state = AsyncData(u),
    );
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, UserModel>(
  ProfileNotifier.new,
);

final areasProvider = FutureProvider.family<List<AreaModel>, String>((ref, cityId) async {
  final repository = GetIt.I<ProfileRepository>();
  final result = await repository.getAreas(cityId);
  return result.fold(
    (f) => throw f.message,
    (areas) => areas.where((a) => a.isActive).toList(),
  );
});

final citiesProvider = FutureProvider<List<CityModel>>((ref) async {
  final repository = GetIt.I<ProfileRepository>();
  final result = await repository.getCities();
  return result.fold(
    (f) => throw f.message,
    (cities) => cities.where((c) => c.status == 'ACTIVE').toList(),
  );
});

final userSettingsProvider = FutureProvider<UserSettingsModel>((ref) async {
  final repository = GetIt.I<ProfileRepository>();
  final result = await repository.getUserSettings();
  return result.fold(
    (f) => throw f.message,
    (settings) => settings,
  );
});
