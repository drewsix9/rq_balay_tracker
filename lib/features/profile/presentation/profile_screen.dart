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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.logout,
                  size: 24.sp,
                  color: const Color(0xFFEF4444),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Confirm Logout',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout? You will need to login again to access your account.',
            style: AppTextStyles.body.copyWith(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Logout',
                style: AppTextStyles.body.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
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
                  (context) =>
                      EditProfileDialog(user: user, onSave: _updateProfile),
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
            onPressed: _showLogoutConfirmation,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header Card
              Container(
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryBlueGradient,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                      spreadRadius: 0,
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24.w),
                margin: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  children: [
                    // Enhanced Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4.w),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                            spreadRadius: 0,
                            color: Colors.black.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          (user != null && user.name.isNotEmpty)
                              ? user.name
                                  .trim()
                                  .split(' ')
                                  .map((e) => e.isNotEmpty ? e[0] : '')
                                  .take(2)
                                  .join()
                                  .toUpperCase()
                              : '?',
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // User Name
                    Text(
                      user?.name ?? 'User Name',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    // Unit Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.meeting_room,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Unit ${user?.unit ?? ''}',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Information Cards
              _buildInfoCard(
                title: 'Account Details',
                icon: Icons.person_outline,
                children: [
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    label: 'Monthly Rate',
                    value: '₱${user?.monthlyRate ?? '0'}',
                    valueColor: AppColors.textPrimary,
                    iconColor: AppColors.primaryBlue,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    icon: Icons.wifi,
                    label: 'WiFi Status',
                    value:
                        user != null &&
                                user.wifi.isNotEmpty &&
                                user.wifi.toLowerCase() == 'y'
                            ? 'Available'
                            : 'Unavailable',
                    valueColor:
                        user != null &&
                                user.wifi.isNotEmpty &&
                                user.wifi.toLowerCase() == 'y'
                            ? const Color(0xFF039855)
                            : const Color(0xFFB42318),
                    iconColor: AppColors.primaryBlue,
                    customValue:
                        user != null &&
                                user.wifi.isNotEmpty &&
                                user.wifi.toLowerCase() == 'y'
                            ? _buildStatusChip('Available', true)
                            : _buildStatusChip('Unavailable', false),
                  ),
                  if (user?.startDate.isNotEmpty ?? false) ...[
                    SizedBox(height: 16.h),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Start Date',
                      value: DateFormat(
                        'MMM dd, yyyy',
                      ).format(DateTime.parse(user!.startDate)),
                      valueColor: AppColors.textPrimary,
                      iconColor: AppColors.primaryBlue,
                    ),
                  ],
                ],
              ),

              SizedBox(height: 16.h),

              _buildInfoCard(
                title: 'Contact Information',
                icon: Icons.contact_phone,
                children: [
                  _buildInfoRow(
                    icon: Icons.phone,
                    label: 'Mobile Number',
                    value: user?.mobileno ?? 'Not provided',
                    valueColor: AppColors.textPrimary,
                    iconColor: AppColors.primaryBlue,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    icon: Icons.email,
                    label: 'Email Address',
                    value:
                        user?.email?.isEmpty ?? true
                            ? 'Not provided'
                            : user!.email ?? '',
                    valueColor: AppColors.textPrimary,
                    iconColor: AppColors.primaryBlue,
                  ),
                ],
              ),

              // Quick Actions Card
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.settings,
                            size: 20.sp,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Quick Actions',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.edit,
                            label: 'Edit Profile',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => EditProfileDialog(
                                      user: user,
                                      onSave: _updateProfile,
                                    ),
                              );
                            },
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.logout,
                            label: 'Logout',
                            onTap: _showLogoutConfirmation,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom padding
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, size: 20.sp, color: AppColors.primaryBlue),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required Color iconColor,
    Widget? customValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        if (customValue != null)
          customValue
        else
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String label, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FADF) : const Color(0xFFFEE4E2),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isActive ? const Color(0xFF039855) : const Color(0xFFB42318),
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.sp, color: Colors.white),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
