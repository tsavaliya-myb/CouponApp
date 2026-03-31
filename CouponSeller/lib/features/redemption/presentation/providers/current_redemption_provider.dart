import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/verify_user_entity.dart';

final currentRedemptionProvider = StateProvider<VerifyUserEntity?>((ref) => null);
