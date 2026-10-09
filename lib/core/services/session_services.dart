import 'package:shared_preferences/shared_preferences.dart';

class SessionServices {
  static const String _isPrivacyHiddenKey = 'is_privacy_hidden';
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool getPrivacyHidden() {
    return _prefs.getBool(_isPrivacyHiddenKey) ?? false;
  }

  static Future<void> setPrivacyHidden(bool isHidden) async {
    await _prefs.setBool(_isPrivacyHiddenKey, isHidden);
  }
}