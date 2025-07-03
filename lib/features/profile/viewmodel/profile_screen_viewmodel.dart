import 'package:flutter/material.dart';

import '../../../core/global/current_user_model.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/user_shared_pref.dart';

class ProfileScreenViewmodel extends ChangeNotifier {
  bool _isLoading = true;
  CurrentUserModel? _currentUser;
  String? _error;

  bool get isLoading => _isLoading;
  CurrentUserModel? get currentUser => _currentUser;
  String? get error => _error;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    _setError(null);
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _currentUser = await UserSharedPref.getCurrentUser();
    } catch (e) {
      _setError('Failed to load user profile: $e');
      AppLogger.e('Error getting current user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? phone,
    String? email,
    String? password,
    BuildContext? context,
  }) async {
    _setError(null);
    setIsLoading(true);
    try {
      await ApiService.updateProfile(
        unit: _currentUser?.unit ?? '',
        phone: phone ?? _currentUser?.mobileno ?? '',
        email: email ?? _currentUser?.email ?? '',
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));
      if (context!.mounted) {
        if (_currentUser != null) {
          _currentUser = _currentUser!.copyWith(
            mobileno: phone ?? _currentUser!.mobileno,
            email: email ?? _currentUser!.email,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Profile updated successfully',
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      _setError('Failed to update profile: $e');
      if (context!.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (context!.mounted) setIsLoading(false);
    }
  }
}
