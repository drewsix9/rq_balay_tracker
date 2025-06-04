// lib/features/profile/presentation/side_panel.dart
import 'package:flutter/material.dart';
import 'package:rq_balay_tracker/core/logger/app_logger.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../auth/presentation/login_screen.dart';

class SidePanel extends StatelessWidget {
  // Mock data - replace with actual user data
  final Map<String, dynamic> userData = {
    'userName': '303',
    'name': 'Maria Santos Cruz',
    'phoneNumber': '+63 917 123 4567',
    'email': 'maria.cruz@gmail.com',
    'address': 'Room 303, RQ Balay Dormitory',
    'moveInDate': 'January 15, 2024',
    'contractEnd': 'December 15, 2024',
  };

  SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with room number
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            color: AppColors.primaryBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room ${userData['userName']}',
                  style: AppTextStyles.heading.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  userData['name'],
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          // Profile Information
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProfileSection(),
                const Divider(height: 32),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile Information', style: AppTextStyles.subheading),
        const SizedBox(height: 16),
        _buildInfoRow('Full Name', userData['name']),
        _buildInfoRow('Phone', userData['phoneNumber']),
        _buildInfoRow('Email', userData['email']),
        _buildInfoRow('Room', userData['userName']),
        _buildInfoRow('Address', userData['address']),
        _buildInfoRow('Move-in Date', userData['moveInDate']),
        _buildInfoRow('Contract End', userData['contractEnd']),
      ],
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
          AppLogger.i("Unit cleared from SharedPreferences");
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
