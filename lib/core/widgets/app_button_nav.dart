// lib/core/widgets/bottom_nav_icon.dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const BottomNavIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.navActive : AppColors.navInactive,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.navActive : AppColors.navInactive,
          ),
        ),
      ],
    );
  }
}
