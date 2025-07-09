import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class BillCardShimmer extends StatelessWidget {
  const BillCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getPadding(context),
          vertical: ResponsiveHelper.getSpacing(context) * 0.25,
        ),
        child: Container(
          width: double.infinity,
          height: ResponsiveHelper.getFontSize(
            context,
            mobileSize: 200.0,
            tablet7Size: 240.0,
            tablet10Size: 280.0,
            largeTabletSize: 320.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 6,
                spreadRadius: -1,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: Padding(
            padding: ResponsiveHelper.getCardPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 120.0,
                    tablet7Size: 140.0,
                    tablet10Size: 160.0,
                    largeTabletSize: 180.0,
                  ),
                  height: 20.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                // Amount shimmer
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 140.0,
                    tablet7Size: 160.0,
                    tablet10Size: 180.0,
                    largeTabletSize: 200.0,
                  ),
                  height: 28.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                // Button shimmer
                Container(
                  width: ResponsiveHelper.isTablet(context) ? 160.0.w : 100.0.w,
                  height: ResponsiveHelper.isTablet(context) ? 48.0.h : 32.0.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
