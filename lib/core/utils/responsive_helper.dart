import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static double getPadding(BuildContext context) {
    return isSmallScreen(context) ? 16.0 : 32.0;
  }

  static double getSpacing(BuildContext context) {
    return isSmallScreen(context) ? 24.0 : 32.0;
  }

  static double getMaxWidth(BuildContext context) {
    return isSmallScreen(context) ? MediaQuery.of(context).size.width : 400.0;
  }

  static double getFontSize(
    BuildContext context, {
    double smallSize = 12.0,
    double largeSize = 14.0,
  }) {
    return isSmallScreen(context) ? smallSize : largeSize;
  }

  static double getHeadingFontSize(
    BuildContext context, {
    double smallSize = 16.0,
    double largeSize = 20.0,
  }) {
    return isSmallScreen(context) ? smallSize : largeSize;
  }

  static double getCardPaddingValue(BuildContext context) {
    return isSmallScreen(context) ? 16.0 : 24.0;
  }

  static double getIconSize(BuildContext context) {
    return isSmallScreen(context) ? 16.0 : 24.0;
  }

  static double getButtonHeight(BuildContext context) {
    return isSmallScreen(context) ? 38.0 : 48.0;
  }

  static double getButtonWidth(BuildContext context) {
    return isSmallScreen(context) ? 120.0 : 200.0;
  }

  static double getBorderRadius(BuildContext context) {
    return isSmallScreen(context) ? 8.0 : 12.0;
  }

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
}
