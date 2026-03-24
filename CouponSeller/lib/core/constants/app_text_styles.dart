import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heading1  => GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w600);
  static TextStyle get heading2  => GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle get heading3  => GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle get body      => GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static TextStyle get label     => GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5);
  static TextStyle get buttonText=> GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle get discountBig => GoogleFonts.plusJakartaSans(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textOnDark);
}
