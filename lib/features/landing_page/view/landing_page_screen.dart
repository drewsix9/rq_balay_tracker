import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../profile/presentation/side_panel.dart';
import '../viewmodel/landing_page_viewmodel.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final unit = await UnitSharedPref.getUnit();
      if (mounted) {
        context.read<LandingPageViewModel>().initializeData(unit);
      }
    });
  }

  Future<void> _onRefresh() async {
    final unit = await UnitSharedPref.getUnit();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      final landingPageViewModel = Provider.of<LandingPageViewModel>(
        context,
        listen: false,
      );
      await landingPageViewModel.getTodayKWhConsump(unit);
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LandingPageViewModel>(
            context,
            listen: false,
          ).fakeLoading();
        },
        child: Icon(Icons.refresh),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Welcome',
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
      body: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Consumer<LandingPageViewModel>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletonizer(
                      enabled: provider.isLoading,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -1,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(24.w),
                        margin: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 0,
                        ),
                        child: FutureBuilder(
                          future: UserSharedPref.getCurrentUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            var user = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Unit: ${user?.unit}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Monthly Rate:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textMuted,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            symbol: '₱',
                                            decimalDigits: 2,
                                          ).format(
                                            double.tryParse(
                                                  user?.monthlyRate ?? '0',
                                                ) ??
                                                0,
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'WiFi:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textMuted,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        if (user?.wifi == 'Y')
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD1FADF),
                                              borderRadius:
                                                  BorderRadius.circular(999.r),
                                            ),
                                            child: Text(
                                              'Available',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium?.copyWith(
                                                color: const Color(0xFF039855),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                          )
                                        else
                                          Text(
                                            'Not Available',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelMedium?.copyWith(
                                              color: AppColors.textMuted,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Mobile:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textMuted,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          user?.mobileno ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start Date:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.textMuted,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          user?.startDate ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomSlidingSegmentedControl<int>(
                          initialValue: 1,
                          children: {1: Text('Hourly'), 2: Text('Daily')},
                          decoration: BoxDecoration(
                            color: CupertinoColors.lightBackgroundGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          thumbDecoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.3),
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInToLinear,
                          onValueChanged: (v) {
                            return v == 1
                                ? provider.isHourlyViewToggle(true)
                                : provider.isHourlyViewToggle(false);
                          },
                        ),
                        Text(
                          'kWh Consumption',
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Builder(
                      builder: (context) {
                        return provider.isToday
                            ? TodayKwhConsumpChart(provider: provider)
                            : DailyKwhConsumpChart(provider: provider);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TodayKwhConsumpChart extends StatelessWidget {
  final LandingPageViewModel provider;

  const TodayKwhConsumpChart({super.key, required this.provider});

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
          if (provider.todayChartData.isEmpty) {
            return SizedBox(
              width: 1920.w,
              height: 300.h,
              child: Center(child: Text('No consumption data available')),
            );
          }

          double minValue =
              provider.todayChartData.isEmpty
                  ? 0.0
                  : provider.todayChartData
                      .map((spot) => spot.y)
                      .reduce((a, b) => a < b ? a : b);
          double maxValue =
              provider.todayChartData.isEmpty
                  ? 0.001
                  : provider.todayChartData
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
            child: LineChart(
              LineChartData(
                minY: chartMinY,
                maxY: chartMaxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: provider.todayChartData,
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
                            index < provider.todayTimeLabels.length) {
                          timeLabel = provider.todayTimeLabels[index];
                        }

                        return LineTooltipItem(
                          '⚡ ${(spot.y * 1000).toStringAsFixed(2)} mWh\n🕒 $timeLabel',
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
                      showTitles: true,
                      reservedSize: 60.w,
                      interval: (chartMaxY - chartMinY) / 4,
                      getTitlesWidget:
                          (value, meta) => Text(
                            '${(value.toDouble() * 1000).toStringAsFixed(1)} mWh',
                            style: const TextStyle(fontSize: 12),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      interval: 3, // every hour
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx < 0 || idx >= provider.todayTimeLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          provider.todayTimeLabels[idx],
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
                  verticalInterval: 3,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.2),
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
                          '⚡ ${(spot.y * 1000).toStringAsFixed(2)} mWh\n🕒 $timeLabel',
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
                      showTitles: true,
                      reservedSize: 60.w,
                      interval: (chartMaxY - chartMinY) / 4,
                      getTitlesWidget:
                          (value, meta) => Text(
                            '${(value.toDouble() * 1000).toStringAsFixed(1)} mWh',
                            style: const TextStyle(fontSize: 12),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // interval: 3, // every hour
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx < 0 || idx >= provider.dailyTimeLabels.length) {
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
          );
        },
      ),
    );
  }
}
