// lib/core/services/api_service.dart
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      var request = {'tpl': 'app_login', 'userName': userName};

      Response response = await Dio().post(
        'http://balay.quisumbing.net/app/mobile.cf',
        data: request,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      AppLogger.d("Response status code: ${response.statusCode}");
      AppLogger.d("Response data: ${response.data}");
      AppLogger.d("Response data type: ${response.data.runtimeType}");

      CurrentUser currentUser = CurrentUser.fromMap(response.data);
      AppLogger.d("Current user: ${currentUser.unit}");
      AppLogger.d("Current user type: ${currentUser.unit.runtimeType}");

      if (currentUser.unit != null) {
        SharedPreferences.getInstance().then((value) {
          value.setString('unit', currentUser.unit!);
        });
      }
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BillsScreen()),
          );
        }
        return response.data;
      } else {
        AppLogger.e("Login failed: ${response.data}");
        throw Exception('Login failed: ${response.data}');
      }
    } catch (e) {
      AppLogger.e("Network error: $e");
      throw Exception('Network error: $e');
    }
  }
}
