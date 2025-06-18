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
          AppLogger.w('Building chart');
          var consumption = widget.getConsumptionData(chartsViewModel);
          if (consumption.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          bool allZeros = consumption.every((element) => element == 0);
          if (allZeros) {
            AppLogger.w('All consumption values are zero');
            return Center(
              child: Text(
                'No data available',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            );
          }

          return BarChart(
            _buildBarChartData(context, consumption),
            duration: Duration(milliseconds: 250),
            key: widget.chartKey,
          );
        },
      ),
    );
  }

  BarChartData _buildBarChartData(
    BuildContext context,
    List<double> consumption,
  ) {
    return BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                (value, meta) => getTitles(value, meta, consumption),
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
      final color = rod.color;
      final theme = Theme.of(context);

      return BarTooltipItem(
        rod.toY.round().toString(),
        theme.textTheme.bodySmall!.copyWith(
          color: color,
          fontWeight: FontWeight.w400,
        ),
      );
    };
  }

  Widget getTitles(double value, TitleMeta meta, List<double> consumption) {
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
        AppLogger.w('Value in switch: $value');
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(meta: meta, space: 8, child: text);
  }

  List<BarChartGroupData> _buildBarChartGroupData(BuildContext context) {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = widget.getConsumptionData(provider);
    var months = widget.getMonthsData(provider);
    if (consumption.isEmpty || months.isEmpty) {
      AppLogger.w('No consumption or months data available');
      return [];
    }

    final limitedConsumption =
        consumption.length > 12 ? consumption.sublist(0, 12) : consumption;

    return List.generate(limitedConsumption.length, (index) {
      return makeGroupData(
        int.tryParse(months[index]) ?? 0,
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
      showingTooltipIndicators:
          y > 0 ? [0] : [], // Only show tooltip if value > 0
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          // color: y > 0 ? color : Colors.transparent, // Make rod transparent if value is 0
          gradient:
              y > 0 ? widget.chartGradient : AppGradients.primaryBlueGradient,
          width: width,
          borderRadius: BorderRadius.circular(4.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y > 0 ? y : 0, // Only show background if value > 0
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
