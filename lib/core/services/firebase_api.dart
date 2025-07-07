import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../home_screen.dart';
import '../logger/app_logger.dart';
import '../usecases/fcm_token_shared_pref.dart';
import '../usecases/unit_shared_pref.dart';
import '../usecases/user_shared_pref.dart';
import 'api_service.dart';
import 'device_info_service.dart';

class FirebaseApi {
  static final FirebaseApi _instance = FirebaseApi._();
  NotificationSettings? _settings;
  FirebaseApi._();

  static FirebaseApi get instance => _instance;
  NotificationSettings? get settings => _settings;

  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await _initializeLocalNotifications();
    await requestPermission();
    await _handleFCMToken();
    await _setupForegroundMessageHandler();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    }

    AppLogger.d('Local notifications initialized');
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

  Future<void> _setupForegroundMessageHandler() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AppLogger.d('Firebase Foreground Message: ${message.messageId}');
      await _showLocalNotification(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.d('Firebase Message Opened: $message');
      handleNotificationTap(null, message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final AndroidNotificationDetails
      androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@drawable/ic_notification',
        color: const Color(0xFF2196F3),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: const BigTextStyleInformation(''),
      );

      final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
      );

      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Extract notification data
      final String title =
          message.notification?.title ??
          message.data['title'] ??
          'New Notification';
      final String body =
          message.notification?.body ??
          message.data['body'] ??
          'You have a new message';

      // Show the notification
      await _localNotifications.show(
        message.hashCode, // Use message hash as notification ID
        title,
        body,
        notificationDetails,
        payload: message.data.toString(), // Pass data as payload
      );

      AppLogger.d('Local notification shown: $title - $body');
    } catch (e) {
      AppLogger.e('Error showing local notification: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.d('Local notification tapped: ${response.payload}');

    // Parse the payload and handle navigation
    if (response.payload != null) {
      // You can parse the payload and handle navigation here
      // For now, we'll use a simple approach
      handleNotificationTap(null, RemoteMessage());
    }
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

  Future<void> handleNotificationTap(
    BuildContext? context,
    RemoteMessage message,
  ) async {
    final page = message.data['page'];
    if (page == 'bills') {
      if (context != null && !context.mounted) return;
      final user = await UserSharedPref.getCurrentUser();
      final Widget nextScreen =
          (user != null) ? const HomeScreen() : const LoginScreen();
      if (context != null && context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    AppLogger.d('Firebase Background Message: $message');
    // Background messages are handled automatically by the system
    // No need to show local notifications here as they're handled by FCM
  }

  // Method to clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
    AppLogger.d('All notifications cleared');
  }

  // Method to cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    AppLogger.d('Notification cancelled: $id');
  }

  // Test method to show a local notification
  Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            color: Color(0xFF2196F3),
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            styleInformation: BigTextStyleInformation(''),
          );

      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      await _localNotifications.show(
        999, // Test notification ID
        'Test Notification',
        'This is a test notification to verify local notifications are working!',
        notificationDetails,
        payload: 'test_notification',
      );

      AppLogger.d('Test notification shown successfully');
    } catch (e) {
      AppLogger.e('Error showing test notification: $e');
    }
  }
}
