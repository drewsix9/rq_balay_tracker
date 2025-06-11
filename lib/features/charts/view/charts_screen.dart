import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rq_balay_tracker/features/charts/model/month_total_model.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/providers/bills_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../model/usage_trend_model.dart';
import '../viewmodel/charts_viewmodel.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChartsViewModel>(context, listen: false).initialize(
        Provider.of<BillsProvider>(
          context,
          listen: false,
        ).transactionHistory!.transactionHistory!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ChartsViewModel>(context, listen: false).testLoading();
        },
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        title: Text(
          'Utility Analytics',
          style: AppTextStyles.subheading.copyWith(
            color: AppColors.surface,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padded summary cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: _buildSummaryCards(),
            ),
            // Padded chart section title/description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildChartSection(
                title: 'Monthly Electricity Consumption',
                description: 'Actual resource consumption in kWh',
              ),
            ),
            // Vertical spacing before chart
            SizedBox(height: 12.h),
            // NO padding here: AspectRatio fills the width
            AspectRatio(
              aspectRatio: 1.5,
              child: Consumer<ChartsViewModel>(
                builder: (context, chartsViewModel, child) {
                  return BarChart(
                    _buildBarChartData(),
                    duration: Duration(milliseconds: 250),
                  );
                },
              ),
            ),
            // Vertical spacing after chart
            SizedBox(height: 24.h),
            // Padded next section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildChartSection(
                title: 'Budget Tracking',
                description: 'Track your monthly budget vs actual spending',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Center(child: Text('Budget Gauge Placeholder')),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Consumer<ChartsViewModel>(
      builder: (context, chartsViewModel, child) {
        MonthTotalModel monthTotal = chartsViewModel.monthTotal!;
        UsageTrendModel usageTrend = chartsViewModel.usageTrend!;
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 1.5,
          children: [
            _buildSummaryCard(
              title: 'This Month\'s Total',
              value: monthTotal.formattedTotal,
              trend: "Last month: ${monthTotal.formattedLastMonthTotal}",
              isPositive: monthTotal.isPositive,
            ),
            _buildSummaryCard(
              title: 'Usage Trend',
              value: usageTrend.formattedTrend,
              trend:
                  usageTrend.isPositive
                      ? "Lower than last month"
                      : "Higher than last month",
              isPositive: usageTrend.isPositive,
              icon:
                  usageTrend.isPositive
                      ? Icons.trending_up
                      : Icons.trending_down,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    IconData? icon,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                value,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 24.sp,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            trend,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subheading.copyWith(fontSize: 18.sp)),
        SizedBox(height: 4.h),
        Text(
          description,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  BarChartData _buildBarChartData() {
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
      // minY:
      //     0, // You can set this to a small positive value for more bottom space, e.g., 20
      // maxY: maxValue * 1.15, // 15% more space at the top
      barTouchData: BarTouchData(),
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
      barGroups: _buildBarChartGroupData(),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = AppTextStyles.body.copyWith(
      color: AppColors.textSecondary,
      fontSize: 14.sp,
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
      case 12:
        text = Text('D', style: style);
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 8, // Space from the axis
      child: text,
    );
  }

  List<BarChartGroupData> _buildBarChartGroupData() {
    var provider = Provider.of<ChartsViewModel>(context, listen: false);
    var consumption = provider.electricityChartModel!.consumptions;
    var months = provider.electricityChartModel!.rMonth;

    // Limit to last 12 months
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
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: width,
          borderRadius: BorderRadius.circular(6.r),
          gradient: AppGradients.electricityGradient,
        ),
      ],
    );
  }
}
