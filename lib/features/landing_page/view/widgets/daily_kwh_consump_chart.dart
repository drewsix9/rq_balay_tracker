import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:rq_balay_tracker/features/landing_page/view/shimmer/daily_kwh_chart_shimmer.dart';
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
          return const DailyKwhChartShimmer();
        }

        if (widget.provider.dailyChartData.isEmpty ||
            widget.provider.dailyKWhConsumpList.dailyKwhConsump!.length <= 2) {
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
                    Icons.bar_chart_outlined,
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
                    width: ResponsiveHelper.isTablet(context) ? 20.0.w : 12.0.w,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }).toList();

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
              child: Row(
                children: [
                  // Side label for "kWh"
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
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
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
                              horizontal:
                                  ResponsiveHelper.getSpacing(context) * 0.67,
                              vertical:
                                  ResponsiveHelper.getSpacing(context) * 0.5,
                            ),
                            tooltipMargin:
                                ResponsiveHelper.getSpacing(context) * 0.33,
                            maxContentWidth:
                                ResponsiveHelper.isTablet(context)
                                    ? 300.0.w
                                    : 200.0.w,
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
                                '⚡ ${rod.toY.toStringAsFixed(2)} Wh\n📅 $timeLabel',
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
                                      ? 60.0.w
                                      : (widget.provider.yDailyMaxKWh > 10000
                                          ? 45.0.w
                                          : 35.0.w),
                              interval: (chartMaxY - chartMinY) / 4,
                              getTitlesWidget:
                                  (value, meta) => Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          ResponsiveHelper.getSpacing(context) *
                                          0.33,
                                    ),
                                    child: Text(
                                      '${value.toInt()}',
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: ResponsiveHelper.getFontSize(
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
                                  padding: EdgeInsets.only(
                                    top:
                                        ResponsiveHelper.getSpacing(context) *
                                        0.33,
                                  ),
                                  child: Text(
                                    widget.provider.dailyTimeLabels[idx],
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: ResponsiveHelper.getFontSize(
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
                              color: AppColors.textMuted.withValues(alpha: 0.3),
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
                                ResponsiveHelper.isTablet(context) ? 1.5 : 1.0,
                          ),
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines:
                              widget.provider.yDailyMaxKWh > 0.0
                                  ? [
                                    HorizontalLine(
                                      y: widget.provider.yDailyMaxKWh,
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
                                                'High Usage @ ${widget.provider.yDailyMaxKWh.toStringAsFixed(2)} Wh',
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
        );
      },
    );
  }
}
