// lib/core/network/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

/// Provides reactive connectivity state via Riverpod.
@singleton
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService(this._connectivity);

  Stream<bool> get onConnectivityChanged => _connectivity
      .onConnectivityChanged
      .map((results) => _isConnected(results));

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  bool _isConnected(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}

// ---------------------------------------------------------------------------
// Riverpod provider for connectivity — watch in widgets
// ---------------------------------------------------------------------------

final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));
});
