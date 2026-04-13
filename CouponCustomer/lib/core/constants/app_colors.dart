// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

/// All brand colors for the CouponApp Customer App.
/// Never use raw Color values in widgets — always reference AppColors.
class AppColors {
  AppColors._();

  // --------------------- Batch - 1 ---------------------
  /*// Primary Brand
  static const Color primary       = Color(0xFF1C0A3E);
  static const Color primaryLight  = Color(0xFF2D1260);
  static const Color primaryAccent = Color(0xFF7C3AED);
  static const Color primarySoft   = Color(0xFFEDE9FE);

  // Backgrounds
  static const Color bgPage        = Color(0xFFF4F2EE);
  static const Color bgCard        = Color(0xFFFFFFFF);
  static const Color bgSecondary   = Color(0xFFF9F8F5);

  // Semantic
  static const Color success       = Color(0xFF4ADE80);
  static const Color successDark   = Color(0xFF16A34A);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color error         = Color(0xFFEF4444);
  static const Color errorLight    = Color(0xFFFEE2E2);
  static const Color info          = Color(0xFF3B82F6);

  // Text
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFF9CA3AF);
  static const Color textOnDark    = Color(0xFFFFFFFF);
  static const Color textMuted     = Color(0xFFA78BCA);

  // Border
  static const Color border        = Color(0xFFE0DDD6);
  static const Color borderStrong  = Color(0xFFD1CFC8);

  // Category (coupon card backgrounds)
  static const Color catFood       = Color(0xFF1C0A3E);
  static const Color catSalon      = Color(0xFF064E3B);
  static const Color catTheater    = Color(0xFF7C2D12);
  static const Color catSpa        = Color(0xFF1E3A5F);
  static const Color catCafe       = Color(0xFF3B1F6B);
  static const Color catDefault    = Color(0xFF374151);

  // --- Editorial Design System ---
  static const Color dsPrimary = Color(0xFF5D3FD3);
  static const Color dsPrimaryContainer = Color(0xFFA391FF);
  static const Color dsSecondaryMint = Color(0xFF006A35);
  static const Color dsTertiaryPink = Color(0xFF993C50);
  
  static const Color dsSurface = Color(0xFFFDF3FF);
  static const Color dsSurfaceContainerLow = Color(0xFFF9EDFF);
  static const Color dsSurfaceContainerHighest = Color(0xFFEBD4FF);
  static const Color dsSurfaceContainerLowest = Color(0xFFFFFFFF);
  
  static const Color dsOnSurface = Color(0xFF38274C);*/
  // -------------------------------

  // --------------------- Batch - 2 ---------------------
  // ─── Primary Brand (Ochre-Gold) ───────────────────────────────────────────
  static const Color primary = Color(0xFF775A00); // Primary gold
  static const Color primaryLight = Color(0xFFE6B325); // primary_container
  static const Color primaryAccent = Color(0xFFB58A00); // mid-tone gold accent
  static const Color primarySoft = Color(0xFFFFF8E1); // soft warm yellow tint

// ─── Backgrounds ──────────────────────────────────────────────────────────
  static const Color bgPage = Color(0xFFFCF9F8); // surface — warm paper white
  static const Color bgCard = Color(0xFFFFFFFF); // surface_container_lowest
  static const Color bgSecondary = Color(0xFFF5F0EC); // surface_container_low

// ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4ADE80);
  static const Color successDark = Color(0xFF16A34A);
  static const Color warning =
      Color(0xFFE6B325); // uses primaryLight for brand cohesion
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF006495); // tertiary — deep-sea blue

// ─── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary =
      Color(0xFF1B1C1C); // on_surface — never pure black
  static const Color textSecondary =
      Color(0xFF725A42); // secondary — chocolate charcoal
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnDark = Color(0xFFFFFFFF); // on_primary
  static const Color textMuted = Color(0xFFAD8A56); // warm muted gold-brown

// ─── Border (Ghost Border Rule — felt, not seen) ──────────────────────────
  static const Color border =
      Color(0x26775A00); // outline_variant @ 15% opacity
  static const Color borderStrong =
      Color(0x40775A00); // outline_variant @ 25% opacity

// ─── Category (coupon card backgrounds) ───────────────────────────────────
  static const Color catFood = Color(0xFF775A00); // primary gold
  static const Color catSalon = Color(0xFF725A42); // secondary brown
  static const Color catTheater = Color(0xFF006495); // tertiary deep-sea
  static const Color catSpa = Color(0xFF4A3800); // deep warm ochre
  static const Color catCafe = Color(0xFF8B6914); // mid amber
  static const Color catDefault = Color(0xFF5C4A30); // warm neutral dark

// ─── Editorial Design System (Gilded Gallery) ─────────────────────────────
  static const Color dsPrimary = Color(0xFF775A00); // primary
  static const Color dsPrimaryContainer =
      Color(0xFFE6B325); // primary_container
  static const Color dsSecondaryMint =
      Color(0xFF725A42); // secondary (chocolate)
  static const Color dsTertiaryPink =
      Color(0xFF006495); // tertiary (deep-sea blue)

  static const Color dsSurface = Color(0xFFFCF9F8); // surface
  static const Color dsSurfaceContainerLow =
      Color(0xFFF5F0EC); // surface_container_low
  static const Color dsSurfaceContainerHighest =
      Color(0xFFEADDCC); // surface_container_highest
  static const Color dsSurfaceContainerLowest =
      Color(0xFFFFFFFF); // surface_container_lowest

  static const Color dsOnSurface = Color(0xFF1B1C1C); // on_surface
  // -------------------------------

  /// Returns the card background color for a given category string.
  static Color forCategory(String category) {
    return switch (category.toLowerCase()) {
      'food' => catFood,
      'salon' => catSalon,
      'theater' => catTheater,
      'spa' => catSpa,
      'cafe' => catCafe,
      _ => catDefault,
    };
  }
}
