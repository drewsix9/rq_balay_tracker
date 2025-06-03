// lib/core/services/api_service.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../features/bills/presentation/bills_screen.dart';

class ApiService {
  static const String baseUrl = 'https://epostalhub.shop';

  static Future<Map<String, dynamic>?> login(
    String roomNumber,
    BuildContext context,
  ) async {
    try {
      var request = {'tpl': 'app_sample', 'userName': roomNumber};
      /*final response = await http.post(
        Uri.parse('https://epostalhub.shop/app/api.cf?tpl=app_sample'),
      );*/
      Response response = await Dio().post(
        'https://epostalhub.shop/app/api.cf',
        data: request,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print("Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BillsScreen()),
          );
        }
        print("Data: ${response.data}");
        return jsonDecode(response.data);
      } else {
        throw Exception('Login failed: ${response.data}');
      }
    } catch (e) {
      print("sample");
      throw Exception('Network error: $e');
    }
  }
}
