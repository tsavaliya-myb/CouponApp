import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_service.dart';

class NetworkAwareWidget extends ConsumerWidget {
  final Widget child;
  final Widget? offlineChild;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.offlineChild,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityProvider);
    if (!isConnected) {
      return offlineChild ?? const Center(child: Text('You are offline. Please check your connection.'));
    }
    return child;
  }
}
