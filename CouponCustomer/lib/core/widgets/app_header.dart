// lib/core/widgets/app_header.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final bool showDefaultNotification;
  final bool showDefaultLocation;
  final bool isItalic;
  final TextStyle? titleStyle;

  const AppHeader({
    super.key,
    required this.title,
    this.leftWidget,
    this.rightWidget,
    this.showDefaultNotification = true,
    this.showDefaultLocation = true,
    this.isItalic = false,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    Widget? activeLeftWidget = leftWidget;
    if (activeLeftWidget == null && showDefaultLocation) {
      activeLeftWidget = const Icon(Icons.location_on, color: AppColors.dsPrimary, size: 24);
    }

    Widget? activeRightWidget = rightWidget;
    if (activeRightWidget == null && showDefaultNotification) {
      activeRightWidget = Icon(Icons.notifications_rounded, color: AppColors.dsOnSurface.withOpacity(0.6), size: 28);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (activeLeftWidget != null) ...[
                activeLeftWidget,
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: titleStyle ??
                    AppTextStyles.dsTitleLg.copyWith(
                      color: AppColors.dsPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    ),
              ),
            ],
          ),
          if (activeRightWidget != null) activeRightWidget,
        ],
      ),
    );
  }
}
