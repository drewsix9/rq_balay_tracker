import 'package:shared_preferences/shared_preferences.dart';

import '../../features/landing_page/model/hourly_kwh_consump_model/hourly_kwh_consump_model.dart';

class HourlyKwhConsumSharedPref {
  static const String _hourlyKwhConsumKey = 'hourlyKwhConsum';

  static Future<void> saveHourlyKwhConsum(
    HourlyKwhConsumpModel hourlyKwhConsump,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hourlyKwhConsumKey, hourlyKwhConsump.toJson());
  }

  static Future<HourlyKwhConsumpModel?> getHourlyKwhConsum() async {
    final prefs = await SharedPreferences.getInstance();
    final hourlyKwhConsum = prefs.getString(_hourlyKwhConsumKey);
    if (hourlyKwhConsum == null || hourlyKwhConsum.isEmpty) {
      return null;
    }
    return HourlyKwhConsumpModel.fromJson(hourlyKwhConsum);
  }

  static Future<void> clearHourlyKwhConsum() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hourlyKwhConsumKey);
  }
}
