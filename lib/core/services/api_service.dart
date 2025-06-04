// lib/core/services/api_service.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/bills/presentation/bills_screen.dart';
import '../global/current_user.dart';
import '../logger/app_logger.dart';

class ApiService {
  static const String baseUrl = 'https://epostalhub.shop';

  static Future<Map<String, dynamic>?> login(
    String userName,
    BuildContext context,
  ) async {
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
        CurrentUser currentUser = CurrentUser.fromMap(jsonResponse);
        AppLogger.d("Created user with unit: ${currentUser.unit}");

        if (currentUser.unit != null) {
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('unit', currentUser.unit!);
            AppLogger.d("Saved unit to SharedPreferences: ${currentUser.unit}");
          } catch (e) {
            AppLogger.e("Error saving to SharedPreferences: $e");
            throw Exception('Error saving to SharedPreferences: $e');
          }
        }
        if (response.statusCode == 200) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BillsScreen()),
            );
          }
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
