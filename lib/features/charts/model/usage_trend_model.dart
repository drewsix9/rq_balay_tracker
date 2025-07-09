import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/logger/app_logger.dart';

import '../../bills/model/month_bill_model.dart';

class UsageTrendModel {
  final double trendPercentage;
  final bool isPositive;
  final IconData icon;

  UsageTrendModel({
    required this.trendPercentage,
    required this.isPositive,
    required this.icon,
  });

  factory UsageTrendModel.fromMonthBills(List<MonthBillModel> bills) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final lastMonth = DateTime(now.year, now.month - 1);

    // Calculate current month's total consumption
    final currentMonthConsumption = bills
        .where((bill) {
          if (bill.date == null) return false;
          final billDate = DateTime.parse(bill.date!);
          return billDate.year == currentMonth.year &&
              billDate.month == currentMonth.month;
        })
        .fold<double>(0, (sum, bill) {
          final waterConsumption = _calculateWaterConsumption(bill);
          final electricityConsumption = _calculateElectricityConsumption(bill);
          return sum + waterConsumption + electricityConsumption;
        });

    // Calculate last month's total consumption
    final lastMonthConsumption = bills
        .where((bill) {
          if (bill.date == null) return false;
          final billDate = DateTime.parse(bill.date!);
          return billDate.year == lastMonth.year &&
              billDate.month == lastMonth.month;
        })
        .fold<double>(0, (sum, bill) {
          AppLogger.d('bill: ${bill.toJson()}');
          final waterConsumption = _calculateWaterConsumption(bill);
          final electricityConsumption = _calculateElectricityConsumption(bill);
          return sum + waterConsumption + electricityConsumption;
        });

    // Calculate trend percentage
    double trendPercentage = 0;
    if (lastMonthConsumption > 0) {
      trendPercentage =
          ((currentMonthConsumption - lastMonthConsumption) /
              lastMonthConsumption) *
          100;
      AppLogger.d('trendPercentage: $trendPercentage');
      AppLogger.d('currentMonthConsumption: $currentMonthConsumption');
      AppLogger.d('lastMonthConsumption: $lastMonthConsumption');
    }

    // For utility consumption, a negative trend (less consumption) is positive
    final isPositive = trendPercentage <= 0;
    final icon = isPositive ? Icons.trending_down : Icons.trending_up;

    return UsageTrendModel(
      trendPercentage: trendPercentage,
      isPositive: isPositive,
      icon: icon,
    );
  }

  static double _calculateWaterConsumption(MonthBillModel bill) {
    final waterTotal = double.tryParse(bill.wTotal ?? '0') ?? 0;
    final waterRate = double.tryParse(bill.wRate ?? '0') ?? 1;
    return waterRate > 0 ? waterTotal / waterRate : 0;
  }

  static double _calculateElectricityConsumption(MonthBillModel bill) {
    final electricityTotal = double.tryParse(bill.eTotal ?? '0') ?? 0;
    final electricityRate = double.tryParse(bill.eRate ?? '0') ?? 1;
    return electricityRate > 0 ? electricityTotal / electricityRate : 0;
  }

  String get formattedTrend =>
      '${trendPercentage >= 0 ? '+' : ''}${trendPercentage.toStringAsFixed(1)}%';

  String get formattedDescription => 'vs Last Month';
}
