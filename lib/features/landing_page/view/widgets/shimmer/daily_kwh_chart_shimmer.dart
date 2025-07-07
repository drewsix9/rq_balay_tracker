import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class DailyKwhChartShimmer extends StatelessWidget {
  const DailyKwhChartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.textMuted.withOpacity(0.1),
      child: Container(
        width:
            ResponsiveHelper.isTablet(context)
                ? MediaQuery.of(context).size.width * 0.95
                : ResponsiveHelper.getChartWidth(context),
        height:
            ResponsiveHelper.isTablet(context)
                ? MediaQuery.of(context).size.height * 0.6
                : ResponsiveHelper.getChartHeight(context),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context),
          ),
        ),
      ),
    );
  }
}
