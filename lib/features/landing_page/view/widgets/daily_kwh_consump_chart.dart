import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/features/landing_page/viewmodel/landing_page_viewmodel.dart';

class DailyKwhConsumpChart extends StatelessWidget {
  final LandingPageViewModel provider;

  const DailyKwhConsumpChart({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Builder(
        builder: (context) {
          if (provider.isLoading) {
            return SizedBox(
              width: 350.w,
              height: 300.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (provider.dailyChartData.isEmpty) {
            return SizedBox(
              width: 1920.w,
              height: 300.h,
              child: Center(child: Text('No consumption data available')),
            );
          }

          double minValue =
              provider.dailyChartData.isEmpty
                  ? 0.0
                  : provider.dailyChartData
                      .map((spot) => spot.y)
                      .reduce((a, b) => a < b ? a : b);
          double maxValue =
              provider.dailyChartData.isEmpty
                  ? 0.001
                  : provider.dailyChartData
                      .map((spot) => spot.y)
                      .reduce((a, b) => a > b ? a : b);

          // Add padding to min/max for better visualization
          double padding = (maxValue - minValue) * 0.1; // 10% padding
          double chartMinY = (minValue - padding).clamp(0.0, double.infinity);
          double chartMaxY = maxValue + padding;

          // For very small values, ensure minimum range
          if (chartMaxY - chartMinY < 0.001) {
            chartMaxY = chartMinY + 0.001;
          }

          // Convert FlSpot data to BarChartGroupData
          List<BarChartGroupData> barGroups =
              provider.dailyChartData.asMap().entries.map((entry) {
                int index = entry.key;
                FlSpot spot = entry.value;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: spot.y,
                      color: Colors.redAccent,
                      width: 8.w,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ],
                );
              }).toList();

          return SizedBox(
            width: 1920.w,
            height: 300.h,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  minY: chartMinY,
                  maxY: chartMaxY,
                  barGroups: barGroups,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideVertically: true,
                      getTooltipColor: (touchedSpot) => Colors.redAccent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        int index = group.x;
                        String timeLabel = '';

                        // Safe index checking
                        if (index >= 0 &&
                            index < provider.dailyTimeLabels.length) {
                          timeLabel = provider.dailyTimeLabels[index];
                        }

                        return BarTooltipItem(
                          '⚡ ${rod.toY.toStringAsFixed(2)} kWh\n📅 $timeLabel',
                          TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.3, // Line spacing
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        maxIncluded: true,
                        minIncluded: false,
                        showTitles: true,
                        reservedSize: 40.w,
                        interval: (chartMaxY - chartMinY) / 4,
                        getTitlesWidget:
                            (value, meta) => Text(
                              '${value.toInt()} kWh',
                              style: TextStyle(fontSize: 10.sp),
                            ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        interval: 1, // every hour
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx < 0 ||
                              idx >= provider.dailyTimeLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            provider.dailyTimeLabels[idx],
                            style: TextStyle(fontSize: 8.sp),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: (chartMaxY - chartMinY) / 4,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
