import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rq_balay_tracker/core/global/current_user_model.dart';
import 'package:rq_balay_tracker/core/theme/app_colors.dart';
import 'package:rq_balay_tracker/core/theme/app_text_styles.dart';
import 'package:rq_balay_tracker/core/usecases/user_shared_pref.dart';
import 'package:rq_balay_tracker/features/auth/presentation/login_screen.dart';
import 'package:rq_balay_tracker/features/profile/presentation/widgets/edit_profile_dialog.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../../../core/usecases/month_bill_shared_pref.dart';
import '../../../core/usecases/transaction_history_shared_pref.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CurrentUserModel? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserSharedPref.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _updateProfile({
    String? phone,
    String? email,
    String? password,
  }) async {
    setState(() => _isLoading = true);
    try {
      await ApiService.updateProfile(
        unit: _currentUser?.unit ?? '',
        phone: phone ?? _currentUser?.mobileno ?? '',
        email: email ?? _currentUser?.email ?? '',
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_currentUser != null) {
            _currentUser = _currentUser!.copyWith(
              mobileno: phone ?? _currentUser!.mobileno,
              email: email ?? _currentUser!.email,
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logout() {
    UserSharedPref.clearCurrentUser();
    MonthBillSharedPref.clearMonthBill();
    TransactionHistorySharedPref.clearTransactionHistory();
    AppLogger.i(
      "Unit, User, and Transaction History cleared from SharedPreferences",
    );
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => EditProfileDialog(
                    user: user,
                    isLoading: _isLoading,
                    onSave: _updateProfile,
                  ),
            );
          },
          tooltip: 'Edit Profile',
        ),
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: -1,
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar placeholder
                    Center(
                      child: CircleAvatar(
                        radius: 40.r,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        child: Text(
                          (user != null && user.name.isNotEmpty)
                              ? user.name
                                  .trim()
                                  .split(' ')
                                  .map((e) => e.isNotEmpty ? e[0] : '')
                                  .take(2)
                                  .join()
                                  .toUpperCase()
                              : '',
                          style: AppTextStyles.heading.copyWith(
                            color: AppColors.primaryBlue,
                            fontSize: 32.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      user?.name ?? '',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.meeting_room,
                          size: 20.sp,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Unit: ',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user?.unit ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 20.sp,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Monthly Rate: ',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '₱${user?.monthlyRate ?? ''}',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi,
                          size: 20.sp,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'WiFi: ',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (user != null &&
                            user.wifi.isNotEmpty &&
                            user.wifi.toLowerCase() == 'y')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1FADF),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              'Available',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: const Color(0xFF039855),
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE4E2),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              'Unavailable',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: const Color(0xFFB42318),
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20.sp,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Mobile: ',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user?.mobileno ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          size: 20.sp,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Email: ',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user!.email?.isEmpty ?? true
                              ? 'N/A'
                              : user.email ?? '',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (user.startDate.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                            color: AppColors.primaryBlue,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Start: ',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(DateTime.parse(user.startDate)),
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
