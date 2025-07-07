import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class SummaryCardShimmer extends StatelessWidget {
  const SummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 80.0,
                tablet7Size: 90.0,
                tablet10Size: 100.0,
                largeTabletSize: 110.0,
              ),
              height: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 14.0,
                tablet7Size: 15.0,
                tablet10Size: 16.0,
                largeTabletSize: 17.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.33),
            // Value and icon row shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon shimmer
                Container(
                  width: ResponsiveHelper.getIconSize(context),
                  height: ResponsiveHelper.getIconSize(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.17),
                // Value shimmer
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 60.0,
                    tablet7Size: 70.0,
                    tablet10Size: 80.0,
                    largeTabletSize: 90.0,
                  ),
                  height: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 24.0,
                    tablet7Size: 26.0,
                    tablet10Size: 28.0,
                    largeTabletSize: 30.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.17),
            // Trend text shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 70.0,
                tablet7Size: 80.0,
                tablet10Size: 90.0,
                largeTabletSize: 100.0,
              ),
              height: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 12.0,
                tablet7Size: 13.0,
                tablet10Size: 14.0,
                largeTabletSize: 15.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
