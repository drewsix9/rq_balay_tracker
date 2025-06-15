import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import '../logger/app_logger.dart';
import '../services/biometric_service.dart';

class BiometricProvider with ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  bool _isInitialized = false;
  String? _error;

  bool get isInitialized => _isInitialized;
  bool get isDeviceSupported => _biometricService.isDeviceSupported;
  bool get canCheckBiometrics => _biometricService.canCheckBiometrics;
  bool get isAuthenticating => _biometricService.isAuthenticating;
  List<BiometricType> get availableBiometrics =>
      _biometricService.availableBiometrics;
  String? get error => _error;

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Initialize biometric service
  Future<void> initialize() async {
    try {
      _setError(null);
      await _biometricService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize biometric service: $e');
      AppLogger.e('Error initializing biometric provider: $e');
    }
  }

  /// Authenticate using any available method
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to continue',
  }) async {
    try {
      _setError(null);
      final bool authenticated = await _biometricService.authenticate(
        localizedReason: localizedReason,
      );
      if (!authenticated) {
        _setError('Authentication failed');
      }
      return authenticated;
    } catch (e) {
      _setError('Authentication error: $e');
      AppLogger.e('Error during authentication: $e');
      return false;
    }
  }

  /// Authenticate using only biometrics
  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Please authenticate using biometrics',
  }) async {
    try {
      _setError(null);
      final bool authenticated = await _biometricService
          .authenticateWithBiometrics(localizedReason: localizedReason);
      if (!authenticated) {
        _setError('Biometric authentication failed');
      }
      return authenticated;
    } catch (e) {
      _setError('Biometric authentication error: $e');
      AppLogger.e('Error during biometric authentication: $e');
      return false;
    }
  }

  /// Cancel ongoing authentication
  Future<void> cancelAuthentication() async {
    try {
      await _biometricService.cancelAuthentication();
    } catch (e) {
      _setError('Failed to cancel authentication: $e');
      AppLogger.e('Error canceling authentication: $e');
    }
  }
}
