import 'package:flutter/foundation.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/usecases/electricity_consumption_shared_pref.dart';
import '../../../core/usecases/water_consumption_shared_pref.dart';
import '../../bills/data/month_bill_model.dart';
import '../model/electricity_consumption.dart';
import '../model/month_total_model.dart';
import '../model/usage_trend_model.dart';
import '../model/water_consumption_chart_model.dart';

class ChartsViewModel extends ChangeNotifier {
  MonthTotalModel? _monthTotal;
  UsageTrendModel? _usageTrend;
  bool _isLoading = false;
  ElectricityConsumptionChartModel? _electricityChartModel;
  WaterConsumptionChartModel? _waterChartModel;

  MonthTotalModel? get monthTotal => _monthTotal;
  UsageTrendModel? get usageTrend => _usageTrend;
  bool get isLoading => _isLoading;
  ElectricityConsumptionChartModel? get electricityChartModel =>
      _electricityChartModel;
  WaterConsumptionChartModel? get waterChartModel => _waterChartModel;

  Future<void> initialize(List<MonthBillModel> bills) async {
    try {
      _isLoading = true;
      notifyListeners();

      // First try to load cached chart data for immediate display
      final cachedElectricityModel =
          await ElectricityConsumptionSharedPref.getElectricityChartModel();
      final cachedWaterModel =
          await WaterConsumptionSharedPref.getWaterChartModel();

      // Use cached data initially if available
      if (cachedElectricityModel != null) {
        _electricityChartModel = cachedElectricityModel;
        notifyListeners();
      }
      if (cachedWaterModel != null) {
        _waterChartModel = cachedWaterModel;
        notifyListeners();
      }

      // Calculate models that always need fresh data
      _monthTotal = MonthTotalModel.fromMonthBills(bills);
      _usageTrend = UsageTrendModel.fromMonthBills(bills);

      // Calculate fresh chart data
      final freshElectricityModel =
          ElectricityConsumptionChartModel.fromMonthBills(bills);
      final freshWaterModel = WaterConsumptionChartModel.fromMonthBills(bills);

      // Update models with fresh data
      _electricityChartModel = freshElectricityModel;
      _waterChartModel = freshWaterModel;

      // Save fresh data to SharedPreferences
      await _saveElectricityChartModel();
      await _saveWaterChartModel();

      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating month total: $e');
      // Re-throw the error to be handled by the caller
      throw Exception('Failed to initialize charts: $e');
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

  Future<void> _saveWaterChartModel() async {
    try {
      if (_waterChartModel != null) {
        await WaterConsumptionSharedPref.saveWaterChartModel(_waterChartModel!);
      }
    } catch (e) {
      AppLogger.e('Error saving water chart model: $e');
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
