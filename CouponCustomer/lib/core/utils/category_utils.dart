// lib/core/utils/category_utils.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/category_item.dart';

class CategoryUtils {
  CategoryUtils._();

  /// Returns the base accent color for a category.
  static Color getBaseColor(CategoryItem? category) {
    return switch (category?.slug.toLowerCase()) {
      'food' => AppColors.catFood,
      'cafe' => AppColors.catCafe,
      'salon' => AppColors.catSalon,
      'spa' => AppColors.catSpa,
      'theater' => AppColors.catTheater,
      _ => AppColors.catDefault,
    };
  }

  /// Returns a neutral fallback color for when a category has no imageUrl.
  /// Equivalent to [getBaseColor].
  static Color getFallbackColor(CategoryItem? category) => getBaseColor(category);

  /// Returns an icon representing the category.
  static IconData getIcon(CategoryItem? category) {
    return switch (category?.slug.toLowerCase()) {
      'food' => Icons.restaurant_rounded,
      'cafe' => Icons.local_cafe_rounded,
      'salon' => Icons.content_cut_rounded,
      'spa' => Icons.spa_rounded,
      'theater' => Icons.theaters_rounded,
      _ => Icons.local_offer_rounded,
    };
  }

  /// Returns a (background, onBackground) color pair for the category brand panel.
  ///
  /// `bg`    — the category's accent color used as the panel background.
  /// `onBg`  — a contrasting foreground color (white for all current dark cat colors).
  static (Color bg, Color onBg) getCategoryColors(CategoryItem? category) {
    final bg = getBaseColor(category);
    // All AppColors.cat* values are dark, so white always gives readable contrast.
    return (bg, Colors.white);
  }
}
