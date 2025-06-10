import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'features/bills/presentation/bills_screen.dart';
import 'features/charts/presentation/charts_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: BillsScreen(),
          item: ItemConfig(icon: Icon(Icons.receipt_long), title: "Bills"),
        ),
        PersistentTabConfig(
          screen: ChartsScreen(),
          item: ItemConfig(icon: Icon(Icons.bar_chart), title: "Charts"),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => Style6BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
          ),
    );
  }
}
