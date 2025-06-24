import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/logger/app_logger.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../viewmodel/charts_viewmodel.dart';

abstract class BaseMonthlyConsumptionChart extends StatefulWidget {
  final Key? chartKey;
  final Gradient chartGradient;
  final String chartType;
  final bool showContainer;

  const BaseMonthlyConsumptionChart({
    super.key,
    this.chartKey,
    required this.chartGradient,
    required this.chartType,
    this.showContainer = true,
  });

  @override
  State<BaseMonthlyConsumptionChart> createState() =>
      _BaseMonthlyConsumptionChartState();

  // Abstract methods to be implemented by child classes
  Future<List<double>> getConsumptionData(ChartsViewModel provider);

  Future<List<String>> getMonthsData(ChartsViewModel provider);
}

class _BaseMonthlyConsumptionChartState
    extends State<BaseMonthlyConsumptionChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    Widget chartContent = AspectRatio(
      aspectRatio: 1.5,
      child: FutureBuilder<List<double>>(
        future: widget.getConsumptionData(context.read<ChartsViewModel>()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 32.sp,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Error loading data',
                      style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 32.sp,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'No data available',
                      style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            );
          }
          var consumption = snapshot.data!;
          return FutureBuilder<BarChartData>(
            future: _buildBarChartData(context, consumption),
            builder: (context, barChartSnapshot) {
              if (barChartSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                );
              } else if (barChartSnapshot.hasError) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Error: ${barChartSnapshot.error}',
                      style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                    ),
                  ),
                );
              } else if (!barChartSnapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'No chart data',
                      style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                    ),
                  ),
                );
              }
              return BarChart(
                barChartSnapshot.data!,
                duration: const Duration(milliseconds: 500),
                key: widget.chartKey,
              );
            },
          );
        },
      ),
    );

    if (!widget.showContainer) {
      return chartContent;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(padding: EdgeInsets.all(12.w), child: chartContent),
      ),
    );
  }

  Future<BarChartData> _buildBarChartData(
    BuildContext context,
    List<double> consumption,
  ) async {
    double maxValue =
        consumption.isEmpty ? 1.0 : consumption.reduce((a, b) => a > b ? a : b);
    double minValue =
        consumption.isEmpty ? 0.0 : consumption.reduce((a, b) => a < b ? a : b);

    // Add padding for better visualization
    double padding = (maxValue - minValue) * 0.15;
    double chartMaxY = maxValue + padding;
    double chartMinY = (minValue - padding).clamp(0.0, double.infinity);

    return BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      minY: chartMinY,
      maxY: chartMaxY,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32.w,
            interval: (chartMaxY - chartMinY) / 4,
            getTitlesWidget:
                (value, meta) => Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: Text(
                    '${value.toInt()}',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                (value, meta) => getTitles(value, meta, consumption),
            reservedSize: 32.h,
          ),
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
      backgroundColor: Colors.transparent,
      barTouchData: BarTouchData(
        enabled: true,
        // touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
        //   setState(() {
        //     if (response?.spot != null && event.isInterestedForInteractions) {
        //       touchedIndex = response!.spot!.touchedBarGroupIndex;
        //     } else {
        //       touchedIndex = null;
        //     }
        //   });
        // },
        touchTooltipData: BarTouchTooltipData(
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          tooltipMargin: 4.h,
          maxContentWidth: 160.w,
          getTooltipColor:
              (touchedSpot) => AppColors.surface.withValues(alpha: 0.8),
          getTooltipItem: getBarTooltipItem(),
        ),
      ),
      barGroups: await _buildBarChartGroupData(context),
    );
  }

  GetBarTooltipItem getBarTooltipItem() {
    return (
      BarChartGroupData group,
      int groupIndex,
      BarChartRodData rod,
      int rodIndex,
    ) {
      String monthName = _getMonthName(group.x);

      return BarTooltipItem(
        '📊 ${rod.toY.toStringAsFixed(2)}\n📅 $monthName',
        AppTextStyles.body.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      );
    };
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown';
    }
  }

  Widget getTitles(double value, TitleMeta meta, List<double> consumption) {
    var style = AppTextStyles.caption.copyWith(
      color: AppColors.textMuted,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
    );

    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('Jan', style: style);
        break;
      case 2:
        text = Text('Feb', style: style);
        break;
      case 3:
        text = Text('Mar', style: style);
        break;
      case 4:
        text = Text('Apr', style: style);
        break;
      case 5:
        text = Text('May', style: style);
        break;
      case 6:
        text = Text('Jun', style: style);
        break;
      case 7:
        text = Text('Jul', style: style);
        break;
      case 8:
        text = Text('Aug', style: style);
        break;
      case 9:
        text = Text('Sep', style: style);
        break;
      case 10:
        text = Text('Oct', style: style);
        break;
      case 11:
        text = Text('Nov', style: style);
        break;
      case 12:
        text = Text('Dec', style: style);
        break;
      default:
        AppLogger.w('Value in switch: $value');
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Padding(padding: EdgeInsets.only(top: 4.h), child: text),
    );
  }

  Future<List<BarChartGroupData>> _buildBarChartGroupData(
    BuildContext context,
  ) async {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = await widget.getConsumptionData(provider);
    var months = await widget.getMonthsData(provider);
    if (consumption.isEmpty || months.isEmpty) {
      AppLogger.w('No consumption or months data available');
      return [];
    }

    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    // // Calculate maximum value first
    // double maxElecWater = 0;
    // for (int i = 0; i < limitedConsumption.length; i++) {
    //   maxElecWater = max(maxElecWater, limitedConsumption[i]);
    // }

    // // Assign to appropriate property based on chart type
    // if (widget.chartType == 'electricity') {
    //   provider.yMaxElectricity = maxElecWater;
    // } else if (widget.chartType == 'water') {
    //   provider.yMaxWater = maxElecWater;
    // }

    return List.generate(limitedConsumption.length, (index) {
      return makeGroupData(
        int.tryParse(months[index]) ?? 0,
        limitedConsumption[index],
        12.w,
        8.h,
        AppColors.primaryBlue,
      );
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
    double width,
    double height,
    Color color,
  ) {
    return BarChartGroupData(
      // showingTooltipIndicators: y > 0 ? [0] : [],
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient:
              y > 0 ? widget.chartGradient : AppGradients.primaryBlueGradient,
          width: width,
          borderRadius: BorderRadius.circular(4.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y > 0 ? y : 0,
            color: AppColors.border.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
