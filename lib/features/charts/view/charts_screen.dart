import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:rq_balay_tracker/core/utils/snackbar_utils.dart';
import 'package:rq_balay_tracker/features/charts/model/month_total_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../model/usage_trend_model.dart';
import '../viewmodel/charts_provider.dart';
import 'shimmers/combined_chart_card_shimmer.dart';
import 'shimmers/summary_card_shimmer.dart';
import 'widgets/monthly_elec_consump_chart.dart';
import 'widgets/monthly_water_consump_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  RefreshController? _refreshController;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String unit = await UnitSharedPref.getUnit() ?? '';
      final transactionHistory = await ApiService.getTransactionHistory(unit);
      if (!mounted) return;
      final chartsViewModel = Provider.of<ChartsProvider>(
        context,
        listen: false,
      );
      await chartsViewModel.initialize(transactionHistory.transactionHistory!);
    });
  }

  @override
  void dispose() {
    _refreshController!.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      if (!mounted) return;
      final chartsViewModel = Provider.of<ChartsProvider>(
        context,
        listen: false,
      );
      await chartsViewModel.reload();
      _refreshController!.refreshCompleted();
    } catch (e) {
      _refreshController!.refreshFailed();
    }
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
            fontSize: ResponsiveHelper.getHeadingFontSize(context),
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        toolbarHeight: ResponsiveHelper.getAppBarHeight(context),
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       icon: Icon(Icons.menu, color: Colors.white, size: ResponsiveHelper.getIconSize(context)),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //     );
        //   },
        // ),
      ),
      // drawer: SidePanel(),
      body: SafeArea(
        child: Consumer<ChartsProvider>(
          builder: (context, chartsViewModel, child) {
            // Handle error state
            if (chartsViewModel.error != null &&
                chartsViewModel.error != _lastError) {
              _lastError = chartsViewModel.error;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SnackBarUtils.showError(context, chartsViewModel.error!);
              });
            }

            return SmartRefresher(
              controller: _refreshController!,
              onRefresh: _onRefresh,
              header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getPadding(context),
                        vertical: ResponsiveHelper.getSpacing(context) * 0.33,
                      ),
                      child: _buildSummaryCards(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getPadding(context),
                        vertical: ResponsiveHelper.getSpacing(context) * 0.33,
                      ),
                      child: Consumer<ChartsProvider>(
                        builder: (context, chartsViewModel, child) {
                          if (chartsViewModel.isLoading) {
                            return const CombinedChartCardShimmer();
                          }
                          return _buildCombinedChartCard(
                            title: 'Monthly Electricity Consumption (kWh)',
                            icon: Icons.electric_bolt,
                            color: AppColors.primaryBlue,
                            chartWidget:
                                MonthlyElectricityConsumptionWidget.monthlyElectricityConsumptionChart(
                                  showContainer: false,
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getPadding(context),
                        vertical: ResponsiveHelper.getSpacing(context) * 0.33,
                      ),
                      child: Consumer<ChartsProvider>(
                        builder: (context, chartsViewModel, child) {
                          if (chartsViewModel.isLoading) {
                            return const CombinedChartCardShimmer();
                          }
                          return _buildCombinedChartCard(
                            title: 'Monthly Water Consumption (m³)',
                            icon: Icons.water_drop,
                            color: const Color(0xFF4299E1),
                            chartWidget:
                                MonthlyWaterConsumptionWidget.monthlyWaterConsumptionChart(
                                  showContainer: false,
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Consumer<ChartsProvider>(
      builder: (context, chartsViewModel, child) {
        if (chartsViewModel.isLoading) {
          return SizedBox(
            height: ResponsiveHelper.getFontSize(
              context,
              mobileSize: 160.0,
              tablet7Size: 200.0,
              tablet10Size: 240.0,
              largeTabletSize: 280.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 160.w),
                    child: const SummaryCardShimmer(),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.33),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 160.w),
                    child: const SummaryCardShimmer(),
                  ),
                ),
              ],
            ),
          );
        }

        if (chartsViewModel.monthTotal == null ||
            chartsViewModel.usageTrend == null) {
          return const Center(child: SizedBox.shrink());
        }

        MonthTotalModel monthTotal = chartsViewModel.monthTotal!;
        UsageTrendModel usageTrend = chartsViewModel.usageTrend!;

        return SizedBox(
          height: ResponsiveHelper.getFontSize(
            context,
            mobileSize: 160.0,
            tablet7Size: 200.0,
            tablet10Size: 240.0,
            largeTabletSize: 280.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 160.w),
                  child: _buildSummaryCard(
                    title: 'This Month\'s Total',
                    value: monthTotal.formattedTotal,
                    trend: "Last month: ${monthTotal.formattedLastMonthTotal}",
                    isPositive: monthTotal.isPositive,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.33),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 160.w),
                  child: _buildSummaryCard(
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
                ),
              ),
            ],
          ),
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context),
        ),
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
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 14.0,
                tablet7Size: 15.0,
                tablet10Size: 16.0,
                largeTabletSize: 17.0,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.33),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isPositive ? Colors.green : Colors.red,
                  size: ResponsiveHelper.getIconSize(context),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.17),
              ],
              Text(
                value,
                style: AppTextStyles.heading.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobileSize: 24.0,
                    tablet7Size: 26.0,
                    tablet10Size: 28.0,
                    largeTabletSize: 30.0,
                  ),
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.17),
          Text(
            trend,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: ResponsiveHelper.getFontSize(
                context,
                mobileSize: 12.0,
                tablet7Size: 13.0,
                tablet10Size: 14.0,
                largeTabletSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget chartWidget,
  }) {
    return Container(
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getSpacing(context) * 0.25,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveHelper.getIconSize(context),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.33),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 16.0,
                      tablet7Size: 18.0,
                      tablet10Size: 20.0,
                      largeTabletSize: 22.0,
                    ),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.67),
          chartWidget,
        ],
      ),
    );
  }
}
