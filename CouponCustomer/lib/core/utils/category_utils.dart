// lib/core/utils/category_utils.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CategoryUtils {
  CategoryUtils._();

  static Color getBaseColor(String? slug) {
    return switch (slug?.toLowerCase()) {
      'food' => AppColors.catFood,
      'cafe' => AppColors.catCafe,
      'salon' => AppColors.catSalon,
      'spa' => AppColors.catSpa,
      'theater' => AppColors.catTheater,
      _ => AppColors.catDefault,
    };
  }

  static (Color, Color) getCategoryColors(String? slug) {
    final baseColor = getBaseColor(slug);
    return (baseColor.withOpacity(0.15), baseColor);
  }

  static IconData getIcon(String? slug) {
    return switch (slug?.toLowerCase()) {
      'food' => Icons.restaurant_rounded,
      'cafe' => Icons.coffee_rounded,
      'salon' => Icons.content_cut_rounded,
      'spa' => Icons.spa_rounded,
      'theater' => Icons.movie_rounded,
      _ => Icons.local_offer_rounded,
    };
  }

  static String getEmoji(String? slug) {
    return switch (slug?.toLowerCase()) {
      'food' => '🍔',
      'cafe' => '☕',
      'salon' => '💈',
      'spa' => '🛁',
      'theater' => '🎭',
      _ => '🏪',
    };
  }
}
