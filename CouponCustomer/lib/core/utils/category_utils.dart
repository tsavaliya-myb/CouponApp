import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_icons.dart';
import '../models/category_item.dart';

class CategoryUtils {
  CategoryUtils._();

  static Color getBaseColor(CategoryItem? category) {
    if (category?.color != null && category!.color!.isNotEmpty) {
      try {
        final hexCode = category.color!.replaceAll('#', '');
        return Color(int.parse('FF$hexCode', radix: 16));
      } catch (e) {
        // Fallback on error
      }
    }

    return switch (category?.slug.toLowerCase()) {
      'food' => AppColors.catFood,
      'cafe' => AppColors.catCafe,
      'salon' => AppColors.catSalon,
      'spa' => AppColors.catSpa,
      'theater' => AppColors.catTheater,
      'all' => AppColors.catTheater,
      _ => AppColors.catTheater,
    };
  }

  static (Color, Color) getCategoryColors(CategoryItem? category) {
    final baseColor = getBaseColor(category);
    return (baseColor.withOpacity(0.15), baseColor);
  }

  static IconData getIcon(CategoryItem? category) {
    if (category?.iconName != null && category!.iconName!.isNotEmpty) {
      var iconName = category.iconName!;
      var icon = AppIcons.getIcon(iconName);

      if (icon == null && !iconName.endsWith('_rounded')) {
        icon = AppIcons.getIcon('${iconName}_rounded');
      }

      if (icon != null) {
        return icon;
      }
    }

    return switch (category?.slug.toLowerCase()) {
      'food' => Icons.restaurant_rounded,
      'cafe' => Icons.coffee_rounded,
      'salon' => Icons.content_cut_rounded,
      'spa' => Icons.spa_rounded,
      'theater' => Icons.movie_rounded,
      _ => Icons.local_offer_rounded,
    };
  }
}
