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

  const BaseMonthlyConsumptionChart({
    super.key,
    this.chartKey,
    required this.chartGradient,
  });

  @override
  State<BaseMonthlyConsumptionChart> createState() =>
      _BaseMonthlyConsumptionChartState();

  // Abstract methods to be implemented by child classes
  List<double> getConsumptionData(ChartsViewModel provider);

  List<String> getMonthsData(ChartsViewModel provider);
}

class _BaseMonthlyConsumptionChartState
    extends State<BaseMonthlyConsumptionChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Consumer<ChartsViewModel>(
        builder: (context, chartsViewModel, child) {
          return BarChart(
            _buildBarChartData(context),
            duration: Duration(milliseconds: 250),
            key: widget.chartKey,
          );
        },
      ),
    );
  }

  BarChartData _buildBarChartData(BuildContext context) {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = widget.getConsumptionData(provider);
    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    return BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38.w,
          ),
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      backgroundColor: AppColors.background,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          rotateAngle: -90,
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 2.h,
          getTooltipItem: getBarTooltipItem(context),
        ),
      ),
      barGroups: _buildBarChartGroupData(context),
    );
  }

  GetBarTooltipItem getBarTooltipItem(BuildContext context) {
    return (
      BarChartGroupData group,
      int groupIndex,
      BarChartRodData rod,
      int rodIndex,
    ) {
      final color = rod.gradient?.colors.first ?? rod.color;
      final theme = Theme.of(context);

      return BarTooltipItem(
        rod.toY.round().toString(),
        theme.textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w300,
        ),
      );
    };
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = AppTextStyles.body.copyWith(
      color: AppColors.textSecondary,
      fontSize: 12.sp,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('J', style: style);
        break;
      case 2:
        text = Text('F', style: style);
        break;
      case 3:
        text = Text('M', style: style);
        break;
      case 4:
        text = Text('A', style: style);
        break;
      case 5:
        text = Text('M', style: style);
        break;
      case 6:
        text = Text('J', style: style);
        break;
      case 7:
        text = Text('J', style: style);
        break;
      case 8:
        text = Text('A', style: style);
        break;
      case 9:
        text = Text('S', style: style);
        break;
      case 10:
        text = Text('O', style: style);
        break;
      case 11:
        text = Text('N', style: style);
        break;
      case 12:
        text = Text('D', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(meta: meta, space: 8, child: text);
  }

  List<BarChartGroupData> _buildBarChartGroupData(BuildContext context) {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = widget.getConsumptionData(provider);
    var months = widget.getMonthsData(provider);

    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    return List.generate(limitedConsumption.length, (index) {
      AppLogger.d('Value to be passed: ${int.parse(months[index])}  ');

      return makeGroupData(
        int.parse(months[index]),
        limitedConsumption[index],
        12.w,
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
      showingTooltipIndicators: [0],
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: width,
          borderRadius: BorderRadius.circular(6.r),
          gradient: widget.chartGradient,
        ),
      ],
    );
  }
}
