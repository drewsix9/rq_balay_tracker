import 'package:shared_preferences/shared_preferences.dart';

import '../logger/app_logger.dart';

class UnitSharedPref {
  static const String _unitKey = 'unit';

  /// Get the stored unit value
  static Future<String?> getUnit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_unitKey);
    } catch (e) {
      AppLogger.e("Error getting unit from SharedPreferences: $e");
      return null;
    }
  }

  /// Save the unit value
  static Future<bool> saveUnit(String unit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_unitKey, unit);
    } catch (e) {
      AppLogger.e("Error saving unit to SharedPreferences: $e");
      return false;
    }
  }

  /// Clear the stored unit value
  static Future<bool> clearUnit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_unitKey);
    } catch (e) {
      AppLogger.e("Error clearing unit from SharedPreferences: $e");
      return false;
    }
  }

  /// Check if unit exists
  static Future<bool> hasUnit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_unitKey);
    } catch (e) {
      AppLogger.e("Error checking unit in SharedPreferences: $e");
      return false;
    }
  }
}
