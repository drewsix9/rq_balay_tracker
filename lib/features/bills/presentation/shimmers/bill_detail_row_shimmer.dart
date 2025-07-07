import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class BillDetailRowShimmer extends StatelessWidget {
  const BillDetailRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.getSpacing(context) * 0.25,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Label shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 60,
                tablet7Size: 70,
                tablet10Size: 80,
                largeTabletSize: 90,
              ),
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Amount shimmer
            Container(
              width: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 50,
                tablet7Size: 60,
                tablet10Size: 70,
                largeTabletSize: 80,
              ),
              height: 16,
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
