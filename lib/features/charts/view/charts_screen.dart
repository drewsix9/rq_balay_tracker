import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rq_balay_tracker/features/charts/model/month_total_model.dart';

import '../../../core/providers/bills_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../profile/presentation/side_panel.dart';
import '../model/usage_trend_model.dart';
import '../viewmodel/charts_viewmodel.dart';
import 'widgets/monthly_elec_consump_chart.dart';
import 'widgets/monthly_water_consump_chart.dart';

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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<ChartsViewModel>(context, listen: false).testLoading();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Utility Analytics',
          style: AppTextStyles.subheading.copyWith(
            color: AppColors.surface,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 24.sp),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: SidePanel(),
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
              padding: EdgeInsets.all(16.w),
              child: _buildChartSection(
                title: 'Monthly Electricity Consumption (kWh)',
              ),
            ),
            // Vertical spacing before chart
            SizedBox(height: 24.h),
            // NO padding here: AspectRatio fills the width
            MonthlyElectricityConsumptionWidget.MonthlyElectricityConsumptionChart(),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildChartSection(
                title: 'Monthly Water Consumption (m3)',
                // description: 'Actual resource consumption in m3',
              ),
            ),
            // Vertical spacing before chart
            SizedBox(height: 24.h),
            // NO padding here: AspectRatio fills the width
            MonthlyWaterConsumptionWidget.MonthlyWaterConsumptionChart(),
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

  Widget _buildChartSection({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.subheading.copyWith(fontSize: 18.sp)),
      ],
    );
  }
}
