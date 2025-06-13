import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  static const warningGradient = LinearGradient(
    colors: [Color(0xFFF6B93B), Color(0xFFE67E22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const primaryBlueGradient = LinearGradient(
    colors: [AppColors.primaryBlue, Color(0xFF1E88E5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
