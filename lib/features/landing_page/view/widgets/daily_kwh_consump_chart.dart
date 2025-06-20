import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/features/landing_page/viewmodel/landing_page_viewmodel.dart';

class DailyKwhConsumpChart extends StatelessWidget {
  final LandingPageViewModel provider;

  const DailyKwhConsumpChart({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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

          return SizedBox(
            width: 1920.w,
            height: 300.h,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: LineChart(
                LineChartData(
                  minY: chartMinY,
                  maxY: chartMaxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: provider.dailyChartData,
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withValues(alpha: 0.1),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideVertically: true,
                      getTooltipColor: (touchedSpot) => Colors.redAccent,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          int index = spot.x.toInt();
                          String timeLabel = '';

                          // Safe index checking
                          if (index >= 0 &&
                              index < provider.dailyTimeLabels.length) {
                            timeLabel = provider.dailyTimeLabels[index];
                          }

                          return LineTooltipItem(
                            '⚡ ${spot.y.toStringAsFixed(2)} kWh\n📅 $timeLabel',
                            TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.3, // Line spacing
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
                        reservedSize: 50.w,
                        interval: (chartMaxY - chartMinY) / 4,
                        getTitlesWidget:
                            (value, meta) => Text(
                              '${value.toInt()} kWh',
                              style: const TextStyle(fontSize: 12),
                            ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // every hour
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx < 0 ||
                              idx >= provider.dailyTimeLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            provider.dailyTimeLabels[idx],
                            style: const TextStyle(fontSize: 10),
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
                    // checkToShowHorizontalLine: (value) => true,
                    // checkToShowVerticalLine: (value) => true,
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
