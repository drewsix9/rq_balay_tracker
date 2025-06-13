import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (keeping existing blue)
  static const primaryBlue = Color(0xFF1E7DEA);

  // Background Colors
  static const background = Color(0xFFF7FAFC); // bg-gray-100
  static const surface = Color(0xFFFFFFFF); // bg-white

  // Text Colors
  static const textPrimary = Color(0xFF1F2937); // text-gray-800
  static const textSecondary = Color(0xFF4B5563); // text-gray-700
  static const textMuted = Color(0xFF6B7280); // text-gray-500
  static const textLight = Color(0xFF9CA3AF); // text-gray-400

  // Input Colors
  static const inputBackground = Color(0xFFFFFFFF); // bg-gray-100

  // Navigation Colors
  static const navActive = Color(0xFF1F2937); // text-gray-800
  static const navInactive = Color(0xFF9CA3AF); // text-gray-400

  // Status Colors
  static const success = Color(0xFF4CAF50); // keeping existing success color
  static const warning = Color(0xFFF59E0B); // text-yellow-800
  static const warningLight = Color(0xFFFEF3C7); // bg-yellow-400

  // Border Colors
  static const border = Color(0xFFE5E7EB); // border-gray-200
  static const divider = Color(0xFFE5E7EB); // border-gray-200

  // Shadow Colors
  static const shadow = Color(0x1A000000); // shadow with 10% opacity
}

class AppGradients {
  static const primaryBlueGradient = LinearGradient(
    colors: [Color(0xFF1E7DEA), Color(0xFF64B6FF)],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static const bluePurpleGradient = LinearGradient(
    colors: [
      Color(0xFF1E7DEA), // AppColors.primaryBlue
      Color(0xFF7F53AC), // Soft purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const softGrayGradient = LinearGradient(
    colors: [
      Color(0xFFF7FAFC), // AppColors.background
      Color(0xFFE5E7EB), // AppColors.divider
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const successGradient = LinearGradient(
    colors: [
      Color(0xFF4CAF50), // AppColors.success
      Color(0xFF81C784), // Lighter green
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warningGradient = LinearGradient(
    colors: [
      Color(0xFFF59E0B), // AppColors.warning
      Color(0xFFFFE082), // Soft yellow
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static const electricityGradient = LinearGradient(
    colors: [
      Color(0xFF2B6CB0), // Deep blue
      Color(0xFF4299E1), // Electric blue
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
  static const electricityGradientPastel = LinearGradient(
    colors: [
      Color(0xFF90CDF4), // Pastel blue
      Color(0xFFBEE3F8), // Lighter pastel blue
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
}
