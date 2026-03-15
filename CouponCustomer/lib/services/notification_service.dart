// lib/services/notification_service.dart
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Handles push notifications (Stub Version)
@singleton
class NotificationService {
  final Logger _log = Logger();

  Future<void> init() async {
    _log.i('[NotificationService] Stub initialized');
  }

  Future<String?> getToken() async {
    _log.d('[NotificationService] getToken called - returning stub-token');
    return 'stub-fcm-token';
  }
}
