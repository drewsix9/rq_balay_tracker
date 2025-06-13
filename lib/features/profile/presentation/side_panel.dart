// lib/features/profile/presentation/side_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rq_balay_tracker/core/logger/app_logger.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/month_bill_shared_pref.dart';
import '../../../core/usecases/transaction_history_shared_pref.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../auth/presentation/login_screen.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 0,
      child: Column(
        children: [
          // Header with room number
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
            color: AppColors.primaryBlue,
            child: FutureBuilder(
              future: UserSharedPref.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  final user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room ${user.unit}',
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Text(
                      //   user.name,
                      //   style: AppTextStyles.body.copyWith(
                      //     color: Colors.white.withOpacity(0.8),
                      //   ),
                      // ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Profile Information
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                FutureBuilder(
                  future: _buildProfileSection(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return snapshot.data ?? const SizedBox.shrink();
                  },
                ),
                Divider(height: 32.h),
                LogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> _buildProfileSection() async {
    return FutureBuilder(
      future: UserSharedPref.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Information',
                style: AppTextStyles.subheading.copyWith(fontSize: 20.sp),
              ),
              SizedBox(height: 16.h),
              InfoRow(label: 'Name', value: user.name),
              InfoRow(
                label: 'Phone',
                value:
                    (user.mobileno?.isEmpty ?? true) ? 'N/A' : user.mobileno!,
              ),
              InfoRow(
                label: 'Email',
                value: (user.email?.isEmpty ?? true) ? 'N/A' : user.email!,
              ),
              InfoRow(label: 'Move-in Date', value: user.startDate),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (label) {
      case 'Name':
        icon = Icons.person;
        break;
      case 'Phone':
        icon = Icons.phone;
        break;
      case 'Email':
        icon = Icons.email;
        break;
      case 'Move-in Date':
        icon = Icons.calendar_today;
        break;
      default:
        icon = Icons.info;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: AppColors.primaryBlue),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.muted.copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () {
          // Handle logout
          UnitSharedPref.clearUnit();
          UserSharedPref.clearCurrentUser();
          MonthBillSharedPref.clearMonthBill();
          TransactionHistorySharedPref.clearTransactionHistory();
          AppLogger.i("Unit and User cleared from SharedPreferences");
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        },
        child: Text(
          'Logout',
          style: AppTextStyles.buttonText.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }
}
