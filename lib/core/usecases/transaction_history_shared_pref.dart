import 'package:shared_preferences/shared_preferences.dart';

import '../../features/bills/data/transaction_history_model.dart';

class TransactionHistorySharedPref {
  static const String _key = 'transaction_history';

  static Future<void> saveTransactionHistory(
    TransactionHistoryModel history,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, history.toJson());
    } catch (e) {
      rethrow;
    }
  }

  static Future<TransactionHistoryModel?> getTransactionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return null;
      return TransactionHistoryModel.fromJson(jsonString);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearTransactionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      rethrow;
    }
  }
}
