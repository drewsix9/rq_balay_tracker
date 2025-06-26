import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';

class EditProfileDialogProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordChanged = false;

  // Validation state tracking
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isPasswordChanged => _isPasswordChanged;

  // Validation error getters
  String? get phoneError => _phoneError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // Check if form is valid
  bool get isFormValid =>
      _phoneError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setPasswordChanged(bool changed) {
    _isPasswordChanged = changed;
    // Re-validate password fields when password change state changes
    validatePassword();
    validateConfirmPassword();
    notifyListeners();
  }

  void initializeControllers(CurrentUserModel? user) {
    phoneController.text = user?.mobileno ?? '';
    emailController.text = user?.email ?? '';
    passwordController.clear();
    confirmPasswordController.clear();
    _isPasswordChanged = false;
    _obscurePassword = true;
    _obscureConfirmPassword = true;

    // Clear validation errors
    _phoneError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;

    notifyListeners();
  }

  // Real-time validation methods
  void validatePhone() {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      _phoneError = 'Phone number is required';
    } else if (!phoneNumber.startsWith('09')) {
      _phoneError = 'Phone number must start with "09"';
    } else if (phoneNumber.length != 11) {
      _phoneError = 'Phone number must be exactly 11 digits';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      _phoneError = 'Phone number must contain only digits';
    } else {
      _phoneError = null;
    }

    notifyListeners();
  }

  void validateEmail() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _emailError = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _emailError = 'Enter a valid email address';
    } else {
      _emailError = null;
    }

    notifyListeners();
  }

  void validatePassword() {
    String password = passwordController.text;

    if (_isPasswordChanged) {
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }
    } else {
      _passwordError = null;
    }

    // Also validate confirm password when password changes
    validateConfirmPassword();
    notifyListeners();
  }

  void validateConfirmPassword() {
    String confirmPassword = confirmPasswordController.text;

    if (_isPasswordChanged) {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (confirmPassword != passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    } else {
      _confirmPasswordError = null;
    }

    notifyListeners();
  }

  // Validate all fields at once
  void validateAllFields() {
    validatePhone();
    validateEmail();
    validatePassword();
    validateConfirmPassword();
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    validateAllFields();
    return isFormValid;
  }

  Map<String, String?> getFormData() {
    return {
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'password':
          passwordController.text.isNotEmpty ? passwordController.text : null,
    };
  }
}
