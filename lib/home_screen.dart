import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'core/theme/app_colors.dart';
import 'core/utils/responsive_helper.dart';
import 'features/bills/presentation/bills_screen.dart';
import 'features/charts/view/charts_screen.dart';
import 'features/landing_page/view/landing_page_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

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
          item: ItemConfig(
            icon: Icon(Icons.home, size: ResponsiveHelper.getIconSize(context)),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: BillsScreen(),
          item: ItemConfig(
            icon: Icon(
              Icons.receipt_long,
              size: ResponsiveHelper.getIconSize(context),
            ),
            title: "Bills",
          ),
        ),
        PersistentTabConfig(
          screen: ChartsScreen(),
          item: ItemConfig(
            icon: Icon(
              Icons.bar_chart,
              size: ResponsiveHelper.getIconSize(context),
            ),
            title: "Charts",
          ),
        ),
        // PersistentTabConfig(
        //   screen: NotificationTestWidget(),
        //   item: ItemConfig(
        //     icon: Icon(Icons.notifications),
        //     title: "Notifications",
        //   ),
        // ),
        PersistentTabConfig(
          screen: ProfileScreen(),
          item: ItemConfig(
            icon: Icon(
              Icons.person,
              size: ResponsiveHelper.getIconSize(context),
            ),
            title: "Profile",
          ),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => Style6BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.getSpacing(context) * 0.5,
              ),
              color: AppColors.background,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
          ),
    );
  }
}
