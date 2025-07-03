import 'package:flutter/material.dart';

import '../../../core/global/current_user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/user_shared_pref.dart';

class ProfileScreenViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  CurrentUserModel? _currentUser;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  CurrentUserModel? get currentUser => _currentUser;

  Future<void> getCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await UserSharedPref.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? phone,
    String? email,
    String? password,
    BuildContext? context,
  }) async {
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
