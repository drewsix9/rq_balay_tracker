// lib/features/bills/presentation/bills_screen.dart
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/global/current_user_model.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/providers/bills_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/month_bill_model.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  String? _lastError;

  void _showErrorSnackBar(String title, String message) {
    if (!mounted) return;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillsProvider>(context, listen: false).initialize();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final billsProvider = Provider.of<BillsProvider>(context);
    if (billsProvider.error != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar('Error', billsProvider.error!);
      });
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
      body: SafeArea(
        child: Column(
          children: [
            Consumer<BillsProvider>(
              builder: (context, billsProvider, child) {
                // Handle error state
                if (billsProvider.error != null &&
                    billsProvider.error != _lastError) {
                  _lastError = billsProvider.error;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showErrorSnackBar('Error', billsProvider.error!);
                  });
                }

                final currentBill = billsProvider.currentBill;
                if (currentBill == null) {
                  return const Expanded(
                    child: Center(child: Text('No bill data available')),
                  );
                }
                AppLogger.d('currentBill.paid: ${currentBill.paid}');
                if (currentBill.paid == 'Y') {
                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Skeletonizer(
                      // ignoreContainers: true,
                      enabled:
                          Provider.of<BillsProvider>(
                            context,
                            listen: false,
                          ).isLoading,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: AppColors.surface,
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
                        child: Card(
                          // elevation: 20,
                          color: AppColors.surface,
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Center(
                              child: Text(
                                'No Pending Payment',
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.textPrimary,
                                ),
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
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skeletonizer(
              enabled:
                  Provider.of<BillsProvider>(context, listen: false).isLoading,
              child: Text(
                'Transaction History',
                style: AppTextStyles.subheading.copyWith(fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 12.h),
            Consumer<BillsProvider>(
              builder: (context, provider, child) {
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

                return Expanded(
                  child: Skeletonizer(
                    ignoreContainers: true,
                    enabled:
                        Provider.of<BillsProvider>(
                          context,
                          listen: false,
                        ).isLoading,
                    child: Scrollbar(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () async {
                          try {
                            await Provider.of<BillsProvider>(
                              context,
                              listen: false,
                            ).reload();
                            _refreshController.refreshCompleted();
                          } catch (e) {
                            _refreshController.refreshFailed();
                            _showErrorSnackBar(
                              'Error',
                              'Failed to refresh data',
                            );
                          }
                        },
                        header: ClassicHeader(
                          refreshStyle: RefreshStyle.Follow,
                        ),
                        child: ListView.separated(
                          separatorBuilder:
                              (context, index) => SizedBox(height: 12.h),

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
                                      color: AppColors.navActive.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  tilePadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  backgroundColor: Colors.white,
                                  collapsedBackgroundColor: AppColors.surface,
                                  collapsedIconColor: AppColors.textMuted,
                                  iconColor: AppColors.textMuted,
                                  collapsedTextColor: AppColors.textMuted,
                                  textColor: AppColors.textMuted,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('MMMM d, yyyy').format(
                                          DateTime.parse(
                                            transaction.date ??
                                                DateTime.now().toString(),
                                          ),
                                        ),
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
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
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Text(
                                          transaction.paid == 'Y'
                                              ? 'Paid'
                                              : 'Pending',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Skeletonizer(
        // ignoreContainers: true,
        enabled: Provider.of<BillsProvider>(context, listen: false).isLoading,
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
          // Before it was wrapped in a Card, now it is not
          child: ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            // showTrailingIcon: false,
            title: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 0.w, 8.h),
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
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: AppColors.primaryBlue),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Total Due',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '₱ ${MoneyFormatter(amount: double.tryParse(currentBill.totalDue ?? '0') ?? 0).output.nonSymbol}',
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(fontSize: 28.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 100.w,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                      ),
                      onPressed: () {
                        // Handle Gcash payment
                      },
                      icon: Icon(
                        Icons.account_balance_wallet,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Pay GCash',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 12.sp,
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
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column - Labels and Rates
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUtilityLabel(
                            title: 'Electricity',
                            rate: '₱ ${currentBill.eRate ?? '0'}/kWh',
                          ),
                          _buildUtilityLabel(
                            title: 'Water',
                            rate:
                                '₱ ${MoneyFormatter(amount: double.tryParse(currentBill.wRate ?? '0') ?? 0).output.nonSymbol}/m³',
                          ),
                          if (currentUser?.wifi == 'Y')
                            _buildUtilityLabel(title: 'WiFi', rate: 'Monthly'),
                          _buildUtilityLabel(title: 'Rent', rate: 'Monthly'),
                        ],
                      ),
                    ),
                    // Right column - Amounts and Consumption
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildUtilityAmount(
                            amount: currentBill.eTotal ?? '0',
                            showConsumption: true,
                            total:
                                double.tryParse(currentBill.eTotal ?? '0') ?? 0,
                            rate:
                                double.tryParse(currentBill.eRate ?? '1') ?? 1,
                            unit: 'kWh',
                          ),
                          _buildUtilityAmount(
                            amount: currentBill.wTotal ?? '0',
                            showConsumption: true,
                            total:
                                double.tryParse(currentBill.wTotal ?? '0') ?? 0,
                            rate:
                                double.tryParse(currentBill.wRate ?? '1') ?? 1,
                            unit: 'm³',
                          ),
                          if (currentUser?.wifi == 'Y')
                            _buildUtilityAmount(
                              amount: currentBill.wifi ?? '0',
                              showConsumption: false,
                            ),
                          _buildUtilityAmount(
                            amount: currentBill.monthlyRate ?? '0',
                            showConsumption: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtilityLabel({required String title, required String rate}) {
    return SizedBox(
      height: 60.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.subheading.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            rate,
            style: AppTextStyles.caption.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityAmount({
    required String amount,
    required bool showConsumption,
    double total = 0,
    double rate = 1,
    String unit = '',
  }) {
    return SizedBox(
      height: 60.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '₱ ${MoneyFormatter(amount: double.tryParse(amount) ?? 0).output.nonSymbol}',
            style: AppTextStyles.body.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showConsumption) ...[
            SizedBox(height: 2.h),
            Text(
              () {
                if (rate > 0) {
                  final consumption = total / rate;
                  return '${consumption.toStringAsFixed(2)} $unit';
                }
                return '0.00 $unit';
              }(),
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
