// lib/features/bills/presentation/bills_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

import '../../../core/global/current_user.dart';
import '../../../core/providers/bills_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../profile/presentation/side_panel.dart';
import '../data/month_bill.dart';
import 'widgets/shimmer_card.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  static final List<Map<String, dynamic>> transactions = [
    {
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'amount': 2300.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 60)),
      'amount': 2100.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 90)),
      'amount': 2000.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 120)),
      'amount': 1900.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 150)),
      'amount': 1800.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 180)),
      'amount': 1700.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 210)),
      'amount': 1600.00,
      'isPaid': true,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 240)),
      'amount': 1500.00,
      'isPaid': true,
    },
  ];

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BillsProvider>(context, listen: false).getCurrentMonthBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bills',
          style: AppTextStyles.subheading.copyWith(
            color: Colors.white,
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
        actions: [
          Consumer<BillsProvider>(
            builder: (context, billsProvider, child) {
              return IconButton(
                icon: Icon(Icons.refresh, color: Colors.white, size: 24.sp),
                onPressed:
                    billsProvider.isLoading
                        ? null
                        : () => billsProvider.reloadMonthBill(),
              );
            },
          ),
        ],
      ),
      drawer: SidePanel(),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<BillsProvider>(
              builder: (context, billsProvider, child) {
                if (billsProvider.isLoading) {
                  return Center(child: ShimmerCard());
                }

                final currentBill = billsProvider.currentBill;
                if (currentBill == null) {
                  return const Expanded(
                    child: Center(child: Text('No bill data available')),
                  );
                }

                return BuildMonthBillCard(
                  currentUnit: billsProvider.currentUnit,
                  currentUser: billsProvider.currentUser,
                  currentBill: currentBill,
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction History',
                      style: AppTextStyles.subheading.copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 12.h),
                    if (BillsScreen.transactions.isEmpty)
                      Center(
                        child: Text(
                          'No pending payments',
                          style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: BillsScreen.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = BillsScreen.transactions[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: ListTile(
                                title: Text(
                                  DateFormat('MMMM d, yyyy').format(
                                    DateTime.parse(
                                      transaction['date'].toString(),
                                    ),
                                  ),
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₱${MoneyFormatter(amount: double.parse(transaction['amount'].toString())).output.nonSymbol}',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            transaction['isPaid'] != null
                                                ? AppColors.success
                                                : AppColors.warning,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        transaction['isPaid'] != null
                                            ? 'Paid'
                                            : 'Pending',
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
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
          ],
        ),
      ),
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.black, width: 1.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(
                          DateTime.parse(
                            currentBill.date ??
                                DateTime.now().toIso8601String(),
                          ),
                        ),
                        style: AppTextStyles.subheading.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Total Due',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'PHP ${MoneyFormatter(amount: double.tryParse(currentBill.totalDue ?? '0') ?? 0).output.nonSymbol}',
                        style: AppTextStyles.heading.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 120.w,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 2,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      onPressed: () {
                        // Handle Gcash payment
                      },
                      icon: Icon(
                        Icons.account_balance_wallet,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Pay GCash',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Electricity',
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '₱${currentBill.eRate ?? '0'}/kWh',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Water',
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '₱${MoneyFormatter(amount: double.tryParse(currentBill.wRate ?? '0') ?? 0).output.nonSymbol}/m³',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (currentUser?.wifi == 'Y')
                          SizedBox(
                            height: 60.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'WiFi',
                                  style: AppTextStyles.subheading.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Monthly',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 60.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Rent',
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Monthly',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 60.h,
                          child: Center(
                            child: Text(
                              '₱${MoneyFormatter(amount: double.tryParse(currentBill.eTotal ?? '0') ?? 0).output.nonSymbol}',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60.h,
                          child: Center(
                            child: Text(
                              '₱${MoneyFormatter(amount: double.tryParse(currentBill.wTotal ?? '0') ?? 0).output.nonSymbol}',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (currentUser?.wifi == 'Y')
                          SizedBox(
                            height: 60.h,
                            child: Center(
                              child: Text(
                                '₱${MoneyFormatter(amount: double.tryParse(currentBill.wifi ?? '0') ?? 0).output.nonSymbol}',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 60.h,
                          child: Center(
                            child: Text(
                              '₱${MoneyFormatter(amount: double.tryParse(currentBill.monthlyRate ?? '0') ?? 0).output.nonSymbol}',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
