import 'package:shared_preferences/shared_preferences.dart';

import '../../features/bills/data/month_bill_model.dart';
import '../logger/app_logger.dart';

class MonthBillSharedPref {
  static const String _monthBillKey = 'currentMonthBill';

  static Future<void> saveMonthBill(MonthBillModel bill) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_monthBillKey, bill.toJson());
    AppLogger.w("Month bill saved to SharedPreferences");
  }

  static Future<MonthBillModel?> getMonthBill() async {
    AppLogger.w("Getting month bill from SharedPreferences");
    final prefs = await SharedPreferences.getInstance();
    final billJson = prefs.getString(_monthBillKey);
    if (billJson == null) return null;
    return MonthBillModel.fromJson(billJson);
  }

  static Future<void> clearMonthBill() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_monthBillKey);
    AppLogger.w("Month bill cleared from SharedPreferences");
  }
}
