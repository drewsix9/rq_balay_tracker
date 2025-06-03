// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input_field.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();

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
                controller: _roomNumberController,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Login',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Handle login
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
