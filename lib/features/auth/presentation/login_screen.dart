// lib/features/auth/presentation/login_screen.dart
import 'dart:async';
import 'dart:io'; // Import for SocketException

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
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/snackbar_utils.dart';
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
  final _roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BiometricProvider>(context, listen: false).initialize();
    });
  }

  Future<void> _handleBiometricLogin() async {
    final biometricProvider = Provider.of<BiometricProvider>(
      context,
      listen: false,
    );

    if (!biometricProvider.isDeviceSupported) {
      SnackBarUtils.showWarning(
        context,
        'Biometric authentication is not supported on this device.',
      );
      return;
    }

    if (!biometricProvider.canCheckBiometrics) {
      SnackBarUtils.showWarning(
        context,
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
              SnackBarUtils.showSuccess(context, 'Biometric Login successful');
              // Navigate after a short delay to allow the snackbar to be visible
              Future.delayed(Duration(milliseconds: 1500), () {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              });
            }
          } else {
            SnackBarUtils.showError(
              context,
              'Your session has expired. Please login manually.',
            );
            // Clear invalid cached data
            await UnitSharedPref.clearUnit();
            await UserSharedPref.clearCurrentUser();
          }
        } else {
          SnackBarUtils.showWarning(
            context,
            'Please login manually first to enable biometric login.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, e.toString());
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
            padding: ResponsiveHelper.getScreenPadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxWidth(context),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title
                    Column(
                      children: [
                        SizedBox(
                          width:
                              ResponsiveHelper.isTablet(context)
                                  ? 200.0.w
                                  : 100.0.w,
                          height:
                              ResponsiveHelper.isTablet(context)
                                  ? 200.0.h
                                  : 100.0.h,
                          child: Image.asset(
                            'lib/core/logo/logo2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context)),
                        Text(
                          'Balay RQ',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: ResponsiveHelper.getHeadingFontSize(
                              context,
                              mobileSize: 24.0,
                              tablet7Size: 28.0,
                              tablet10Size: 32.0,
                              largeTabletSize: 36.0,
                            ),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getSpacing(context) * 0.25,
                        ),
                        Text(
                          'Track your electricity and water consumption',
                          style: AppTextStyles.body.copyWith(
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              mobileSize: 14.0,
                              tablet7Size: 16.0,
                              tablet10Size: 18.0,
                              largeTabletSize: 20.0,
                            ),
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),
                    AppInputField(
                      hint: 'Room Number',
                      controller: _roomIdController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a room number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context) * 0.5,
                    ),
                    AppInputField(
                      isPassword: true,
                      hint: 'Password',
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(context) * 0.5,
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
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String roomId = _roomIdController.text.trim();
    String password = _passwordController.text.trim();
    AppLogger.w("User Name Controller: $password");

    try {
      final response = await ApiService.login(roomId, password);
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
          SnackBarUtils.showSuccess(context, 'Login successful');
          // Navigate after a short delay to allow the snackbar to be visible
          Future.delayed(Duration(milliseconds: 1500), () {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          });
        }
      } else {
        SnackBarUtils.showError(context, 'Incorrect Room Number or Password');
      }
    } on SocketException {
      SnackBarUtils.showError(
        context,
        'No internet connection. Please check your network settings.',
      );
    } on TimeoutException {
      SnackBarUtils.showError(
        context,
        'Connection timed out. Please check your internet connection.',
      );
    } catch (e) {
      SnackBarUtils.showError(context, 'An error occurred: $e');
    }
  }
}
