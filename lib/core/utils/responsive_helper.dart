import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveHelper {
  // Screen size breakpoints
  static const double _mobileBreakpoint = 600;
  static const double _tablet7InchBreakpoint = 800;
  static const double _tablet10InchBreakpoint = 1200;

  // Device type detection
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  static bool isTablet7Inch(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _mobileBreakpoint && width < _tablet7InchBreakpoint;
  }

  static bool isTablet10Inch(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _tablet7InchBreakpoint && width < _tablet10InchBreakpoint;
  }

  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tablet10InchBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    return isTablet7Inch(context) ||
        isTablet10Inch(context) ||
        isLargeTablet(context);
  }

  // Legacy method for backward compatibility
  static bool isSmallScreen(BuildContext context) {
    return isMobile(context);
  }

  // Responsive padding values
  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 16.0.w;
    if (isTablet7Inch(context)) return 24.0.w;
    if (isTablet10Inch(context)) return 32.0.w;
    return 40.0.w; // Large tablet
  }

  static double getSpacing(BuildContext context) {
    if (isMobile(context)) return 24.0.h;
    if (isTablet7Inch(context)) return 32.0.h;
    if (isTablet10Inch(context)) return 40.0.h;
    return 48.0.h; // Large tablet
  }

  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.of(context).size.width;
    if (isTablet7Inch(context)) return 600.0.w;
    if (isTablet10Inch(context)) return 800.0.w;
    return 1000.0.w; // Large tablet
  }

  // Responsive font sizes
  static double getFontSize(
    BuildContext context, {
    double mobileSize = 12.0,
    double tablet7Size = 14.0,
    double tablet10Size = 16.0,
    double largeTabletSize = 18.0,
  }) {
    if (isMobile(context)) return mobileSize.sp;
    if (isTablet7Inch(context)) return tablet7Size.sp;
    if (isTablet10Inch(context)) return tablet10Size.sp;
    return largeTabletSize.sp;
  }

  static double getHeadingFontSize(
    BuildContext context, {
    double mobileSize = 16.0,
    double tablet7Size = 20.0,
    double tablet10Size = 24.0,
    double largeTabletSize = 28.0,
  }) {
    if (isMobile(context)) return mobileSize.sp;
    if (isTablet7Inch(context)) return tablet7Size.sp;
    if (isTablet10Inch(context)) return tablet10Size.sp;
    return largeTabletSize.sp;
  }

  static double getCardPaddingValue(BuildContext context) {
    if (isMobile(context)) return 16.0.w;
    if (isTablet7Inch(context)) return 20.0.w;
    if (isTablet10Inch(context)) return 24.0.w;
    return 32.0.w; // Large tablet
  }

  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 16.0.w;
    if (isTablet7Inch(context)) return 20.0.w;
    if (isTablet10Inch(context)) return 24.0.w;
    return 28.0.w; // Large tablet
  }

  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 38.0.h;
    if (isTablet7Inch(context)) return 44.0.h;
    if (isTablet10Inch(context)) return 48.0.h;
    return 52.0.h; // Large tablet
  }

  static double getButtonWidth(BuildContext context) {
    if (isMobile(context)) return 120.0.w;
    if (isTablet7Inch(context)) return 160.0.w;
    if (isTablet10Inch(context)) return 200.0.w;
    return 240.0.w; // Large tablet
  }

  static double getBorderRadius(BuildContext context) {
    if (isMobile(context)) return 8.0.r;
    if (isTablet7Inch(context)) return 10.0.r;
    if (isTablet10Inch(context)) return 12.0.r;
    return 16.0.r; // Large tablet
  }

  // Responsive edge insets
  static EdgeInsets getScreenPadding(BuildContext context) {
    final padding = getPadding(context);
    return EdgeInsets.all(padding);
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final padding = getPadding(context);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    final padding = getPadding(context);
    return EdgeInsets.symmetric(vertical: padding);
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    final padding = getCardPaddingValue(context);
    return EdgeInsets.all(padding);
  }

  // Grid layout helpers for tablets
  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet7Inch(context)) return 2;
    if (isTablet10Inch(context)) return 3;
    return 4; // Large tablet
  }

  static double getGridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.0;
    if (isTablet7Inch(context)) return 1.2;
    if (isTablet10Inch(context)) return 1.4;
    return 1.6; // Large tablet
  }

  // Chart dimensions for tablets
  static double getChartHeight(BuildContext context) {
    if (isMobile(context)) return 200.0.h;
    if (isTablet7Inch(context)) {
      return 500.0.h; // Increased from 400.0.h for 7-inch tablets
    }
    if (isTablet10Inch(context)) {
      return 600.0.h; // Increased from 500.0.h for 10-inch tablets
    }
    return 700.0.h; // Increased from 600.0.h for large tablets
  }

  static double getChartWidth(BuildContext context) {
    if (isMobile(context)) return MediaQuery.of(context).size.width - 32.0.w;
    if (isTablet7Inch(context)) return 500.0.w;
    if (isTablet10Inch(context)) return 600.0.w;
    return 700.0.w; // Large tablet
  }

  // List item dimensions
  static double getListItemHeight(BuildContext context) {
    if (isMobile(context)) return 80.0.h;
    if (isTablet7Inch(context)) return 100.0.h;
    if (isTablet10Inch(context)) return 120.0.h;
    return 140.0.h; // Large tablet
  }

  // App bar height
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) return kToolbarHeight;
    if (isTablet7Inch(context)) return kToolbarHeight + 8.0.h;
    if (isTablet10Inch(context)) return kToolbarHeight + 12.0.h;
    return kToolbarHeight + 16.0.h; // Large tablet
  }

  // Bottom navigation bar height
  static double getBottomNavHeight(BuildContext context) {
    if (isMobile(context)) return kBottomNavigationBarHeight;
    if (isTablet7Inch(context)) return kBottomNavigationBarHeight + 8.0.h;
    if (isTablet10Inch(context)) return kBottomNavigationBarHeight + 12.0.h;
    return kBottomNavigationBarHeight + 16.0.h; // Large tablet
  }
}
