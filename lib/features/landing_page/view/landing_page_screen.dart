import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../profile/presentation/side_panel.dart';
import '../viewmodel/landing_page_viewmodel.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final unit = await UnitSharedPref.getUnit();
      if (context.mounted) {
        context.read<LandingPageViewModel>().getTodayKWhConsump(unit);
      }
    });
  }

  Future<void> _onRefresh() async {
    final unit = await UnitSharedPref.getUnit();
    if (context.mounted) {
      context.read<LandingPageViewModel>().getTodayKWhConsump(unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<LandingPageViewModel>().user;

    return Scaffold(
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
        controller: RefreshController(initialRefresh: false),
        header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                  margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Unit: ${user.unit}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                '₱${user.monthlyRate}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              if (user.wifi == 'Y')
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FADF),
                                    borderRadius: BorderRadius.circular(999.r),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                user.mobileNo,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                user.startDate,
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
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Today\'s kWh Consumption',
                  style: AppTextStyles.subheading.copyWith(fontSize: 18.sp),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Consumer<LandingPageViewModel>(
                    builder: (context, provider, child) {
                      if (provider.chartData.isEmpty) {
                        return SizedBox(
                          width: 1920.w,
                          height: 350.h,
                          child: Center(
                            child: Text('No consumption data available'),
                          ),
                        );
                      }
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      double minValue =
                          provider.chartData.isEmpty
                              ? 0.0
                              : provider.chartData
                                  .map((spot) => spot.y)
                                  .reduce((a, b) => a < b ? a : b);
                      double maxValue =
                          provider.chartData.isEmpty
                              ? 0.001
                              : provider.chartData
                                  .map((spot) => spot.y)
                                  .reduce((a, b) => a > b ? a : b);

                      // Add padding to min/max for better visualization
                      double padding =
                          (maxValue - minValue) * 0.1; // 10% padding
                      double chartMinY = (minValue - padding).clamp(
                        0.0,
                        double.infinity,
                      );
                      double chartMaxY = maxValue + padding;

                      // For very small values, ensure minimum range
                      if (chartMaxY - chartMinY < 0.001) {
                        chartMaxY = chartMinY + 0.001;
                      }

                      return SizedBox(
                        width: 1920.w,
                        height: 350.h,
                        child: LineChart(
                          LineChartData(
                            minY: chartMinY,
                            maxY: chartMaxY,
                            lineBarsData: [
                              LineChartBarData(
                                spots: provider.chartData,
                                isCurved: true,
                                color: Colors.redAccent,
                                barWidth: 2,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                fitInsideVertically: true,
                                getTooltipColor:
                                    (touchedSpot) => Colors.redAccent,
                                getTooltipItems: (
                                  List<LineBarSpot> touchedSpots,
                                ) {
                                  return touchedSpots.map((spot) {
                                    int index = spot.x.toInt();
                                    String timeLabel = '';

                                    // Safe index checking
                                    if (index >= 0 &&
                                        index < provider.timeLabels.length) {
                                      timeLabel = provider.timeLabels[index];
                                    }

                                    return LineTooltipItem(
                                      '⚡ ${spot.y.toStringAsFixed(4)} KWh\n🕒 $timeLabel',
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
                                        '${value.toDouble().toStringAsFixed(4)} KWh',
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
                                    if (idx < 0 ||
                                        idx >= provider.timeLabels.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      provider.timeLabels[idx],
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
                            gridData: const FlGridData(show: false),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
