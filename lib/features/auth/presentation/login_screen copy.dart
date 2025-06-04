// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service copy.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../bills/presentation/bills_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('RQ Balay Tracker', style: AppTextStyles.heading),
              const SizedBox(height: 32),
              AppInputField(
                hint: 'Username / Room Number',
                controller: _inputController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a username or room number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Login',
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _handleLogin(context);
                  }
                  _inputController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    String input = _inputController.text.trim();
    String userName = '_';
    int roomNum = 0;

    AppLogger.w("User Name Controller: $input");

    if (int.tryParse(input) != null) {
      int temp = int.parse(input);
      roomNum = (temp > 0 && temp < 1000) ? temp : 0;
      userName = ''; // empty string instead of "_"
    } else if (RegExp(r"^[a-zA-Z\s']+$").hasMatch(input)) {
      userName = input.trim();
      roomNum = 0;
    }

    AppLogger.d(
      "Attempting login with - userName: $userName, roomNum: $roomNum",
    );

    var response = await ApiService.login(userName, roomNum);
    AppLogger.d("Login response: $response");

    try {
      // First clear any existing unit
      await UnitSharedPref.clearUnit();

      if (response != null && response['unit'] != null) {
        String unit = response['unit'].toString();
        if (unit.isNotEmpty) {
          AppLogger.d("Saving unit: $unit");
          await UnitSharedPref.saveUnit(unit);
          AppLogger.w(
            "Unit saved to SharedPreferences: $unit and type is ${unit.runtimeType}",
          );
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BillsScreen()),
            );
          }
        } else {
          AppLogger.e("Login failed - Empty unit in response");
          Fluttertoast.showToast(
            msg: "Incorrect Username / Room Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        AppLogger.e("Login failed - No unit in response");
        Fluttertoast.showToast(
          msg: "Incorrect Username / Room Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      AppLogger.e("Error in login process: $e");
    }
  }
}

bool isValidRoomNumber(String input) {
  // First check if it's a valid number
  if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
    return false;
  }

  // Then check the range
  int? number = int.tryParse(input);
  if (number == null) {
    return false;
  }

  // Room numbers should be between 1 and 999
  return number > 0 && number < 1000;
}
