// lib/core/providers/navigation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index of the currently selected bottom-nav branch.
/// Updated by [MainShellScaffold] so keep-alive tab pages can react to
/// becoming visible / hidden without being destroyed.
final currentTabIndexProvider = StateProvider<int>((ref) => 0);
