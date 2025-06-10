// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/global/current_user_model.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input_field.dart';
import '../../../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'RQ Balay Tracker',
                      style: AppTextStyles.heading.copyWith(fontSize: 32.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
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
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Login',
                        isLoading: _isLoading,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isLoading = true);
                            await _handleLogin(context);
                            setState(() => _isLoading = false);
                          }
                          _userNameController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String userName = _userNameController.text.trim();
    AppLogger.w("User Name Controller: $userName");
    final response = await ApiService.login(userName);

    if (response!['unit'].toString().isNotEmpty) {
      UnitSharedPref.saveUnit(response['unit']);
      UserSharedPref.saveCurrentUser(CurrentUserModel.fromMap(response));

      AppLogger.w("User saved to SharedPreferences: ${response['name']}");
      AppLogger.w(
        "Unit saved to SharedPreferences: ${response['unit']} and type is ${response['unit'].runtimeType}",
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
        fontSize: 16.sp,
      );
    }
  }
}
