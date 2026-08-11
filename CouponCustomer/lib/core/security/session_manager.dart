// lib/core/security/session_manager.dart
import 'dart:async';
import 'package:injectable/injectable.dart';

/// Bridges layers that cannot reach Riverpod (Dio interceptors, background
/// services) to the auth state. When a refresh attempt fails and the session is
/// unrecoverable, call [expire] — AuthNotifier listens and runs the full logout
/// cleanup (token wipe, Hive wipe, provider invalidation, redirect to login).
@singleton
class SessionManager {
  final _controller = StreamController<void>.broadcast();

  /// Emits whenever the session becomes unrecoverable.
  Stream<void> get onSessionExpired => _controller.stream;

  void expire() {
    if (!_controller.isClosed) _controller.add(null);
  }

  void dispose() => _controller.close();
}
