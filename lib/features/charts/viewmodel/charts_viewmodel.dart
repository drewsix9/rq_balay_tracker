import 'package:flutter/foundation.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/usecases/electricity_consumption_shared_pref.dart';
import '../../bills/data/month_bill_model.dart';
import '../model/electricity_consumption.dart';
import '../model/month_total_model.dart';
import '../model/usage_trend_model.dart';

class ChartsViewModel extends ChangeNotifier {
  MonthTotalModel? _monthTotal;
  UsageTrendModel? _usageTrend;
  bool _isLoading = false;
  ElectricityConsumptionChartModel? _electricityChartModel;

  MonthTotalModel? get monthTotal => _monthTotal;
  UsageTrendModel? get usageTrend => _usageTrend;
  bool get isLoading => _isLoading;
  ElectricityConsumptionChartModel? get electricityChartModel =>
      _electricityChartModel;

  void initialize(List<MonthBillModel> bills) async {
    try {
      _isLoading = true;
      notifyListeners();

      _monthTotal = MonthTotalModel.fromMonthBills(bills);
      _usageTrend = UsageTrendModel.fromMonthBills(bills);
      _electricityChartModel = ElectricityConsumptionChartModel.fromMonthBills(
        bills,
      );
      await _saveElectricityChartModel();
    } catch (e) {
      debugPrint('Error calculating month total: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveElectricityChartModel() async {
    try {
      if (_electricityChartModel != null) {
        await ElectricityConsumptionSharedPref.saveElectricityChartModel(
          _electricityChartModel!,
        );
      }
    } catch (e) {
      AppLogger.e('Error saving electricity chart model: $e');
    }
  }

  void testLoading() {
    _isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  void clear() {
    _monthTotal = null;
    _usageTrend = null;
    notifyListeners();
  }
}
