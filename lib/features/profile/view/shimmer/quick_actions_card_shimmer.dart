import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class QuickActionsCardShimmer extends StatelessWidget {
  const QuickActionsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon and title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.settings,
                    size: 20.sp,
                    color: AppColors.primaryBlue,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 120.0,
                    tablet7Size: 140.0,
                    tablet10Size: 160.0,
                    largeTabletSize: 180.0,
                  ),
                  height: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 18.0,
                    tablet7Size: 19.0,
                    tablet10Size: 20.0,
                    largeTabletSize: 21.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Action buttons row
            Row(
              children: [
                // Edit Profile button shimmer
                Expanded(
                  child: Container(
                    height: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 48.0,
                      tablet7Size: 52.0,
                      tablet10Size: 56.0,
                      largeTabletSize: 60.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Logout button shimmer
                Expanded(
                  child: Container(
                    height: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 48.0,
                      tablet7Size: 52.0,
                      tablet10Size: 56.0,
                      largeTabletSize: 60.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
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
                            mobileSize: 16.0,
                            tablet7Size: 17.0,
                            tablet10Size: 18.0,
                            largeTabletSize: 19.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
