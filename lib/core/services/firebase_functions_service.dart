import 'package:cloud_functions/cloud_functions.dart';

import '../logger/app_logger.dart';

class FirebaseFunctionsService {
  static final FirebaseFunctionsService _instance =
      FirebaseFunctionsService._();
  FirebaseFunctionsService._();
  static FirebaseFunctionsService get instance => _instance;

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Test Firebase Functions connection
  Future<Map<String, dynamic>> testFirebaseFunctions({String? message}) async {
    try {
      AppLogger.d('Testing Firebase Functions connection...');

      final HttpsCallable callable = _functions.httpsCallable(
        'testFirebaseFunctions',
      );

      final result = await callable.call({
        'message': message ?? 'Hello from Flutter app!',
        'timestamp': DateTime.now().toIso8601String(),
      });

      AppLogger.d('Firebase Functions test successful: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      AppLogger.e('Error testing Firebase Functions: $e');
      rethrow;
    }
  }

  // Test Firebase Functions without authentication
  Future<Map<String, dynamic>> testFirebaseFunctionsPublic({
    String? message,
  }) async {
    try {
      AppLogger.d('Testing public Firebase Functions connection...');

      final HttpsCallable callable = _functions.httpsCallable(
        'testFirebaseFunctionsPublic',
      );

      final result = await callable.call({
        'message': message ?? 'Hello from Flutter app (public)!',
        'timestamp': DateTime.now().toIso8601String(),
      });

      AppLogger.d('Public Firebase Functions test successful: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      AppLogger.e('Error testing public Firebase Functions: $e');
      rethrow;
    }
  }

  // Calculate electricity consumption
  Future<Map<String, dynamic>> calculateElectricityConsumption({
    required double currentReading,
    required double previousReading,
    required String unitId,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'calculateElectricityConsumption',
      );

      final result = await callable.call({
        'currentReading': currentReading,
        'previousReading': previousReading,
        'unitId': unitId,
      });

      AppLogger.d('Function result: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      AppLogger.e('Error calling calculateElectricityConsumption: $e');
      rethrow;
    }
  }

  // Generate monthly bill
  Future<Map<String, dynamic>> generateMonthlyBill({
    required String unitId,
    required int month,
    required int year,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable(
        'generateMonthlyBill',
      );

      final result = await callable.call({
        'unitId': unitId,
        'month': month,
        'year': year,
      });

      AppLogger.d('Bill generation result: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      AppLogger.e('Error calling generateMonthlyBill: $e');
      rethrow;
    }
  }
}
