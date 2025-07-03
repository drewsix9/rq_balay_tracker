import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/core/widgets/app_button.dart';

import '../../viewmodel/edit_profile_dialog_provider.dart';

class EditProfileDialog extends StatefulWidget {
  final CurrentUserModel? user;
  final Future<void> Function({String? phone, String? email, String? password})
  onSave;

  const EditProfileDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late EditProfileDialogProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<EditProfileDialogProvider>(
        context,
        listen: false,
      );
      _provider.initializeControllers(widget.user);
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileDialogProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: true,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 500.w,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                    spreadRadius: 0,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryBlueGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Profile',
                                style: AppTextStyles.heading.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Update your contact information',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _handleClose(provider),
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Phone Number Section
                            _buildSectionHeader(
                              'Contact Information',
                              Icons.phone,
                            ),
                            SizedBox(height: 16.h),
                            _buildInputField(
                              controller: provider.phoneController,
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) => provider.validatePhone(),
                              errorText: provider.phoneError,
                            ),
                            SizedBox(height: 20.h),

                            // Email Section
                            _buildInputField(
                              controller: provider.emailController,
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) => provider.validateEmail(),
                              errorText: provider.emailError,
                            ),
                            SizedBox(height: 24.h),

                            // Password Section
                            _buildSectionHeader('Security', Icons.lock),
                            SizedBox(height: 16.h),
                            _buildInputField(
                              controller: provider.passwordController,
                              label: 'New Password',
                              hint: 'Enter new password',
                              icon: Icons.lock_outline,
                              obscureText: provider.obscurePassword,
                              onChanged: (value) {
                                provider.setPasswordChanged(value.isNotEmpty);
                                provider.validatePassword();
                              },
                              errorText: provider.passwordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  provider.obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: provider.togglePasswordVisibility,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildInputField(
                              controller: provider.confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Confirm your new password',
                              icon: Icons.lock_outline,
                              obscureText: provider.obscureConfirmPassword,
                              onChanged:
                                  (value) => provider.validateConfirmPassword(),
                              errorText: provider.confirmPasswordError,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  provider.obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textMuted,
                                ),
                                onPressed:
                                    provider.toggleConfirmPasswordVisibility,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (provider.isPasswordChanged)
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16.sp,
                                      color: AppColors.primaryBlue,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        'Password must be at least 6 characters long',
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 12.sp,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _handleCancel(provider),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(color: AppColors.border),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Consumer<EditProfileDialogProvider>(
                            builder: (context, value, child) {
                              return AppButton(
                                label: value.isLoading ? 'Saving...' : 'Save',
                                isLoading: value.isLoading,
                                onPressed: () => _handleSave(value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: AppColors.primaryBlue),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: AppTextStyles.heading.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? errorText,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          onChanged: onChanged,
          style: AppTextStyles.body.copyWith(
            fontSize: 16.sp,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body.copyWith(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
            prefixIcon: Icon(icon, size: 20.sp, color: AppColors.textMuted),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              errorText,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.sp,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  void _handleSave(EditProfileDialogProvider provider) async {
    // Validate all fields first
    provider.validateAllFields();

    if (provider.isFormValid) {
      // Set loading state to true
      provider.setLoading(true);

      try {
        final formData = provider.getFormData();
        await widget.onSave(
          phone: formData['phone'],
          email: formData['email'],
          password: formData['password'],
        );

        // Check if the parent widget is still loading
        if (!provider.isLoading && context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Handle any errors here if needed
        print('Error saving profile: $e');
      } finally {
        // Set loading state to false
        provider.setLoading(false);
        Navigator.of(context).pop();
      }
    }
  }

  void _handleCancel(EditProfileDialogProvider provider) {
    // Reset controllers before closing
    provider.initializeControllers(widget.user);
    Navigator.of(context).pop();
  }

  void _handleClose(EditProfileDialogProvider provider) {
    // Reset controllers before closing
    provider.initializeControllers(widget.user);
    Navigator.of(context).pop();
  }
}
