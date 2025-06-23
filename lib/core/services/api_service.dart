// lib/core/services/api_service.dart
// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../features/bills/data/transaction_history_model.dart';
import '../logger/app_logger.dart';

class ApiService {
  static const String baseUrl = 'balay.quisumbing.net';

  static Future<Map<String, dynamic>?> login(
    String roomId,
    String password,
  ) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http
          .post(
            url,
            body: {'tpl': 'app_login', 'room_id': roomId, 'password': password},
          )
          .timeout(
            const Duration(seconds: 10), // Add timeout
            onTimeout: () {
              throw TimeoutException('Connection timed out');
            },
          );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        AppLogger.e("Login failed: $jsonResponse");
        throw Exception('Login failed: $jsonResponse');
      }
    } on TimeoutException {
      AppLogger.e("Connection timed out");
      throw Exception(
        'Connection timed out. Please check your internet connection.',
      );
    } on SocketException {
      AppLogger.e("No internet connection");
      throw Exception(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>?> biometricLogin(String unit) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http
          .post(url, body: {'tpl': 'app_biometric_login', 'unit': unit})
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Connection timed out');
            },
          );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        AppLogger.e("Biometric login failed: $jsonResponse");
        throw Exception('Biometric login failed: $jsonResponse');
      }
    } on TimeoutException {
      AppLogger.e("Connection timed out");
      throw Exception(
        'Connection timed out. Please check your internet connection.',
      );
    } on SocketException {
      AppLogger.e("No internet connection");
      throw Exception(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getMonthBill(String unit) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http.post(
        url,
        body: {'tpl': 'app_month_bill', 'unit': unit},
      );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      try {
        if (response.statusCode == 200) {
          return jsonResponse;
        } else {
          AppLogger.e("Login failed: $jsonResponse");
          throw Exception('Login failed: $jsonResponse');
        }
      } catch (e) {
        AppLogger.e("Error processing user data: $e");
        throw Exception('Error processing user data: $e');
      }
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<TransactionHistoryModel> getTransactionHistory(
    String unit,
  ) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http.post(
        url,
        body: {'tpl': 'app_bill_history', 'unit': unit},
      );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      try {
        if (response.statusCode == 200) {
          return TransactionHistoryModel.fromJson(response.body);
        } else {
          AppLogger.e("Login failed: $jsonResponse");
          throw Exception('Login failed: $jsonResponse');
        }
      } catch (e) {
        AppLogger.e("Error processing user data: $e");
        throw Exception('Error processing user data: $e');
      }
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>?> insertFcmToken({
    required String unit,
    required String token,
    required String deviceUuid,
    String? deviceName,
  }) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http
          .post(
            url,
            body: {
              'tpl': 'app_fcm_token',
              'unit': unit,
              'token': token,
              'device_uuid': deviceUuid,
              'device_name': deviceName,
            },
          )
          .timeout(
            const Duration(seconds: 10), // Add timeout
            onTimeout: () {
              throw TimeoutException('Connection timed out');
            },
          );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        AppLogger.e("Save FCM Token failed: $jsonResponse");
        throw Exception('Save FCM Token failed: $jsonResponse');
      }
    } on TimeoutException {
      AppLogger.e("Connection timed out");
      throw Exception(
        'Connection timed out. Please check your internet connection.',
      );
    } on SocketException {
      AppLogger.e("No internet connection");
      throw Exception(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getTodaykWhConsump({
    required String unit,
  }) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http
          .post(url, body: {'tpl': 'app_today_consump', 'room_id': unit})
          .timeout(
            const Duration(seconds: 10), // Add timeout
            onTimeout: () {
              throw TimeoutException('Connection timed out');
            },
          );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        AppLogger.e("Get Today kWh Consumption failed: $jsonResponse");
        throw Exception('Get Today kWh Consumption failed: $jsonResponse');
      }
    } on TimeoutException {
      AppLogger.e("Connection timed out");
      throw Exception(
        'Connection timed out. Please check your internet connection.',
      );
    } on SocketException {
      AppLogger.e("No internet connection");
      throw Exception(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>?> getDailykWhConsump({
    required String unit,
    required String month,
    required String year,
  }) async {
    try {
      var url = Uri.http(baseUrl, 'app/mobile.cf');
      var response = await http
          .post(
            url,
            body: {
              'tpl': 'app_daily_consump',
              'room_id': unit,
              'month': month,
              'year': year,
            },
          )
          .timeout(
            const Duration(seconds: 10), // Add timeout
            onTimeout: () {
              throw TimeoutException('Connection timed out');
            },
          );

      AppLogger.d("Response (http) status: ${response.statusCode}");
      AppLogger.d("Response (http) body: ${response.body}");

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body);
        AppLogger.d("Decoded response: $jsonResponse");
      } catch (e) {
        AppLogger.e("Error decoding JSON: $e");
        throw Exception('Error decoding JSON: $e');
      }

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        AppLogger.e("Get Daily kWh Consumption failed: $jsonResponse");
        throw Exception('Get Daily kWh Consumption failed: $jsonResponse');
      }
    } on TimeoutException {
      AppLogger.e("Connection timed out");
      throw Exception(
        'Connection timed out. Please check your internet connection.',
      );
    } on SocketException {
      AppLogger.e("No internet connection");
      throw Exception(
        'No internet connection. Please check your network settings.',
      );
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }
}
