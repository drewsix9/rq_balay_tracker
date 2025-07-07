import 'dart:async';

import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../logger/app_logger.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _isDeviceSupported = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String? _error;

  bool get isAuthenticating => _isAuthenticating;
  bool get isDeviceSupported => _isDeviceSupported;
  bool get canCheckBiometrics => _canCheckBiometrics;
  List<BiometricType> get availableBiometrics => _availableBiometrics;
  String? get error => _error;

  /// Initialize biometric service and check device support
  Future<void> initialize() async {
    try {
      _error = null;
      _isDeviceSupported = await _auth.isDeviceSupported();
      if (_isDeviceSupported) {
        await _checkBiometrics();
        await _getAvailableBiometrics();
      }
    } catch (e) {
      AppLogger.e('Error initializing biometric service: $e');
      _isDeviceSupported = false;
      _error = 'Failed to initialize biometric service: $e';
    }
  }

  /// Check if device can use biometrics
  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      _canCheckBiometrics = false;
      AppLogger.e('Error checking biometrics: $e');
    }
  }

  /// Get available biometric types on the device
  Future<void> _getAvailableBiometrics() async {
    try {
      _availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      _availableBiometrics = [];
      AppLogger.e('Error getting available biometrics: $e');
    }
  }

  /// Authenticate using any available method (biometrics, PIN, pattern, etc.)
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to continue',
    bool stickyAuth = true,
  }) async {
    if (!_isDeviceSupported) return false;

    try {
      _isAuthenticating = true;
      final bool authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(stickyAuth: stickyAuth),
      );
      _isAuthenticating = false;
      return authenticated;
    } on PlatformException catch (e) {
      _isAuthenticating = false;
      if (e.code == auth_error.notAvailable) {
        AppLogger.e('No biometrics available on this device');
      } else if (e.code == auth_error.notEnrolled) {
        AppLogger.e('No biometrics enrolled on this device');
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        AppLogger.e('Biometric authentication is locked out');
      } else {
        AppLogger.e('Error during authentication: ${e.message}');
      }
      return false;
    }
  }

  /// Authenticate using only biometrics (no PIN/pattern fallback)
  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Please authenticate using biometrics',
    bool stickyAuth = true,
  }) async {
    if (!_isDeviceSupported || !_canCheckBiometrics) {
      _error = 'Device does not support biometric authentication';
      return false;
    }

    try {
      _error = null;
      _isAuthenticating = true;
      final bool authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );
      _isAuthenticating = false;

      if (!authenticated) {
        _error = 'Authentication was cancelled or failed';
      }

      return authenticated;
    } on PlatformException catch (e) {
      _isAuthenticating = false;
      if (e.code == auth_error.notAvailable) {
        _error = 'No biometrics available on this device';
        AppLogger.e('No biometrics available on this device');
      } else if (e.code == auth_error.notEnrolled) {
        _error = 'No biometrics enrolled on this device';
        AppLogger.e('No biometrics enrolled on this device');
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        _error = 'Biometric authentication is locked out';
        AppLogger.e('Biometric authentication is locked out');
      } else {
        _error = 'Authentication error: ${e.message}';
        AppLogger.e('Error during biometric authentication: ${e.message}');
      }
      return false;
    }
  }

  /// Cancel ongoing authentication
  Future<void> cancelAuthentication() async {
    if (_isAuthenticating) {
      await _auth.stopAuthentication();
      _isAuthenticating = false;
    }
  }

  /// Clear any stored error
  void clearError() {
    _error = null;
  }
}
