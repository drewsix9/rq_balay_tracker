import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_helper.dart';
import 'transaction_tile_shimmer.dart';

class TransactionListShimmer extends StatelessWidget {
  const TransactionListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getFontSize(
        context,
        mobileSize: 400.0,
        tablet7Size: 500.0,
        tablet10Size: 600.0,
        largeTabletSize: 700.0,
      ),
      child: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const TransactionTileShimmer(),
      ),
    );
  }
}
