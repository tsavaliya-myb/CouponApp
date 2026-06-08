// lib/core/utils/category_utils.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
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
      _ => AppColors.catDefault,
    };
  }

  static (Color, Color) getCategoryColors(CategoryItem? category) {
    final baseColor = getBaseColor(category);
    return (baseColor.withOpacity(0.15), baseColor);
  }

  static IconData getIcon(CategoryItem? category) {
    // We expect the iconName to be stored in the DB, e.g., 'restaurant_rounded'
    // For now we map some common names, or fallback to slug mapping if missing
    if (category?.iconName != null && category!.iconName!.isNotEmpty) {
      switch (category.iconName) {
        case 'restaurant_rounded': return Icons.restaurant_rounded;
        case 'coffee_rounded': return Icons.coffee_rounded;
        case 'content_cut_rounded': return Icons.content_cut_rounded;
        case 'spa_rounded': return Icons.spa_rounded;
        case 'movie_rounded': return Icons.movie_rounded;
        case 'shopping_bag_rounded': return Icons.shopping_bag_rounded;
        case 'fitness_center_rounded': return Icons.fitness_center_rounded;
        case 'local_hospital_rounded': return Icons.local_hospital_rounded;
        case 'fastfood_rounded': return Icons.fastfood_rounded;
        case 'local_pizza_rounded': return Icons.local_pizza_rounded;
        case 'icecream_rounded': return Icons.icecream_rounded;
        case 'local_bar_rounded': return Icons.local_bar_rounded;
        case 'local_cafe_rounded': return Icons.local_cafe_rounded;
        case 'storefront_rounded': return Icons.storefront_rounded;
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
