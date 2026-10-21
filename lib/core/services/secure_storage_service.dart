import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _emailKey = 'biometric_login_email';
  static const String _passwordKey = 'biometric_login_password';
  static const String _providerKey = 'biometric_login_provider';
  static const String _userIdKey = 'biometric_login_user_id';
  static const String _enabledKey = 'biometric_login_enabled';

  static Future<void> saveEmailLogin({
    required String email,
    required String password,
    required String userId,
  }) async {
    await _storage.write(key: _emailKey, value: email.trim());
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(key: _providerKey, value: 'email');
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _enabledKey, value: 'true');
  }

  static Future<String?> getEmail() async {
    return _storage.read(key: _emailKey);
  }

  static Future<String?> getPassword() async {
    return _storage.read(key: _passwordKey);
  }

  static Future<String?> getProvider() async {
    return _storage.read(key: _providerKey);
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  static Future<bool> isBiometricLoginEnabled() async {
    final value = await _storage.read(key: _enabledKey);
    return value == 'true';
  }

  static Future<void> setBiometricLoginEnabled(bool enabled) async {
    await _storage.write(key: _enabledKey, value: enabled ? 'true' : 'false');
  }

  static Future<bool> hasSavedEmailLogin() async {
    final email = await getEmail();
    final password = await getPassword();
    final provider = await getProvider();

    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty &&
        provider == 'email';
  }

  static Future<void> clearLoginCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
    await _storage.delete(key: _providerKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _enabledKey);
  }
}
