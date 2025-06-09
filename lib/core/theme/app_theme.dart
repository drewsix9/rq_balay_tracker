// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: AppTextStyles.subheading.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppColors.success,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        shadowColor: AppColors.shadow,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading.copyWith(
          color: AppColors.textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: AppTextStyles.subheading.copyWith(
          color: AppColors.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: AppTextStyles.subheading.copyWith(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: AppTextStyles.body.copyWith(
          color: AppColors.textPrimary,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: AppTextStyles.buttonText.copyWith(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        bodySmall: AppTextStyles.caption.copyWith(
          color: AppColors.textMuted,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.shadow,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: AppTextStyles.buttonText.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 20.h,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textMuted, size: 24),
    );
  }
}
