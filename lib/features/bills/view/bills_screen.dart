// lib/features/bills/presentation/bills_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rq_balay_tracker/features/bills/view/shimmers/bill_card_shimmer.dart';
import 'package:rq_balay_tracker/features/bills/view/shimmers/transaction_list_shimmer.dart';
import 'package:rq_balay_tracker/features/bills/view/shimmers/transaction_title_shimmer.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/model/current_user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../model/month_bill_model.dart';
import '../viewmodel/bills_provider.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  RefreshController? _refreshController;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillsProvider>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final billsProvider = Provider.of<BillsProvider>(context);
    if (billsProvider.error != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        SnackBarUtils.showError(context, billsProvider.error!);
      });
    }
  }

  Future<void> _onRefresh() async {
    final billsProvider = Provider.of<BillsProvider>(context, listen: false);
    billsProvider.setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    try {
      await billsProvider.reload();
      _refreshController?.refreshCompleted();
    } catch (e) {
      _refreshController?.refreshFailed();
      if (mounted) {
        SnackBarUtils.showError(context, 'Failed to refresh data');
      }
    } finally {
      billsProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<BillsProvider>(context, listen: false).testLoading();
      //   },
      //   child: Icon(Icons.refresh),
      // ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'My Bills',
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
        child: SmartRefresher(
          onRefresh: _onRefresh,
          controller: _refreshController!,
          header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
          physics: const AlwaysScrollableScrollPhysics(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Consumer<BillsProvider>(
                  builder: (context, billsProvider, child) {
                    // Handle error state
                    if (billsProvider.error != null &&
                        billsProvider.error != _lastError) {
                      _lastError = billsProvider.error;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        SnackBarUtils.showError(context, billsProvider.error!);
                      });
                    }

                    // Show shimmer when loading
                    if (billsProvider.isLoading) {
                      return const BillCardShimmer();
                    }

                    final currentBill = billsProvider.currentBill;
                    if (currentBill == null) {
                      return const Center(
                        child: Text('No bill data available'),
                      );
                    }
                    AppLogger.d('currentBill.paid: ${currentBill.paid}');
                    if (currentBill.paid == 'Y') {
                      return Padding(
                        padding: ResponsiveHelper.getScreenPadding(context),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: AppColors.surface,
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
                          child: Card(
                            // elevation: 20,
                            color: AppColors.surface,
                            child: Padding(
                              padding: ResponsiveHelper.getCardPadding(context),
                              child: Center(
                                child: Text(
                                  'No Pending Payment',
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
                            ),
                          ),
                        ),
                      );
                    }

                    return BuildMonthBillCard(
                      currentUnit: billsProvider.currentUnit,
                      currentUser: billsProvider.currentUser,
                      currentBill: currentBill,
                    );
                  },
                ),
                _buildTransactionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.getPadding(context),
        0.h,
        ResponsiveHelper.getPadding(context),
        0.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<BillsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const TransactionTitleShimmer();
              }
              return Text(
                'Transaction History',
                style: AppTextStyles.subheading.copyWith(
                  fontSize: ResponsiveHelper.getHeadingFontSize(
                    context,
                    mobileSize: 18.0,
                    tablet7Size: 20.0,
                    tablet10Size: 22.0,
                    largeTabletSize: 24.0,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
          Consumer<BillsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const TransactionListShimmer();
              }

              final transactions =
                  provider.transactionHistory?.transactionHistory ?? [];

              if (transactions.isEmpty) {
                return Center(
                  child: Text(
                    'No transaction history',
                    style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                  ),
                );
              }

              // Trim the last object from the list
              final trimmedTransactions =
                  transactions.length > 1
                      ? transactions.sublist(0, transactions.length - 1)
                      : transactions;

              return Scrollbar(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trimmedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = trimmedTransactions[index];
                    return Container(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: ExpansionTile(
                          childrenPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.navActive.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: AppColors.surface,
                          collapsedIconColor: AppColors.textMuted,
                          iconColor: AppColors.textMuted,
                          collapsedTextColor: AppColors.textMuted,
                          textColor: AppColors.textMuted,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('MMMM d, yyyy').format(
                                  DateTime.parse(
                                    transaction.date ??
                                        DateTime.now().toString(),
                                  ),
                                ),
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      transaction.paid == 'Y'
                                          ? AppColors.success
                                          : AppColors.warning,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  transaction.paid == 'Y' ? 'Paid' : 'Pending',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                children: [
                                  _buildBillDetailRow(
                                    'Electricity',
                                    transaction.eTotal ?? '0',
                                    '₱${transaction.eRate}/kWh',
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildBillDetailRow(
                                    'Water',
                                    transaction.wTotal ?? '0',
                                    '₱${transaction.wRate}/m³',
                                  ),
                                  if (transaction.wifi != null &&
                                      transaction.wifi != '0.00') ...[
                                    SizedBox(height: 12.h),
                                    _buildBillDetailRow(
                                      'WiFi',
                                      transaction.wifi ?? '0',
                                      'Monthly',
                                    ),
                                  ],
                                  SizedBox(height: 12.h),
                                  _buildBillDetailRow(
                                    'Rent',
                                    transaction.monthlyRate ?? '0',
                                    'Monthly',
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    height: 1,
                                    color: AppColors.divider,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildBillDetailRow(
                                    'Total Due',
                                    '${transaction.totalDue}',
                                    '',
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailRow(
    String title,
    String amount,
    String rate, {
    bool isTotal = false,
  }) {
    // Calculate consumption if rate is available
    String consumptionText = '';
    if (rate.contains('/kWh') || rate.contains('/m³')) {
      final total = double.tryParse(amount) ?? 0;
      final rateValue =
          double.tryParse(rate.replaceAll(RegExp(r'[₱/kWhm³]'), '')) ?? 1;
      if (rateValue > 0) {
        final consumption = total / rateValue;
        final unit = rate.contains('/kWh') ? 'kWh' : 'm³';
        consumptionText = '${consumption.toStringAsFixed(2)} $unit';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.subheading.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '₱ ${MoneyFormatter(amount: double.tryParse(amount) ?? 0).output.nonSymbol}',
              style: AppTextStyles.body.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              rate,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            if (consumptionText.isNotEmpty)
              Text(
                consumptionText,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class BuildMonthBillCard extends StatelessWidget {
  const BuildMonthBillCard({
    super.key,
    required this.currentUnit,
    required this.currentUser,
    required this.currentBill,
  });

  final String? currentUnit;
  final CurrentUserModel? currentUser;
  final MonthBillModel currentBill;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<BillsProvider>(context, listen: false).isLoading;
    if (isLoading) {
      return const BillCardShimmer();
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getPadding(context),
        vertical: ResponsiveHelper.getSpacing(context) * 0.25,
      ),
      child: Container(
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
        // Before it was wrapped in a Card, now it is not
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context),
            ),
          ),
          // showTrailingIcon: false,
          title: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSpacing(context) * 0.25,
              vertical: ResponsiveHelper.getSpacing(context) * 0.17,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(
                          DateTime.parse(
                            currentBill.date ??
                                DateTime.now().toIso8601String(),
                          ),
                        ),
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(context) * 0.33,
                      ),
                      Text(
                        'Total Due',
                        style: AppTextStyles.body.copyWith(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            mobileSize: 16.0,
                            tablet7Size: 17.0,
                            tablet10Size: 18.0,
                            largeTabletSize: 19.0,
                          ),
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(context) * 0.17,
                      ),
                      Text(
                        '₱ ${MoneyFormatter(amount: double.tryParse(currentBill.totalDue ?? '0') ?? 0).output.nonSymbol}',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
                SizedBox(
                  width: ResponsiveHelper.isTablet(context) ? 160.0.w : 100.0.w,
                  height: ResponsiveHelper.isTablet(context) ? 96.0.h : 38.0.h,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(context),
                        ),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getSpacing(context) * 0.25,
                      ),
                    ),
                    onPressed: () {
                      // Handle Gcash payment
                    },
                    icon: Icon(
                      Icons.account_balance_wallet,
                      size: ResponsiveHelper.isTablet(context) ? 24.sp : 18.sp,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Pay GCash',
                      style: AppTextStyles.buttonText.copyWith(
                        fontSize:
                            ResponsiveHelper.isTablet(context) ? 16.sp : 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getCardPaddingValue(context),
                vertical: ResponsiveHelper.getSpacing(context) * 0.25,
              ),
              child: Column(
                children: [
                  // Electricity Row
                  _buildUtilityRow(
                    context,
                    label: 'Electricity',
                    rate: '₱ ${currentBill.eRate ?? '0'}/kWh',
                    amount: currentBill.eTotal ?? '0',
                    showConsumption: true,
                    total: double.tryParse(currentBill.eTotal ?? '0') ?? 0,
                    rateValue: double.tryParse(currentBill.eRate ?? '1') ?? 1,
                    unit: 'kWh',
                  ),
                  // Water Row
                  _buildUtilityRow(
                    context,
                    label: 'Water',
                    rate:
                        '₱ ${MoneyFormatter(amount: double.tryParse(currentBill.wRate ?? '0') ?? 0).output.nonSymbol}/m³',
                    amount: currentBill.wTotal ?? '0',
                    showConsumption: true,
                    total: double.tryParse(currentBill.wTotal ?? '0') ?? 0,
                    rateValue: double.tryParse(currentBill.wRate ?? '1') ?? 1,
                    unit: 'm³',
                  ),
                  // WiFi Row (conditional)
                  if (currentUser?.wifi == 'Y')
                    _buildUtilityRow(
                      context,
                      label: 'WiFi',
                      rate: 'Monthly',
                      amount: currentBill.wifi ?? '0',
                      showConsumption: false,
                    ),
                  // Rent Row
                  _buildUtilityRow(
                    context,
                    label: 'Rent',
                    rate: 'Monthly',
                    amount: currentBill.monthlyRate ?? '0',
                    showConsumption: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityRow(
    BuildContext context, {
    required String label,
    required String rate,
    required String amount,
    required bool showConsumption,
    double total = 0,
    double rateValue = 1,
    String unit = '',
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getSpacing(context) * 0.25,
      ),
      child: Row(
        children: [
          // Left side - Label and Rate
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.subheading.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 16.0,
                      tablet7Size: 17.0,
                      tablet10Size: 18.0,
                      largeTabletSize: 19.0,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.17),
                Text(
                  rate,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 14.0,
                      tablet7Size: 15.0,
                      tablet10Size: 16.0,
                      largeTabletSize: 17.0,
                    ),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Right side - Amount and Consumption
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₱ ${MoneyFormatter(amount: double.tryParse(amount) ?? 0).output.nonSymbol}',
                  style: AppTextStyles.body.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(
                      context,
                      mobileSize: 16.0,
                      tablet7Size: 17.0,
                      tablet10Size: 18.0,
                      largeTabletSize: 19.0,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showConsumption) ...[
                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.17),
                  Text(
                    () {
                      if (rateValue > 0) {
                        final consumption = total / rateValue;
                        return '${consumption.toStringAsFixed(2)} $unit';
                      }
                      return '0.00 $unit';
                    }(),
                    style: AppTextStyles.caption.copyWith(
                      fontSize: ResponsiveHelper.getFontSize(
                        context,
                        mobileSize: 12.0,
                        tablet7Size: 13.0,
                        tablet10Size: 14.0,
                        largeTabletSize: 15.0,
                      ),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
