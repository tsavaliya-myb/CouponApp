// lib/core/widgets/main_shell_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_nav_bar.dart';
import 'app_header.dart';
import '../constants/app_colors.dart';

class MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({super.key, required this.navigationShell});

  String _getScreenName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'My Coupons';
      case 2:
        return 'Identity QR';
      case 3:
        return 'Sellers';
      case 4:
        return 'Wallet';
      case 5:
        return 'Profile';
      default:
        return 'The Win';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody:
          true, // Needed so screens flow cleanly behind the floating bottom nav
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: kToolbarHeight,
            alignment: Alignment.center,
            child: AppHeader(
              title: _getScreenName(navigationShell.currentIndex),
              showProfileIcon: navigationShell.currentIndex == 5 ? false : true,
            ),
          ),
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // Navigates to the corresponding branch safely, keeping state alive
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
