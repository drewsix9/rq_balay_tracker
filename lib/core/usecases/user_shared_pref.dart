import 'package:shared_preferences/shared_preferences.dart';

import '../global/current_user_model.dart';
import '../logger/app_logger.dart';

class UserSharedPref {
  static const String _userKey = 'currentUser';

  static Future<void> saveCurrentUser(CurrentUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user.toJson());
  }

  static Future<CurrentUserModel?> getCurrentUser() async {
    AppLogger.w("Getting current user from SharedPreferences");
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return CurrentUserModel.fromJson(userJson);
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
