import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoCardShimmer extends StatelessWidget {
  const UserInfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
      padding: ResponsiveHelper.getCardPadding(context),
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context) * 0.17,
        horizontal: 0,
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.textMuted.withValues(alpha: 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 120.0,
                tablet7Size: 150.0,
                tablet10Size: 180.0,
                largeTabletSize: 200.0,
              ),
              height: ResponsiveHelper.getHeadingFontSize(context),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * .7),
            // Unit info shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 80.0,
                tablet7Size: 100.0,
                tablet10Size: 120.0,
                largeTabletSize: 140.0,
              ),
              height: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 15.0,
                tablet7Size: 16.0,
                tablet10Size: 17.0,
                largeTabletSize: 18.0,
              ),
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.7),
            // Info rows shimmer
            Column(
              children: [
                // Monthly Rate row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label shimmer
                    Container(
                      width: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 100.0,
                        tablet7Size: 110.0,
                        tablet10Size: 120.0,
                        largeTabletSize: 130.0,
                      ),
                      height: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 15.0,
                        tablet7Size: 16.0,
                        tablet10Size: 17.0,
                        largeTabletSize: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Value shimmer
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
                        mobileSize: 16.0,
                        tablet7Size: 17.0,
                        tablet10Size: 18.0,
                        largeTabletSize: 19.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.7),
                // WiFi row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label shimmer
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
                        mobileSize: 15.0,
                        tablet7Size: 16.0,
                        tablet10Size: 17.0,
                        largeTabletSize: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Status badge shimmer
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
                        mobileSize: 25.0,
                        tablet7Size: 26.0,
                        tablet10Size: 27.0,
                        largeTabletSize: 28.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.7),
                // Mobile row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label shimmer
                    Container(
                      width: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 50.0,
                        tablet7Size: 55.0,
                        tablet10Size: 60.0,
                        largeTabletSize: 65.0,
                      ),
                      height: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 15.0,
                        tablet7Size: 16.0,
                        tablet10Size: 17.0,
                        largeTabletSize: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Value shimmer
                    Container(
                      width: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 100.0,
                        tablet7Size: 110.0,
                        tablet10Size: 120.0,
                        largeTabletSize: 130.0,
                      ),
                      height: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 16.0,
                        tablet7Size: 17.0,
                        tablet10Size: 18.0,
                        largeTabletSize: 19.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.7),
                // Start Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label shimmer
                    Container(
                      width: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 80.0,
                        tablet7Size: 85.0,
                        tablet10Size: 90.0,
                        largeTabletSize: 95.0,
                      ),
                      height: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 15.0,
                        tablet7Size: 16.0,
                        tablet10Size: 17.0,
                        largeTabletSize: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    // Value shimmer
                    Container(
                      width: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 90.0,
                        tablet7Size: 100.0,
                        tablet10Size: 110.0,
                        largeTabletSize: 120.0,
                      ),
                      height: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 16.0,
                        tablet7Size: 17.0,
                        tablet10Size: 18.0,
                        largeTabletSize: 19.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
