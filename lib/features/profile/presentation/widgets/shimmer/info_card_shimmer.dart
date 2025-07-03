import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';

class InfoCardShimmer extends StatelessWidget {
  final String title;
  final IconData icon;
  final int numberOfRows;

  const InfoCardShimmer({
    super.key,
    required this.title,
    required this.icon,
    this.numberOfRows = 2,
  });

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
                  child: Icon(icon, size: 20.sp, color: AppColors.primaryBlue),
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

            // Info rows
            ...List.generate(numberOfRows, (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - icon and label
                      Row(
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
                              mobileSize: 100.0,
                              tablet7Size: 120.0,
                              tablet10Size: 140.0,
                              largeTabletSize: 160.0,
                            ),
                            height: ResponsiveHelper.getFontSize(
                              context,
                              mobileSize: 15.0,
                              tablet7Size: 16.0,
                              tablet10Size: 17.0,
                              largeTabletSize: 18.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),

                      // Right side - value
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
                  if (index < numberOfRows - 1) SizedBox(height: 16.h),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
