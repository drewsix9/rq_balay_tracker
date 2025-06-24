import 'package:shared_preferences/shared_preferences.dart';

import '../../features/landing_page/model/hourly_kwh_consump_model/list_reading_pair_model.dart';
import '../../features/landing_page/model/hourly_kwh_consump_model/reading_pair_model.dart';

class ListReadingPairSharedPref {
  static const String _listReadingPairKey = 'listReadingPair';

  static Future<void> saveListReadingPair(
    List<ReadingPair> listReadingPair,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _listReadingPairKey,
      ListReadingPairModel(listReadingPair: listReadingPair).toJson(),
    );
  }

  static Future<List<ReadingPair>> getListReadingPair() async {
    final prefs = await SharedPreferences.getInstance();
    final listReadingPair = prefs.getString(_listReadingPairKey);
    if (listReadingPair == null || listReadingPair.isEmpty) {
      return [];
    }
    return ListReadingPairModel.fromJson(listReadingPair).listReadingPair;
  }

  static Future<void> clearListReadingPair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listReadingPairKey);
  }
}
