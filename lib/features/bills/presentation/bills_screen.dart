// lib/features/bills/presentation/bills_screen.dart
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../profile/presentation/side_panel.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual data from your backend
    final latestBill = {
      'total': 2500.00,
      'electricity': 1200.00,
      'water': 800.00,
      'wifi': 500.00,
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'isPaid': false,
    };

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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: SidePanel(),
      body: Column(
        children: [
          // Latest Bill Card (Fixed at top)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latest Bill', style: AppTextStyles.subheading),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: AppTextStyles.body),
                        Text(
                          '₱${(latestBill['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                          style: AppTextStyles.subheading.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildUtilityRow(
                      'Electricity',
                      '₱${(latestBill['electricity'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    _buildUtilityRow(
                      'Water',
                      '₱${(latestBill['water'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    _buildUtilityRow(
                      'WiFi',
                      '₱${(latestBill['wifi'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Due Date: ${_formatDate(latestBill['dueDate'] as DateTime)}',
                      style: AppTextStyles.muted,
                    ),
                    const SizedBox(height: 16),
                    if (latestBill['isPaid'] == false)
                      AppButton(
                        label: 'Pay with GCash',
                        onPressed: () {
                          // Handle GCash payment
                        },
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Paid', style: AppTextStyles.buttonText),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Transaction History (Scrollable)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transaction History', style: AppTextStyles.subheading),
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
                                _formatDate(transaction['date'] as DateTime),
                                style: AppTextStyles.body,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₱${(transaction['amount'] as num).toStringAsFixed(2)}',
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
