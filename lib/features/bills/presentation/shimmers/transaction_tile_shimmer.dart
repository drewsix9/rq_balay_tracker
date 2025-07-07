import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class TransactionTileShimmer extends StatelessWidget {
  const TransactionTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -1,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: ExpansionTile(
            childrenPadding: EdgeInsets.symmetric(horizontal: 16.w),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.navActive.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: AppColors.surface,
            collapsedIconColor: AppColors.textMuted,
            iconColor: AppColors.textMuted,
            collapsedTextColor: AppColors.textMuted,
            textColor: AppColors.textMuted,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Date shimmer
                Container(
                  width: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 120.0,
                    tablet7Size: 140.0,
                    tablet10Size: 160.0,
                    largeTabletSize: 180.0,
                  ),
                  height: 16.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Status badge shimmer
                Container(
                  width: 60.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Electricity row shimmer
                    _buildDetailRowShimmer(),
                    SizedBox(height: 12.h),
                    // Water row shimmer
                    _buildDetailRowShimmer(),
                    SizedBox(height: 12.h),
                    // WiFi row shimmer (conditional)
                    _buildDetailRowShimmer(),
                    SizedBox(height: 12.h),
                    // Rent row shimmer
                    _buildDetailRowShimmer(),
                    SizedBox(height: 12.h),
                    // Divider
                    Container(height: 1, color: AppColors.divider),
                    SizedBox(height: 12.h),
                    // Total Due row shimmer
                    _buildDetailRowShimmer(isTotal: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRowShimmer({bool isTotal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label shimmer
            Container(
              width: isTotal ? 80.w : 70.w,
              height: 16.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Amount shimmer
            Container(
              width: isTotal ? 100.w : 80.w,
              height: 16.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rate shimmer
            Container(
              width: 60.w,
              height: 12.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Consumption shimmer
            Container(
              width: 50.w,
              height: 12.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
