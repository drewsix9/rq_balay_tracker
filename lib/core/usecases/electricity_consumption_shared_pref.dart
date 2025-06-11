import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/charts/model/electricity_consumption.dart';
import '../logger/app_logger.dart';

class ElectricityConsumptionSharedPref {
  static const String _electricityChartModelKey = 'electricityChartModel';

  static Future<void> saveElectricityChartModel(
    ElectricityConsumptionChartModel model,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _electricityChartModelKey,
      json.encode(model.toJson()),
    );
    AppLogger.w("Electricity chart model saved to SharedPreferences");
  }

  static Future<ElectricityConsumptionChartModel?>
  getElectricityChartModel() async {
    AppLogger.w("Getting electricity chart model from SharedPreferences");
    final prefs = await SharedPreferences.getInstance();
    final modelJson = prefs.getString(_electricityChartModelKey);
    if (modelJson == null) return null;
    return ElectricityConsumptionChartModel.fromJson(json.decode(modelJson));
  }

  static Future<void> clearElectricityChartModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_electricityChartModelKey);
    AppLogger.w("Electricity chart model cleared from SharedPreferences");
  }
}
