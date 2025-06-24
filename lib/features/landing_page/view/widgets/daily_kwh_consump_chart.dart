import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/features/landing_page/viewmodel/landing_page_viewmodel.dart';

class DailyKwhConsumpChart extends StatefulWidget {
  final LandingPageViewModel provider;

  const DailyKwhConsumpChart({super.key, required this.provider});

  @override
  State<DailyKwhConsumpChart> createState() => _DailyKwhConsumpChartState();
}

class _DailyKwhConsumpChartState extends State<DailyKwhConsumpChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (widget.provider.isLoading) {
          return Container(
            width: 350.w,
            height: 300.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        }

        if (widget.provider.dailyChartData.isEmpty) {
          return Container(
            width: 1920.w,
            height: 300.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_outlined,
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

        double minValue =
            widget.provider.dailyChartData.isEmpty
                ? 0.0
                : widget.provider.dailyChartData
                    .map((spot) => spot.y)
                    .reduce((a, b) => a < b ? a : b);
        double maxValue =
            widget.provider.dailyChartData.isEmpty
                ? 0.001
                : widget.provider.dailyChartData
                    .map((spot) => spot.y)
                    .reduce((a, b) => a > b ? a : b);

        // Add padding to min/max for better visualization
        double padding =
            (maxValue - minValue) * 0.15; // 15% padding for better spacing
        double chartMinY = (minValue - padding).clamp(0.0, double.infinity);
        double chartMaxY = maxValue + padding;

        // For very small values, ensure minimum range
        if (chartMaxY - chartMinY < 0.001) {
          chartMaxY = chartMinY + 0.001;
        }

        // Convert FlSpot data to BarChartGroupData
        List<BarChartGroupData> barGroups =
            widget.provider.dailyChartData.asMap().entries.map((entry) {
              int index = entry.key;
              FlSpot spot = entry.value;
              bool isTouched = touchedIndex == index;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: spot.y,
                    gradient:
                        isTouched
                            ? AppGradients.primaryBlueGradient
                            : const LinearGradient(
                              colors: [Color(0xFF90CDF4), Color(0xFFBEE3F8)],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                            ),
                    width: 12.w,
                    borderRadius: BorderRadius.zero,
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: chartMaxY,
                      color: AppColors.border.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              );
            }).toList();

        return Container(
          width: 1920.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
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
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  // Side label for "kWh"
                  RotatedBox(
                    quarterTurns: 3,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.h, top: 4.h),
                      child: Text(
                        'kWh',
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
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        minY: chartMinY,
                        maxY: chartMaxY,
                        barGroups: barGroups,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchCallback: (
                            FlTouchEvent event,
                            BarTouchResponse? response,
                          ) {
                            setState(() {
                              if (response?.spot != null &&
                                  event.isInterestedForInteractions) {
                                touchedIndex =
                                    response!.spot!.touchedBarGroupIndex;
                              } else {
                                touchedIndex = null;
                              }
                            });
                          },
                          touchTooltipData: BarTouchTooltipData(
                            fitInsideVertically: true,
                            fitInsideHorizontally: true,
                            tooltipPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            tooltipMargin: 8.h,
                            maxContentWidth: 200.w,
                            getTooltipColor:
                                (touchedSpot) =>
                                    AppColors.surface.withValues(alpha: 0.8),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              int index = group.x;
                              String timeLabel = '';

                              if (index >= 0 &&
                                  index <
                                      widget.provider.dailyTimeLabels.length) {
                                timeLabel =
                                    widget.provider.dailyTimeLabels[index];
                              }

                              return BarTooltipItem(
                                '⚡ ${rod.toY.toStringAsFixed(2)} kWh\n📅 $timeLabel',
                                AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              maxIncluded: false,
                              minIncluded: false,
                              showTitles: true,
                              reservedSize: 25.w,
                              interval: (chartMaxY - chartMinY) / 4,
                              getTitlesWidget:
                                  (value, meta) => Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: Text(
                                      '${value.toInt()}',
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
                              showTitles: false,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                int idx = value.toInt();
                                if (idx < 0 ||
                                    idx >=
                                        widget
                                            .provider
                                            .dailyTimeLabels
                                            .length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    widget.provider.dailyTimeLabels[idx],
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
                              color: AppColors.border.withValues(alpha: 0.3),
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
                              y: widget.provider.yDailyMaxKWh,
                              color: AppColors.warning.withValues(alpha: 0.3),
                              strokeWidth: 1,
                              dashArray: [10, 5],
                              label: HorizontalLineLabel(
                                show: true,
                                labelResolver:
                                    (line) =>
                                        'High Usage @ ${widget.provider.yDailyMaxKWh.toStringAsFixed(2)} kWh',
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
        );
      },
    );
  }
}
