import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/core/widgets/app_button.dart';

class EditProfileDialog extends StatefulWidget {
  final CurrentUserModel? user;
  final bool isLoading;
  final Future<void> Function({String? phone, String? email, String? password})
  onSave;

  const EditProfileDialog({
    super.key,
    required this.user,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  String? phone;
  String? email;
  String? password;
  String? confirmPassword;

  @override
  void initState() {
    super.initState();
    phone = widget.user?.mobileno;
    email = widget.user?.email;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      title: Text('Edit Profile', style: AppTextStyles.heading),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
                onSaved: (value) => phone = value,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                ),
                obscureText: true,
                onChanged: (value) => password = value,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                ),
                obscureText: true,
                validator: (value) {
                  if (password != null && password!.isNotEmpty) {
                    if (value != password) {
                      return 'Passwords do not match';
                    }
                  }
                  return null;
                },
                onChanged: (value) => confirmPassword = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Save',
          isLoading: widget.isLoading,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop();
              await widget.onSave(
                phone: phone,
                email: email,
                password: password,
              );
            }
          },
        ),
      ],
    );
  }
}
