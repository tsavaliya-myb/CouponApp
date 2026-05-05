// lib/core/widgets/app_header.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool showSearchBar;
  final bool showProfileIcon;
  final bool showDefaultLocation;
  final bool isItalic;
  final TextStyle? titleStyle;

  const AppHeader({
    super.key,
    required this.title,
    this.leftWidget,
    this.rightWidget,
    this.showSearchBar = true,
    this.showProfileIcon = true,
    this.showDefaultLocation = true,
    this.isItalic = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    Widget? activeLeftWidget = leftWidget;
    if (activeLeftWidget == null && showDefaultLocation) {
      activeLeftWidget =
          const Icon(Icons.location_on, color: Color(0xFF775A00), size: 24);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (activeLeftWidget != null) ...[
                  activeLeftWidget,
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    title,
                    style: titleStyle ??
                        AppTextStyles.dsTitleLg.copyWith(
                          color: const Color(0xFF775A00),
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          fontStyle:
                              isItalic ? FontStyle.italic : FontStyle.normal,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (showSearchBar) ...[
                _HeaderIcon(
                  icon: Icons.search_rounded,
                  onTap: () {
                    context.push('/search');
                  },
                ),
                const SizedBox(width: 12),
              ],
              if (showProfileIcon)
                _HeaderIcon(
                  icon: Icons.person_rounded,
                  onTap: () => context.go('/profile'),
                ),
              if (rightWidget != null) ...[
                const SizedBox(width: 12),
                rightWidget!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(
        icon,
        size: 28,
        color: AppColors.dsOnSurface.withOpacity(0.8),
      ),
    );
  }
}
