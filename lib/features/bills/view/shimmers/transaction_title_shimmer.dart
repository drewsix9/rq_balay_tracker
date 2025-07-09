import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class TransactionTitleShimmer extends StatelessWidget {
  const TransactionTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[300]!,
      child: Container(
        width: ResponsiveHelper.getFontSize(
          context,
          mobileSize: 180.0,
          tablet7Size: 200.0,
          tablet10Size: 220.0,
          largeTabletSize: 240.0,
        ),
        height: ResponsiveHelper.getHeadingFontSize(
          context,
          mobileSize: 18.0,
          tablet7Size: 20.0,
          tablet10Size: 22.0,
          largeTabletSize: 24.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
