// lib/features/auth/presentation/login_screen.dart
import 'dart:async';
import 'dart:io'; // Import for SocketException

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:rq_balay_tracker/home_screen.dart';

import '../../../core/global/current_user_model.dart';
import '../../../core/logger/app_logger.dart';
import '../../../core/providers/biometric_provider.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/device_info_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/usecases/fcm_token_shared_pref.dart';
import '../../../core/usecases/unit_shared_pref.dart';
import '../../../core/usecases/user_shared_pref.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BiometricProvider>(context, listen: false).initialize();
    });
  }

  void _showErrorSnackBar(String title, String message) {
    if (!mounted) return;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _handleBiometricLogin() async {
    final biometricProvider = Provider.of<BiometricProvider>(
      context,
      listen: false,
    );

    if (!biometricProvider.isDeviceSupported) {
      _showErrorSnackBar(
        'Not Supported',
        'Biometric authentication is not supported on this device.',
      );
      return;
    }

    if (!biometricProvider.canCheckBiometrics) {
      _showErrorSnackBar(
        'Not Available',
        'No biometrics are available on this device.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bool authenticated = await biometricProvider
          .authenticateWithBiometrics(
            localizedReason: 'Please authenticate to login',
          );

      if (authenticated && mounted) {
        // Get the cached unit ID
        final cachedUnitId = await UnitSharedPref.getUnit();
        if (cachedUnitId != null) {
          // Verify if the cached unit ID still exists in the database
          final response = await ApiService.biometricLogin(cachedUnitId);
          if (response != null && response['unit'].toString().isNotEmpty) {
            // Update the current user data
            UserSharedPref.saveCurrentUser(CurrentUserModel.fromMap(response));

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          } else {
            _showErrorSnackBar(
              'Invalid Session',
              'Your session has expired. Please login manually.',
            );
            // Clear invalid cached data
            await UnitSharedPref.clearUnit();
            await UserSharedPref.clearCurrentUser();
          }
        } else {
          _showErrorSnackBar(
            'No Saved Session',
            'Please login manually first to enable biometric login.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Authentication Error', e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Balay RQ',
                        style: AppTextStyles.heading.copyWith(fontSize: 32.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      AppInputField(
                        hint: 'Username / Room Number',
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a username or room number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Login',
                          isLoading: _isLoading,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() => _isLoading = true);
                              await _handleLogin(context);
                              setState(() => _isLoading = false);
                            }
                            _passwordController.clear();
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Consumer<BiometricProvider>(
                        builder: (context, biometricProvider, child) {
                          if (!biometricProvider.isDeviceSupported ||
                              !biometricProvider.canCheckBiometrics) {
                            return const SizedBox.shrink();
                          }

                          // Get the first available biometric type
                          final biometricType =
                              biometricProvider.availableBiometrics.isNotEmpty
                                  ? biometricProvider.availableBiometrics.first
                                  : null;

                          return Center(
                            child: Container(
                              width: 64.w,
                              height: 64.w,
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
                              child: IconButton(
                                onPressed:
                                    _isLoading ? null : _handleBiometricLogin,
                                icon:
                                    _isLoading
                                        ? SizedBox(
                                          width: 48.w,
                                          height: 48.h,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryBlue,
                                                ),
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : Image.asset(
                                          biometricType == BiometricType.face
                                              ? 'lib/core/images/face-id.png'
                                              : 'lib/core/images/fingerprint.png',
                                          width: 48.w,
                                          height: 48.h,
                                          color: AppColors.primaryBlue,
                                        ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String password = _passwordController.text.trim();
    AppLogger.w("User Name Controller: $password");

    try {
      final response = await ApiService.login(password);
      var unit = response!['unit'];
      if (unit != null && unit.toString().isNotEmpty) {
        // Cache only the unit ID
        UnitSharedPref.saveUnit(unit);
        // Save current user data
        UserSharedPref.saveCurrentUser(CurrentUserModel.fromMap(response));
        // Save FCM Token to database
        final deviceInfo = await getDeviceInfo();
        AppLogger.w("Device Info: $deviceInfo");
        final token = await FCMTokenSharedPref.getFCMToken();
        if (token != null && token.toString().isNotEmpty) {
          await ApiService.insertFcmToken(
            unit: unit,
            token: token,
            deviceUuid: deviceInfo['device_uuid'] ?? '.',
            deviceName: deviceInfo['device_name'] ?? '',
          );
        }

        AppLogger.w("User saved to SharedPreferences: ${response['name']}");
        AppLogger.w(
          "Unit saved to SharedPreferences: ${response['unit']} and type is ${response['unit'].runtimeType}",
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        _showErrorSnackBar('Login Failed', 'Incorrect Username / Room Number');
      }
    } on SocketException {
      _showErrorSnackBar(
        'Connection Error',
        'No internet connection. Please check your network settings.',
      );
    } on TimeoutException {
      _showErrorSnackBar(
        'Timeout Error',
        'Connection timed out. Please check your internet connection.',
      );
    } catch (e) {
      _showErrorSnackBar('Error', 'An error occurred: $e');
    }
  }
}
