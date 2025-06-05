// lib/features/profile/presentation/side_panel.dart
import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/logger/app_logger.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../auth/presentation/login_screen.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header with room number
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
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
                          ),
                        ),
                        const SizedBox(height: 4),
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
                padding: const EdgeInsets.all(16),
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
                  const Divider(height: 32),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
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
              Text('Profile Information', style: AppTextStyles.subheading),
              const SizedBox(height: 16),
              _buildInfoRow('Name', (user.name)),
              _buildInfoRow(
                'Phone',
                (user.mobileno?.isEmpty ?? true) ? 'N/A' : user.mobileno!,
              ),
              _buildInfoRow(
                'Email',
                (user.email?.isEmpty ?? true) ? 'N/A' : user.email!,
              ),
              _buildInfoRow('Move-in Date', user.startDate),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.muted),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Handle logout
          UnitSharedPref.clearUnit();
          UserSharedPref.clearCurrentUser();
          AppLogger.i("Unit and User cleared from SharedPreferences");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ); // Close drawer
          // Add your logout logic here
        },
        child: Text('Logout', style: AppTextStyles.buttonText),
      ),
    );
  }
}
