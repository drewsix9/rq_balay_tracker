import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class CombinedChartCardShimmer extends StatelessWidget {
  const CombinedChartCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Container(
        padding: ResponsiveHelper.getCardPadding(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon and title
            Row(
              children: [
                // Icon container shimmer
                Container(
                  width:
                      ResponsiveHelper.getIconSize(context) +
                      ResponsiveHelper.getSpacing(context) * 0.5,
                  height:
                      ResponsiveHelper.getIconSize(context) +
                      ResponsiveHelper.getSpacing(context) * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.33),
                // Title shimmer
                Expanded(
                  child: Container(
                    height: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 16.0,
                      tablet7Size: 18.0,
                      tablet10Size: 20.0,
                      largeTabletSize: 22.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.67),
            // Chart area shimmer
            Container(
              width: double.infinity,
              height: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 200.0,
                tablet7Size: 250.0,
                tablet10Size: 300.0,
                largeTabletSize: 350.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
