import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const body = TextStyle(fontSize: 14, color: AppColors.textDark);

  static const muted = TextStyle(fontSize: 14, color: AppColors.textMuted);

  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
