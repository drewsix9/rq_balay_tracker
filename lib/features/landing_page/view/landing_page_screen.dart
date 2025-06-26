import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/daily_kwh_consump_chart.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/today_kwh_consump_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
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
  late CurrentUserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final unit = await UnitSharedPref.getUnit();
      if (mounted) {
        context.read<LandingPageViewModel>().initializeData(unit);
        user = await UserSharedPref.getCurrentUser();
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
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       icon: Icon(Icons.menu, color: Colors.white, size: 24.sp),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //     );
        //   },
        // ),
      ),
      // drawer: SidePanel(),
      body: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController,
        header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
        physics: const AlwaysScrollableScrollPhysics(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
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
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -1,
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20.w),
                        margin: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.name,
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
                              'Unit: ${user!.unit}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
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
                                        double.tryParse(user!.monthlyRate) ?? 0,
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
                                SizedBox(height: 8.h),
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
                                    if (user!.wifi == 'Y')
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD1FADF),
                                          borderRadius: BorderRadius.circular(
                                            999.r,
                                          ),
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
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEE4E2),
                                          borderRadius: BorderRadius.circular(
                                            999.r,
                                          ),
                                        ),
                                        child: Text(
                                          'Unavailable',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium?.copyWith(
                                            color: const Color(0xFFB42318),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
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
                                      user!.mobileno ?? '',
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
                                SizedBox(height: 8.h),
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
                                      user!.startDate.isNotEmpty
                                          ? DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(user!.startDate),
                                          )
                                          : '',
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
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB), // bg-gray-200
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: EdgeInsets.all(4.w),
                          child: _toggleChartSlider(provider),
                        ),
                        Text(
                          'Wh Consumption',
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    provider.isToday
                        ? TodayKwhConsumpChart(
                          provider: provider,
                          dataPointSpacing: 50.w,
                        )
                        : DailyKwhConsumpChart(provider: provider),
                    // Add extra space to ensure content is scrollable
                    SizedBox(height: 100.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggleChartSlider(LandingPageViewModel provider) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => provider.isHourlyViewToggle(true),
          child: Container(
            decoration: BoxDecoration(
              color:
                  provider.isToday
                      ? const Color(0xFF4a90e2) // active: blue
                      : const Color(0xFFE5E7EB), // inactive: gray
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Text(
              'Hourly',
              style: TextStyle(
                color:
                    provider.isToday
                        ? Colors
                            .white // active: white
                        : const Color(0xFF374151), // inactive: gray-800
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () => provider.isHourlyViewToggle(false),
          child: Container(
            decoration: BoxDecoration(
              color:
                  !provider.isToday
                      ? const Color(0xFF4a90e2) // active: blue
                      : const Color(0xFFE5E7EB), // inactive: gray
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Text(
              'Daily',
              style: TextStyle(
                color:
                    !provider.isToday
                        ? Colors
                            .white // active: white
                        : const Color(0xFF374151), // inactive: gray-800
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
