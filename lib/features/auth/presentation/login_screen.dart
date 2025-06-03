// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
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
                    /*try {
                      final roomNumber = _roomNumberController.text.trim();
                      await ApiService.login(roomNumber, context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }*/
                    final roomNumber = _roomNumberController.text.trim();
                    await ApiService.login(roomNumber, context);
                  }

                  _roomNumberController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
