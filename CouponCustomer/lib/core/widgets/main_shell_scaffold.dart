// lib/core/widgets/main_shell_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_nav_bar.dart';
import 'app_header.dart';
import 'city_selection_sheet.dart';
import '../constants/app_colors.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

class MainShellScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends ConsumerState<MainShellScaffold> {
  bool _cityGateShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkCityGate());
  }

  void _checkCityGate() {
    ref.read(profileProvider).whenData((user) {
      if (user.cityId == null && !_cityGateShown) _showCityGate();
    });
  }

  Future<void> _showCityGate() async {
    _cityGateShown = true;
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CitySelectionSheet(),
    );
  }

  String _screenName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'My Coupons';
      case 2:
        return 'Sellers';
      case 3:
        return 'Wallet';
      case 4:
        return 'Identity QR';
      case 5:
        return 'Profile';
      default:
        return 'The Win';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-check whenever profile loads/changes (handles the case where profile
    // loads after initState fires).
    ref.listen(profileProvider, (_, next) {
      next.whenData((user) {
        if (user.cityId == null && !_cityGateShown) _showCityGate();
      });
    });

    final isHome = widget.navigationShell.currentIndex == 0;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: isHome ? const Color(0xFFD4920A) : AppColors.dsSurface,
          child: SafeArea(
            bottom: false,
            child: Container(
              height: kToolbarHeight,
              alignment: Alignment.center,
              child: AppHeader(
                title: _screenName(widget.navigationShell.currentIndex),
                showProfileIcon:
                    widget.navigationShell.currentIndex == 5 ? false : true,
              ),
            ),
          ),
        ),
      ),
      body: widget.navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
