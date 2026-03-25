// lib/core/utils/category_utils.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CategoryUtils {
  CategoryUtils._();

  /// Returns the base color for a category
  static Color getBaseColor(String category) {
    return switch (category.toLowerCase()) {
      'food' => AppColors.catFood,
      'cafe' => AppColors.catCafe,
      'salon' => AppColors.catSalon,
      'spa' => AppColors.catSpa,
      'theater' => AppColors.catTheater,
      _ => AppColors.catDefault,
    };
  }

  /// Returns a tuple of (backgroundColor, onBackgroundColor)
  static (Color, Color) getCategoryColors(String category) {
    final baseColor = getBaseColor(category);
    return (baseColor.withOpacity(0.15), baseColor);
  }

  /// Returns the icon for a category
  static IconData getIcon(String category) {
    return switch (category.toLowerCase()) {
      'food' => Icons.restaurant_rounded,
      'cafe' => Icons.coffee_rounded,
      'salon' => Icons.content_cut_rounded,
      'spa' => Icons.spa_rounded,
      'theater' => Icons.movie_rounded,
      _ => Icons.local_offer_rounded,
    };
  }

  /// Returns the emoji for a category
  static String getEmoji(String category) {
    return switch (category.toLowerCase()) {
      'food' => '🍔',
      'cafe' => '☕',
      'salon' => '💈',
      'spa' => '🛁',
      'theater' => '🎭',
      _ => '🏪',
    };
  }
}
