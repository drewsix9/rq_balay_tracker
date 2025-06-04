// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../bills/presentation/bills_screen.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

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
                controller: _userNameController,
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
                  _userNameController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    String userName = _userNameController.text.trim();
    AppLogger.w("User Name Controller: $userName");
    final response = await ApiService.login(userName);

    if (response!['unit'].toString().isNotEmpty) {
      UnitSharedPref.saveUnit(response['unit']);
      AppLogger.w(
        "Unit saved to SharedPreferences: ${response['unit']} and type is ${response['unit'].runtimeType}",
      );
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BillsScreen()),
        );
      }
    } else {
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
  }
}
