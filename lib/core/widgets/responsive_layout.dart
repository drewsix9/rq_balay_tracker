import 'package:flutter/material.dart';

import '../utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool useTabletLayout;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.useTabletLayout = true,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (!useTabletLayout || ResponsiveHelper.isMobile(context)) {
      return child;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveHelper.getMaxWidth(context),
        ),
        child: Padding(
          padding: padding ?? ResponsiveHelper.getScreenPadding(context),
          child: child,
        ),
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
        crossAxisSpacing:
            crossAxisSpacing ?? ResponsiveHelper.getSpacing(context) * 0.5,
        mainAxisSpacing:
            mainAxisSpacing ?? ResponsiveHelper.getSpacing(context) * 0.5,
        childAspectRatio:
            childAspectRatio ??
            ResponsiveHelper.getGridChildAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(
          borderRadius ?? ResponsiveHelper.getBorderRadius(context),
        ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ],
      ),
      child: child,
    );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        children:
            children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    SizedBox(
                      height:
                          spacing ?? ResponsiveHelper.getSpacing(context) * 0.5,
                    ),
                ],
              );
            }).toList(),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children:
          children.asMap().entries.map((entry) {
            final index = entry.key;
            final child = entry.value;
            return Row(
              children: [
                Expanded(child: child),
                if (index < children.length - 1)
                  SizedBox(
                    width:
                        spacing ?? ResponsiveHelper.getSpacing(context) * 0.5,
                  ),
              ],
            );
          }).toList(),
    );
  }
}

class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? spacing;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children:
          children.asMap().entries.map((entry) {
            final index = entry.key;
            final child = entry.value;
            return Column(
              children: [
                child,
                if (index < children.length - 1)
                  SizedBox(
                    height:
                        spacing ?? ResponsiveHelper.getSpacing(context) * 0.5,
                  ),
              ],
            );
          }).toList(),
    );
  }
}
