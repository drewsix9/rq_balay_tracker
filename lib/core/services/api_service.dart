// lib/core/services/api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../logger/app_logger.dart';

class ApiService {
  static const String baseUrl = 'https://epostalhub.shop';

  static Future<Map<String, dynamic>?> login(String userName) async {
    try {
      var url = Uri.http('balay.quisumbing.net', 'app/mobile.cf');
      var response = await http.post(
        url,
        body: {'tpl': 'app_login', 'userName': userName},
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

  static Future<Map<String, dynamic>?> getMonthBill(String unit) async {
    try {
      var url = Uri.http('balay.quisumbing.net', 'app/mobile.cf');
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

  static Future<Map<String, dynamic>?> getTransactionHistory(
    String unit,
  ) async {
    try {
      var url = Uri.http('balay.quisumbing.net', 'app/mobile.cf');
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
}
