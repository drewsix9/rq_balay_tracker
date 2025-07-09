import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class RowToggleChartShimmer extends StatelessWidget {
  const RowToggleChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textMuted.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Toggle slider shimmer
          Container(
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.all(
              ResponsiveHelper.getSpacing(context) * 0.17,
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 40.0,
                    tablet7Size: 45.0,
                    tablet10Size: 50.0,
                    largeTabletSize: 55.0,
                  ),
                  height: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 18.0,
                    tablet7Size: 20.0,
                    tablet10Size: 22.0,
                    largeTabletSize: 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.17),
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 40.0,
                    tablet7Size: 45.0,
                    tablet10Size: 50.0,
                    largeTabletSize: 55.0,
                  ),
                  height: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 18.0,
                    tablet7Size: 20.0,
                    tablet10Size: 22.0,
                    largeTabletSize: 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
          // 'Wh Consumption' text shimmer
          Container(
            width: ResponsiveHelper.getFontSize(
              context,
              mobileSize: 120.0,
              tablet7Size: 140.0,
              tablet10Size: 160.0,
              largeTabletSize: 180.0,
            ),
            height: ResponsiveHelper.getHeadingFontSize(
              context,
              mobileSize: 18.0,
              tablet7Size: 20.0,
              tablet10Size: 22.0,
              largeTabletSize: 24.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
