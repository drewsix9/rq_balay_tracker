import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class ProfileHeaderCardShimmer extends StatelessWidget {
  const ProfileHeaderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primaryBlueGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.w),
      margin: EdgeInsets.only(bottom: 20.h),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.3),
        highlightColor: Colors.white.withValues(alpha: 0.6),
        child: Column(
          children: [
            // Enhanced Avatar - matches exact structure
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Container(
                  width: 100.w, // Match the actual avatar size
                  height: 100.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // User Name shimmer - matches exact text style dimensions
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
                mobileSize: 28.0,
                tablet7Size: 30.0,
                tablet10Size: 32.0,
                largeTabletSize: 34.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 8.h),

            // Unit Badge shimmer - matches exact structure
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    width: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 70.0,
                      tablet7Size: 85.0,
                      tablet10Size: 100.0,
                      largeTabletSize: 115.0,
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
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
