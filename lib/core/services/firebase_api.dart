import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../logger/app_logger.dart';
import '../usecases/fcm_token_shared_pref.dart';
import '../usecases/unit_shared_pref.dart';
import 'api_service.dart';
import 'device_info_service.dart';

class FirebaseApi {
  static final FirebaseApi _instance = FirebaseApi._();
  NotificationSettings? _settings;
  FirebaseApi._();

  static FirebaseApi get instance => _instance;
  NotificationSettings? get settings => _settings;

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await requestPermission();
    await _handleFCMToken();
  }

  Future<void> requestPermission() async {
    _settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (Platform.isAndroid) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Show notification as popup
        badge: true, // Show badge on app icon
        sound: true, // Play sound
      );
    }
    AppLogger.d('Notification settings: ${_settings?.authorizationStatus}');
  }

  Future<void> _handleFCMToken() async {
    // Get initial token
    final fcmToken = await _firebaseMessaging.getToken();
    AppLogger.d('FCM Token: $fcmToken');

    if (fcmToken != null) {
      await FCMTokenSharedPref.saveFCMToken(fcmToken);
      AppLogger.d('FCM Token saved to SharedPreferences');
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      AppLogger.d('FCM Token refreshed: $newToken');
      final unit = await UnitSharedPref.getUnit();
      final deviceInfo = await getDeviceInfo();
      AppLogger.w("Device Info: $deviceInfo");
      if (unit != null && unit.toString().isNotEmpty) {
        await ApiService.insertFcmToken(
          unit: unit,
          token: newToken,
          deviceUuid: deviceInfo['device_uuid'] ?? '',
          deviceName: deviceInfo['device_name'] ?? '',
        );
      }
      await FCMTokenSharedPref.saveFCMToken(newToken);
      AppLogger.d('New FCM Token saved to SharedPreferences');
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    AppLogger.d('Firebase Background Message: $message');
  }
}
