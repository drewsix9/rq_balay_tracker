import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/charts/model/water_consumption_chart_model.dart';
import '../logger/app_logger.dart';

class WaterConsumptionSharedPref {
  static const String _waterChartModelKey = 'waterChartModel';

  static Future<void> saveWaterChartModel(
    WaterConsumptionChartModel model,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_waterChartModelKey, json.encode(model.toJson()));
    AppLogger.w("Water chart model saved to SharedPreferences");
  }

  static Future<WaterConsumptionChartModel?> getWaterChartModel() async {
    AppLogger.w("Getting water chart model from SharedPreferences");
    final prefs = await SharedPreferences.getInstance();
    final modelJson = prefs.getString(_waterChartModelKey);
    if (modelJson == null) return null;
    return WaterConsumptionChartModel.fromJson(json.decode(modelJson));
  }

  static Future<void> clearWaterChartModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_waterChartModelKey);
    AppLogger.w("Water chart model cleared from SharedPreferences");
  }
}
