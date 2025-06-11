import 'package:intl/intl.dart';

import '../../bills/data/month_bill_model.dart';

class MonthTotalModel {
  final double totalAmount;
  final double trendPercentage;
  final double lastMonthTotal;
  final bool isPositive;

  MonthTotalModel({
    required this.totalAmount,
    required this.trendPercentage,
    required this.lastMonthTotal,
    required this.isPositive,
  });

  factory MonthTotalModel.fromMonthBills(List<MonthBillModel> bills) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    // Calculate current month's total
    final currentMonthTotal = bills
        .where((bill) {
          if (bill.date == null) return false;
          final billDate = DateTime.parse(bill.date!);
          return billDate.year == currentMonth.year &&
              billDate.month == currentMonth.month;
        })
        .fold<double>(0, (sum, bill) {
          final waterTotal = double.tryParse(bill.wTotal ?? '0') ?? 0;
          final electricityTotal = double.tryParse(bill.eTotal ?? '0') ?? 0;
          return sum + waterTotal + electricityTotal;
        });

    // Calculate last month's total
    final lastMonthTotal = bills
        .where((bill) {
          if (bill.date == null) return false;
          final billDate = DateTime.parse(bill.date!);
          return billDate.year == lastMonth.year &&
              billDate.month == lastMonth.month;
        })
        .fold<double>(0, (sum, bill) {
          final waterTotal = double.tryParse(bill.wTotal ?? '0') ?? 0;
          final electricityTotal = double.tryParse(bill.eTotal ?? '0') ?? 0;
          return sum + waterTotal + electricityTotal;
        });

    // Calculate trend percentage
    double trendPercentage = 0;
    if (lastMonthTotal > 0) {
      trendPercentage =
          ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
    }

    return MonthTotalModel(
      totalAmount: currentMonthTotal,
      trendPercentage: trendPercentage,
      lastMonthTotal: lastMonthTotal,
      isPositive:
          trendPercentage <= 0, // Negative trend is positive for utility bills
    );
  }

  String get formattedTotal =>
      NumberFormat.currency(symbol: '₱', decimalDigits: 2).format(totalAmount);

  String get formattedLastMonthTotal => NumberFormat.currency(
    symbol: '₱',
    decimalDigits: 2,
  ).format(lastMonthTotal);

  String get formattedTrend =>
      '${trendPercentage >= 0 ? '+' : ''}${trendPercentage.toStringAsFixed(1)}%';
}
