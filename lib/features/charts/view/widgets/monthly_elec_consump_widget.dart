import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/logger/app_logger.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../viewmodel/charts_viewmodel.dart';

class MonthlyElectricityConsumptionWidget extends StatelessWidget {
  const MonthlyElectricityConsumptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Consumer<ChartsViewModel>(
        builder: (context, chartsViewModel, child) {
          return BarChart(
            _buildBarChartData(context),
            duration: Duration(milliseconds: 250),
          );
        },
      ),
    );
  }

  BarChartData _buildBarChartData(BuildContext context) {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = provider.electricityChartModel!.consumptions;
    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    // Find the max value for spacing
    final maxValue =
        limitedConsumption.isNotEmpty
            ? limitedConsumption.reduce((a, b) => a > b ? a : b)
            : 0;

    return BarChartData(
      barTouchData: BarTouchData(),
      alignment: BarChartAlignment.spaceEvenly,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => getTitles(context, value, meta),
            reservedSize: 38.w,
          ),
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      backgroundColor: AppColors.background,
      barGroups: _buildBarChartGroupData(context),
    );
  }

  Widget getTitles(BuildContext context, double value, TitleMeta meta) {
    var style = AppTextStyles.body.copyWith(
      color: AppColors.textSecondary,
      fontSize: 14.sp,
    );
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var months = provider.electricityChartModel!.rMonth;
    int idx = value.toInt();
    if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
    String initial = months[idx].isNotEmpty ? months[idx][0] : '';
    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(initial, style: style),
    );
  }

  List<BarChartGroupData> _buildBarChartGroupData(BuildContext context) {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = provider.electricityChartModel!.consumptions;
    var months = provider.electricityChartModel!.rMonth;

    // Limit to last 12 months
    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    return List.generate(limitedConsumption.length, (index) {
      AppLogger.d('Value to be passed: ${months[index]}');
      return makeGroupData(
        index,
        limitedConsumption[index],
        10.w,
        10.h,
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
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: width,
          borderRadius: BorderRadius.circular(12.r),
          gradient: AppGradients.warningGradient,
        ),
      ],
    );
  }
}
