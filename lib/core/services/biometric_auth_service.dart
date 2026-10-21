import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static bool _isAuthenticating = false;

  static bool get isAuthenticating => _isAuthenticating;

  /// Checks whether the device has an enrolled fingerprint or face.
  static Future<bool> isBiometricAvailable() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;

      if (!canCheckBiometrics) {
        return false;
      }

      final availableBiometrics = await _auth.getAvailableBiometrics();

      return availableBiometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Opens the system authentication prompt.
  /// Device PIN, pattern, or passcode can be used as a fallback.
  static Future<bool> authenticate({
    String reason = 'Verify your identity to open the application',
  }) async {
    if (_isAuthenticating) return false;

    _isAuthenticating = true;

    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    } finally {
      _isAuthenticating = false;
    }
  }
}
