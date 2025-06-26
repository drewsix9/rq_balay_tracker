import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'core/widgets/firebase_functions_test_widget.dart';
import 'core/widgets/notification_test_widget.dart';
import 'features/bills/presentation/bills_screen.dart';
import 'features/charts/view/charts_screen.dart';
import 'features/landing_page/view/landing_page_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: LandingPageScreen(),
          item: ItemConfig(icon: Icon(Icons.home), title: "Home"),
        ),
        PersistentTabConfig(
          screen: BillsScreen(),
          item: ItemConfig(icon: Icon(Icons.receipt_long), title: "Bills"),
        ),
        PersistentTabConfig(
          screen: ChartsScreen(),
          item: ItemConfig(icon: Icon(Icons.bar_chart), title: "Charts"),
        ),
        PersistentTabConfig(
          screen: NotificationTestWidget(),
          item: ItemConfig(
            icon: Icon(Icons.notifications),
            title: "Notifications",
          ),
        ),
        PersistentTabConfig(
          screen: FirebaseFunctionsTestWidget(),
          item: ItemConfig(icon: Icon(Icons.functions), title: "Functions"),
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
