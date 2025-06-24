import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/features/landing_page/viewmodel/landing_page_viewmodel.dart';

class TodayKwhConsumpChart extends StatelessWidget {
  final LandingPageViewModel provider;

  const TodayKwhConsumpChart({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (provider.isLoading) {
          return Container(
            width: 350.w,
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        if (provider.todayChartData.isEmpty) {
          return Container(
            width: 1920.w,
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [AppColors.background, AppColors.divider],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart_outlined,
                    size: 48.sp,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'No consumption data available',
                    style: AppTextStyles.muted.copyWith(fontSize: 16.sp),
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
          width: 1920.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
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
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: _calculateChartWidth(),
                  child: Row(
                    children: [
                      // Side label for "Wh"
                      RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 4.h),
                          child: Text(
                            'Wh',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Chart
                      Expanded(
                        child: LineChart(
                          LineChartData(
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
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF90CDF4),
                                      Color(0xFFBEE3F8),
                                    ],
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                  ),
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
                                      radius: 4.r,
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
                                  reservedSize: 35.w,
                                  interval: (chartMaxY - chartMinY) / 4,
                                  getTitlesWidget:
                                      (value, meta) => Padding(
                                        padding: EdgeInsets.only(right: 8.w),
                                        child: Text(
                                          (value.toDouble()).toStringAsFixed(2),
                                          style: AppTextStyles.caption.copyWith(
                                            fontSize: 11.sp,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30.h,
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
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Text(
                                        provider.todayTimeLabels[idx]
                                            .split(':')
                                            .take(2)
                                            .join(':'),
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 10.sp,
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
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                              border: Border.all(
                                color: AppColors.border.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            extraLinesData: ExtraLinesData(
                              horizontalLines: [
                                HorizontalLine(
                                  y: provider.yHourlyMaxKWh,
                                  color: AppColors.warning.withValues(
                                    alpha: 0.3,
                                  ),
                                  strokeWidth: 1,
                                  dashArray: [10, 5],
                                  label: HorizontalLineLabel(
                                    show: true,
                                    labelResolver: (line) => 'High Usage',
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 10.sp,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ),
                              ],
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

  double _calculateChartWidth() {
    // Base width for the container
    double baseWidth = 1920.w;

    // If no data, return base width
    if (provider.todayChartData.isEmpty) {
      return baseWidth;
    }

    // Calculate width based on number of data points
    // Each data point needs minimum 60 pixels for proper spacing
    double minWidthPerPoint = 60.w;
    double calculatedWidth = provider.todayChartData.length * minWidthPerPoint;

    // Add extra space for the y-axis label and padding
    double totalWidth = calculatedWidth + 50.w;

    // Ensure minimum width and maximum reasonable width
    double minWidth = baseWidth;
    double maxWidth = 3000.w; // Maximum reasonable width

    return totalWidth.clamp(minWidth, maxWidth);
  }
}
