import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../security/token_service.dart';

final userRoleProvider = FutureProvider<String?>((ref) async {
  final tokenService = GetIt.I<TokenService>();
  return await tokenService.getRole();
});
