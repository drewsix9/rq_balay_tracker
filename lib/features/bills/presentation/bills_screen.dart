// lib/features/bills/presentation/bills_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../../core/global/current_user.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/month_bill_shared_pref.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../profile/presentation/side_panel.dart';
import '../data/month_bill.dart';
import 'widgets/shimmer_card.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  String? currentUnit;
  CurrentUserModel? currentUser;
  @override
  void initState() {
    super.initState();
    _getCurrentMonthBill();
  }

  Future<void> _getCurrentMonthBill() async {
    try {
      currentUnit = await UnitSharedPref.getUnit();
      setState(() {}); // Trigger rebuild after getting currentUnit
    } catch (e) {
      AppLogger.d('Error getting unit: $e');
    }
    try {
      currentUser = await UserSharedPref.getCurrentUser();
    } catch (e) {
      AppLogger.d('Error getting user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = [
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

      // Add more transactions as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bills',
          style: AppTextStyles.subheading.copyWith(color: Colors.white),
        ),

        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: SidePanel(),
      body: SafeArea(
        child: Column(
          children: [
            // Latest Bill Card (Fixed at top)
            _buildMonthBillCard(
              currentUnit: currentUnit,
              currentUser: currentUser,
            ),
            // Transaction History (Scrollable)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction History',
                      style: AppTextStyles.subheading,
                    ),
                    const SizedBox(height: 16),
                    if (transactions.isEmpty)
                      Center(
                        child: Text(
                          'No pending payments',
                          style: AppTextStyles.muted,
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(
                                  DateFormat('MMMM d, yyyy').format(
                                    DateTime.parse(
                                      transaction['date'].toString(),
                                    ),
                                  ),
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₱${MoneyFormatter(amount: double.parse(transaction['amount'].toString())).output.nonSymbol}',
                                      style: AppTextStyles.body,
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            transaction['isPaid'] != null
                                                ? AppColors.success
                                                : AppColors.warning,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        transaction['isPaid'] != null
                                            ? 'Paid'
                                            : 'Pending',
                                        style: AppTextStyles.body.copyWith(
                                          color: Colors.white,
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

  Widget _buildUtilityRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(amount, style: AppTextStyles.body),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _buildMonthBillCard extends StatelessWidget {
  const _buildMonthBillCard({
    super.key,
    required this.currentUnit,
    required this.currentUser,
  });

  final String? currentUnit;
  final CurrentUserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.black, width: 1.5),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future:
              currentUnit == null
                  ? Future.value(null)
                  : Future.delayed(const Duration(milliseconds: 1500), () {
                    return ApiService.getMonthBill(currentUnit!);
                  }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerCard();
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }
            try {
              MonthBillSharedPref.saveMonthBill(MonthBill.fromMap(data));
            } catch (e) {
              AppLogger.d('Error saving month bill: $e');
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Date, Amount, Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month/Year
                        Text(
                          DateFormat(
                            'MMMM yyyy',
                          ).format(DateTime.parse(data['date'])),
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(height: 12),
                        // Amount label
                        Text(
                          'Total Due',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        // Amount
                        Text(
                          'PHP ${MoneyFormatter(amount: double.parse(data['totalDue'])).output.nonSymbol}',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),

                        // (Optional) Due date
                        SizedBox(height: 24),
                        // Pay GCash Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 120,
                            height: 38,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                              ),
                              onPressed: () {
                                // Handle Gcash payment
                              },
                              icon: Icon(
                                Icons.account_balance_wallet,
                                size: 16,
                                color: Colors.white,
                              ), // GCash-like icon
                              label: Text(
                                'Pay GCash',
                                style: AppTextStyles.buttonText.copyWith(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Text(
                        //   'Due: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(data['date']))}',
                        //   style: AppTextStyles.caption.copyWith(
                        //     fontSize: 12,
                        //     color: Colors.red[400],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Right side: kWh, Water, Wifi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Electricity Section
                        Text(
                          'Electricity',
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Rate:',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Text(
                                    '₱${data['eRate']}/kWh',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total:',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Text(
                                    '₱${MoneyFormatter(amount: double.parse(data['eTotal'])).output.nonSymbol}',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),

                        // Water Section
                        Text(
                          'Water',
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Rate:',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Text(
                                    '₱${MoneyFormatter(amount: double.parse(data['wRate'])).output.nonSymbol}/m³',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total:',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Text(
                                    '₱${MoneyFormatter(amount: double.parse(data['wTotal'])).output.nonSymbol}',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),

                        // WiFi Section
                        (currentUser?.wifi == '1'
                            ? Text(
                              'WiFi',
                              style: AppTextStyles.subheading.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : SizedBox.shrink()),
                        (currentUser?.wifi == '1'
                            ? SizedBox(height: 4)
                            : SizedBox.shrink()),
                        (currentUser?.wifi == '1'
                            ? Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Total:',
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  Text(
                                    '₱${MoneyFormatter(amount: double.parse(data['wifi'])).output.nonSymbol}',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : SizedBox.shrink()),
                        (currentUser?.wifi == '1'
                            ? SizedBox(height: 12)
                            : SizedBox.shrink()),

                        // Monthly Rate Section
                        Text(
                          'Rent',
                          style: AppTextStyles.subheading.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total:',
                                  style: AppTextStyles.caption,
                                ),
                              ),
                              Text(
                                '₱${MoneyFormatter(amount: double.parse(data['monthlyRate'])).output.nonSymbol}',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
