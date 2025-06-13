import '../../../features/bills/data/month_bill_model.dart';

class WaterConsumptionChartModel {
  final List<double> consumptions;
  final List<String> rYear;
  final List<String> rMonth;

  WaterConsumptionChartModel(this.consumptions, this.rYear, this.rMonth);

  Map<String, dynamic> toJson() {
    return {'consumptions': consumptions, 'rYear': rYear, 'rMonth': rMonth};
  }

  factory WaterConsumptionChartModel.fromJson(Map<String, dynamic> json) {
    return WaterConsumptionChartModel(
      json['consumptions'],
      json['rYear'],
      json['rMonth'],
    );
  }

  factory WaterConsumptionChartModel.fromMonthBills(
    List<MonthBillModel> bills,
  ) {
    final rYear = bills.map((b) => b.rYear ?? '').toList();
    final rMonth = bills.map((b) => b.rMonth ?? '').toList();

    final consumptions =
        bills.map((b) {
          final total = double.tryParse(b.wTotal ?? '0') ?? 0;
          final rate = double.tryParse(b.wRate ?? '1') ?? 1;
          return rate > 0
              ? double.parse((total / rate).toStringAsFixed(2))
              : 0.0;
        }).toList();
    return WaterConsumptionChartModel(consumptions, rYear, rMonth);
  }
}
