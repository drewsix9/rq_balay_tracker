import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/shimmer/today_kwh_chart_shimmer.dart';
import 'package:rq_balay_tracker/features/landing_page/viewmodel/landing_page_viewmodel.dart';

class TodayKwhConsumpChart extends StatelessWidget {
  final LandingPageViewModel provider;
  final double? dataPointSpacing; // New parameter for controlling spacing

  const TodayKwhConsumpChart({
    super.key,
    required this.provider,
    this.dataPointSpacing, // Optional parameter with default value
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (provider.isLoading) {
          return const TodayKwhChartShimmer();
        }

        if (provider.todayChartData.isEmpty) {
          return Container(
            width:
                ResponsiveHelper.isTablet(context)
                    ? MediaQuery.of(context).size.width *
                        0.95 // Use 95% of screen width on tablets
                    : ResponsiveHelper.getChartWidth(context),
            height:
                ResponsiveHelper.isTablet(context)
                    ? MediaQuery.of(context).size.height *
                        0.6 // Use 60% of screen height on tablets
                    : ResponsiveHelper.getChartHeight(context),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: -1,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart_outlined,
                    size: ResponsiveHelper.getIconSize(context),
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.33),
                  Text(
                    'No consumption data available',
                    style: AppTextStyles.muted.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 16.0,
                        tablet7Size: 18.0,
                        tablet10Size: 20.0,
                        largeTabletSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        double minValue = 0.0;
        double maxValue = 0.001;

        if (provider.todayChartData.isNotEmpty) {
          if (provider.todayChartData.length == 1) {
            // If only one data point, use it for both min and max
            minValue = provider.todayChartData.first.y;
            maxValue = provider.todayChartData.first.y;
          } else {
            // If multiple data points, use reduce to find min and max
            minValue = provider.todayChartData
                .map((spot) => spot.y)
                .reduce((a, b) => a < b ? a : b);
            maxValue = provider.todayChartData
                .map((spot) => spot.y)
                .reduce((a, b) => a > b ? a : b);
          }
        }

        // Add padding to min/max for better visualization
        double padding =
            (maxValue - minValue) * 0.15; // 15% padding for better spacing
        double chartMinY = (minValue - padding).clamp(0.0, double.infinity);
        double chartMaxY = maxValue + padding;

        // For very small values, ensure minimum range
        if (chartMaxY - chartMinY < 0.001) {
          chartMaxY = chartMinY + 0.001;
        }

        return Container(
          width:
              ResponsiveHelper.isTablet(context)
                  ? MediaQuery.of(context).size.width *
                      0.95 // Use 95% of screen width on tablets
                  : ResponsiveHelper.getChartWidth(context),
          height:
              ResponsiveHelper.isTablet(context)
                  ? MediaQuery.of(context).size.height *
                      0.6 // Use 60% of screen height on tablets
                  : ResponsiveHelper.getChartHeight(context),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
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
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: ResponsiveHelper.getSpacing(context) * 0.33,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width:
                      ResponsiveHelper.isTablet(context)
                          ? _calculateChartWidth(
                            context,
                          ) // Use calculated width for proper scrolling on tablets
                          : _calculateChartWidth(context),
                  child: Row(
                    children: [
                      // Side label for "Wh"
                      RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ResponsiveHelper.getSpacing(context) * 0.17,
                            top: ResponsiveHelper.getSpacing(context) * 0.17,
                          ),
                          child: Text(
                            'Wh',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                mobileSize: 12.0,
                                tablet7Size: 14.0,
                                tablet10Size: 16.0,
                                largeTabletSize: 18.0,
                              ),
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Chart
                      SizedBox(
                        width:
                            _calculateChartWidth(context) -
                            (ResponsiveHelper.isTablet(context)
                                ? 80.0.w
                                : 50.0.w), // Responsive space for y-axis label
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX:
                                provider.todayChartData.length > 1
                                    ? (provider.todayChartData.length - 1)
                                        .toDouble()
                                    : 1.0,
                            minY: chartMinY,
                            maxY: chartMaxY,
                            lineBarsData: [
                              LineChartBarData(
                                spots: provider.todayChartData,
                                isCurved: true,
                                curveSmoothness: 0.35,
                                preventCurveOverShooting: true,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2B6CB0),
                                    Color(0xFF4299E1),
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                                barWidth:
                                    ResponsiveHelper.isTablet(context)
                                        ? 4.0
                                        : 3.0,
                                belowBarData: BarAreaData(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF90CDF4),
                                      Color(0xFFBEE3F8),
                                    ],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  ).withOpacity(.5),
                                  show: true,
                                ),
                                dotData: FlDotData(
                                  checkToShowDot:
                                      (spot, barData) =>
                                          spot.y > 0 && spot.x > 0,
                                  show: true,
                                  getDotPainter: (
                                    spot,
                                    percent,
                                    barData,
                                    index,
                                  ) {
                                    return FlDotCirclePainter(
                                      radius:
                                          ResponsiveHelper.isTablet(context)
                                              ? 8.0.r
                                              : 4.0.r,
                                      color: AppColors.primaryBlue,
                                      strokeWidth: 1,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                shadow: const Shadow(
                                  blurRadius: 8,
                                  color: AppColors.shadow,
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchSpotThreshold: 20,
                              touchTooltipData: LineTouchTooltipData(
                                fitInsideVertically: true,
                                fitInsideHorizontally: true,
                                getTooltipColor:
                                    (touchedSpot) => AppColors.surface
                                        .withValues(alpha: 0.8),
                                getTooltipItems: (
                                  List<LineBarSpot> touchedSpots,
                                ) {
                                  return touchedSpots.map((spot) {
                                    int index = spot.x.toInt();
                                    String timeLabel = '';

                                    if (index >= 0 &&
                                        index <
                                            provider.todayTimeLabels.length) {
                                      timeLabel =
                                          provider.todayTimeLabels[index];
                                    }

                                    return LineTooltipItem(
                                      '⚡ ${(spot.y).toStringAsFixed(2)} Wh\n🕒 $timeLabel',
                                      AppTextStyles.body.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                        fontSize: ResponsiveHelper.getFontSize(
                                          context,
                                          mobileSize: 12.0,
                                          tablet7Size: 14.0,
                                          tablet10Size: 16.0,
                                          largeTabletSize: 18.0,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  maxIncluded: false,
                                  minIncluded: false,
                                  showTitles: true,
                                  reservedSize:
                                      ResponsiveHelper.isTablet(context)
                                          ? 50.0.w
                                          : 40.0.w,
                                  interval: (chartMaxY - chartMinY) / 4,
                                  getTitlesWidget:
                                      (value, meta) => Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              ResponsiveHelper.getSpacing(
                                                context,
                                              ) *
                                              0.33,
                                        ),
                                        child: Text(
                                          (value.toDouble()).toStringAsFixed(2),
                                          style: AppTextStyles.caption.copyWith(
                                            fontSize:
                                                ResponsiveHelper.getFontSize(
                                                  context,
                                                  mobileSize: 11.0,
                                                  tablet7Size: 12.0,
                                                  tablet10Size: 13.0,
                                                  largeTabletSize: 14.0,
                                                ),
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize:
                                      ResponsiveHelper.isTablet(context)
                                          ? 65.0.h
                                          : 30.0.h,
                                  interval: 1,
                                  maxIncluded: false,
                                  getTitlesWidget: (value, meta) {
                                    int idx = value.toInt();
                                    if (idx < 0 ||
                                        idx >=
                                            provider.todayTimeLabels.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            ResponsiveHelper.getSpacing(
                                              context,
                                            ) *
                                            0.33,
                                      ),
                                      child: Text(
                                        provider.todayTimeLabels[idx]
                                            .split(':')
                                            .take(2)
                                            .join(':'),
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 10.0,
                                                tablet7Size: 11.0,
                                                tablet10Size: 12.0,
                                                largeTabletSize: 13.0,
                                              ),
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: (chartMaxY - chartMinY) / 4,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: AppColors.textMuted.withValues(
                                    alpha: 0.3,
                                  ),
                                  strokeWidth:
                                      ResponsiveHelper.isTablet(context)
                                          ? 1.5
                                          : 1.0,
                                  dashArray: [5, 5],
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.5),
                                width:
                                    ResponsiveHelper.isTablet(context)
                                        ? 1.5
                                        : 1.0,
                              ),
                            ),
                            extraLinesData: ExtraLinesData(
                              horizontalLines:
                                  provider.yHourlyMaxKWh > 0.0
                                      ? [
                                        HorizontalLine(
                                          y: provider.yHourlyMaxKWh,
                                          color: AppColors.warning.withValues(
                                            alpha: 0.3,
                                          ),
                                          strokeWidth:
                                              ResponsiveHelper.isTablet(context)
                                                  ? 2.0
                                                  : 1.0,
                                          dashArray: [10, 5],
                                          label: HorizontalLineLabel(
                                            show: true,
                                            labelResolver:
                                                (line) =>
                                                    'High Usage @ ${provider.yHourlyMaxKWh.toStringAsFixed(2)} Wh',
                                            style: AppTextStyles.caption.copyWith(
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobileSize: 10.0,
                                                    tablet7Size: 11.0,
                                                    tablet10Size: 12.0,
                                                    largeTabletSize: 13.0,
                                                  ),
                                              color: AppColors.warning,
                                            ),
                                          ),
                                        ),
                                      ]
                                      : [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateChartWidth(BuildContext context) {
    // Much larger base width for tablets to make chart more prominent
    double baseWidth = ResponsiveHelper.isTablet(context) ? 3200.0.w : 1920.0.w;

    // If no data, return base width
    if (provider.todayChartData.isEmpty) {
      return baseWidth;
    }

    // Calculate width based on number of data points
    // Use much larger spacing for tablets to prevent data congestion
    double minWidthPerPoint =
        dataPointSpacing ??
        (ResponsiveHelper.isTablet(context)
            ? 300.0.w
            : 80.0.w); // Increased spacing for tablets
    double calculatedWidth = provider.todayChartData.length * minWidthPerPoint;

    // Add extra space for the y-axis label and padding - more space for tablets
    double yAxisSpace = ResponsiveHelper.isTablet(context) ? 120.0.w : 50.0.w;
    double totalWidth = calculatedWidth + yAxisSpace;

    // Ensure minimum width and much higher maximum width for tablets
    double minWidth = baseWidth;
    double maxWidth =
        ResponsiveHelper.isTablet(context)
            ? 10000.0.w
            : 4000.0.w; // Increased max width

    return totalWidth.clamp(minWidth, maxWidth);
  }
}
