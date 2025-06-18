import 'package:shared_preferences/shared_preferences.dart';

import '../logger/app_logger.dart';

class FCMTokenSharedPref {
  static const String _fcmTokenKey = 'fcm_token';

  /// Get the stored FCM token
  static Future<String?> getFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_fcmTokenKey);
    } catch (e) {
      AppLogger.e("Error getting FCM token from SharedPreferences: $e");
      return null;
    }
  }

  /// Save the FCM token
  static Future<bool> saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_fcmTokenKey, token);
    } catch (e) {
      AppLogger.e("Error saving FCM token to SharedPreferences: $e");
      return false;
    }
  }

  /// Clear the stored FCM token
  static Future<bool> clearFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_fcmTokenKey);
    } catch (e) {
      AppLogger.e("Error clearing FCM token from SharedPreferences: $e");
      return false;
    }
  }

  /// Check if FCM token exists
  static Future<bool> hasFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_fcmTokenKey);
    } catch (e) {
      AppLogger.e("Error checking FCM token in SharedPreferences: $e");
      return false;
    }
  }
}
