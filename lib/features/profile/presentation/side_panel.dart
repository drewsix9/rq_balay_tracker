// lib/features/profile/presentation/side_panel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_provider.dart';

class SidePanel extends StatelessWidget {
  // Mock data - replace with actual user data
  final Map<String, dynamic> userData = {
    'roomNumber': '101',
    'name': 'John Doe',
    'phoneNumber': '+63 912 345 6789',
    'email': 'john.doe@email.com',
  };

  SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.user;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
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
                      'Room ${userData['roomNumber']}',
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.white,
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
      },
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile Information', style: AppTextStyles.subheading),
        const SizedBox(height: 16),
        _buildInfoRow('Name', userData['name']),
        _buildInfoRow('Phone', userData['phoneNumber']),
        _buildInfoRow('Email', userData['email']),
        _buildInfoRow('Room', userData['roomNumber']),
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
          Navigator.pop(context); // Close drawer
          // Add your logout logic here
        },
        child: Text('Logout', style: AppTextStyles.buttonText),
      ),
    );
  }
}
