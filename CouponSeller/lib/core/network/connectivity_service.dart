import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(true) {
    _init();
  }

  void _init() {
    Connectivity().onConnectivityChanged.listen((result) {
      state = !result.contains(ConnectivityResult.none);
        });
  }
}
