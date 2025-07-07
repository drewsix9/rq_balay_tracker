import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';
import 'package:rq_balay_tracker/core/utils/responsive_helper.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/daily_kwh_consump_chart.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/shimmer/row_toggle_chart_shimmer.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/shimmer/user_info_card_shimmer.dart';
import 'package:rq_balay_tracker/features/landing_page/view/widgets/today_kwh_consump_chart.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../viewmodel/landing_page_viewmodel.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  RefreshController? _refreshController;
  late CurrentUserModel? user;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final unit = await UnitSharedPref.getUnit();
      if (mounted) {
        context.read<LandingPageViewModel>().initializeData(unit);
        user = await UserSharedPref.getCurrentUser();
      }
    });
  }

  Future<void> testLoading() async {
    if (!mounted) return;
    final landingPageViewModel = Provider.of<LandingPageViewModel>(
      context,
      listen: false,
    );
    landingPageViewModel.fakeLoading();
  }

  Future<void> _onRefresh() async {
    final unit = await UnitSharedPref.getUnit();
    final landingPageViewModel = Provider.of<LandingPageViewModel>(
      context,
      listen: false,
    );
    landingPageViewModel.toggleLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    try {
      if (!mounted) return;
      await landingPageViewModel.getTodayKWhConsump(unit);
      _refreshController!.refreshCompleted();
    } catch (e) {
      if (mounted) {
        _lastError = e.toString();
        SnackBarUtils.showError(context, _lastError!);
      }
      _refreshController!.refreshFailed();
    } finally {
      if (mounted) {
        landingPageViewModel.toggleLoading(false);
      }
    }
  }

  @override
  void dispose() {
    _refreshController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     testLoading();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Welcome',
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
      body: SmartRefresher(
        onRefresh: _onRefresh,
        controller: _refreshController!,
        header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
        physics: const AlwaysScrollableScrollPhysics(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: ResponsiveHelper.getScreenPadding(context),
            child: Consumer<LandingPageViewModel>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.isLoading
                        ? const UserInfoCardShimmer()
                        : Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getBorderRadius(context),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                spreadRadius: -1,
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ],
                          ),
                          padding: ResponsiveHelper.getCardPadding(context),
                          margin: EdgeInsets.symmetric(
                            vertical:
                                ResponsiveHelper.getSpacing(context) * 0.17,
                            horizontal: 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.name,
                                style: AppTextStyles.heading.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  fontSize: ResponsiveHelper.getHeadingFontSize(
                                    context,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    ResponsiveHelper.getSpacing(context) * 0.17,
                              ),
                              Text(
                                'Unit: ${user!.unit}',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: ResponsiveHelper.getFontSize(
                                    context,
                                    mobileSize: 15.0,
                                    tablet7Size: 16.0,
                                    tablet10Size: 17.0,
                                    largeTabletSize: 18.0,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height:
                                    ResponsiveHelper.getSpacing(context) * 0.5,
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Monthly Rate:',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textMuted,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 15.0,
                                                tablet7Size: 16.0,
                                                tablet10Size: 17.0,
                                                largeTabletSize: 18.0,
                                              ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                          symbol: '₱',
                                          decimalDigits: 2,
                                        ).format(
                                          double.tryParse(user!.monthlyRate) ??
                                              0,
                                        ),
                                        style: AppTextStyles.body.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 16.0,
                                                tablet7Size: 17.0,
                                                tablet10Size: 18.0,
                                                largeTabletSize: 19.0,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        ResponsiveHelper.getSpacing(context) *
                                        0.33,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'WiFi:',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textMuted,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 15.0,
                                                tablet7Size: 16.0,
                                                tablet10Size: 17.0,
                                                largeTabletSize: 18.0,
                                              ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (user!.wifi == 'Y')
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ResponsiveHelper.getSpacing(
                                                  context,
                                                ) *
                                                0.5,
                                            vertical:
                                                ResponsiveHelper.getSpacing(
                                                  context,
                                                ) *
                                                0.17,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD1FADF),
                                            borderRadius: BorderRadius.circular(
                                              999.r,
                                            ),
                                          ),
                                          child: Text(
                                            'Available',
                                            style: AppTextStyles.caption.copyWith(
                                              color: const Color(0xFF039855),
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobileSize: 13.0,
                                                    tablet7Size: 14.0,
                                                    tablet10Size: 15.0,
                                                    largeTabletSize: 16.0,
                                                  ),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ResponsiveHelper.getSpacing(
                                                  context,
                                                ) *
                                                0.5,
                                            vertical:
                                                ResponsiveHelper.getSpacing(
                                                  context,
                                                ) *
                                                0.17,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEE4E2),
                                            borderRadius: BorderRadius.circular(
                                              999.r,
                                            ),
                                          ),
                                          child: Text(
                                            'Unavailable',
                                            style: AppTextStyles.caption.copyWith(
                                              color: const Color(0xFFB42318),
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  ResponsiveHelper.getFontSize(
                                                    context,
                                                    mobileSize: 13.0,
                                                    tablet7Size: 14.0,
                                                    tablet10Size: 15.0,
                                                    largeTabletSize: 16.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        ResponsiveHelper.getSpacing(context) *
                                        0.33,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Mobile:',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textMuted,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 15.0,
                                                tablet7Size: 16.0,
                                                tablet10Size: 17.0,
                                                largeTabletSize: 18.0,
                                              ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        user!.mobileno ?? '',
                                        style: AppTextStyles.body.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 16.0,
                                                tablet7Size: 17.0,
                                                tablet10Size: 18.0,
                                                largeTabletSize: 19.0,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        ResponsiveHelper.getSpacing(context) *
                                        0.33,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Start Date:',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textMuted,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 15.0,
                                                tablet7Size: 16.0,
                                                tablet10Size: 17.0,
                                                largeTabletSize: 18.0,
                                              ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        user!.startDate.isNotEmpty
                                            ? DateFormat('MMM dd, yyyy').format(
                                              DateTime.parse(user!.startDate),
                                            )
                                            : '',
                                        style: AppTextStyles.body.copyWith(
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                mobileSize: 16.0,
                                                tablet7Size: 17.0,
                                                tablet10Size: 18.0,
                                                largeTabletSize: 19.0,
                                              ),
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context) * 0.5,
                    ),
                    // Row shimmer for toggle and Wh Consumption
                    provider.isLoading
                        ? const RowToggleChartShimmer()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB), // bg-gray-200
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: EdgeInsets.all(
                                ResponsiveHelper.getSpacing(context) * 0.17,
                              ),
                              child: _toggleChartSlider(provider),
                            ),
                            Text(
                              'Wh Consumption',
                              style: AppTextStyles.subheading.copyWith(
                                fontSize: ResponsiveHelper.getHeadingFontSize(
                                  context,
                                  mobileSize: 18.0,
                                  tablet7Size: 20.0,
                                  tablet10Size: 22.0,
                                  largeTabletSize: 24.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context) * 0.5,
                    ),
                    provider.isToday
                        ? TodayKwhConsumpChart(
                          provider: provider,
                          dataPointSpacing:
                              ResponsiveHelper.isTablet(context)
                                  ? 80.0.w
                                  : 50.0.w,
                        )
                        : DailyKwhConsumpChart(provider: provider),
                    // Add minimal bottom padding for better UX
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context) * 0.5,
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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context) * 0.5,
              vertical: ResponsiveHelper.getSpacing(context) * 0.25,
            ),
            child: Text(
              'Hourly',
              style: TextStyle(
                color:
                    provider.isToday
                        ? Colors
                            .white // active: white
                        : const Color(0xFF374151), // inactive: gray-800
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  mobileSize: 12.0,
                  tablet7Size: 13.0,
                  tablet10Size: 14.0,
                  largeTabletSize: 15.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.33),
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
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context) * 0.5,
              vertical: ResponsiveHelper.getSpacing(context) * 0.25,
            ),
            child: Text(
              'Daily',
              style: TextStyle(
                color:
                    !provider.isToday
                        ? Colors
                            .white // active: white
                        : const Color(0xFF374151), // inactive: gray-800
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.getFontSize(
                  context,
                  mobileSize: 12.0,
                  tablet7Size: 13.0,
                  tablet10Size: 14.0,
                  largeTabletSize: 15.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
