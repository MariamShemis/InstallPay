import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  static SharedPreferences? _prefs;

  static Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> saveLanguage(String languageCode) async {
    try {
      await _ensureInitialized();
      return await _prefs!.setString(_languageKey, languageCode);
    } catch (e) {
      return false;
    }
  }

  static Future<String> getSavedLanguage() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_languageKey) ?? 'en';
    } catch (e) {
      return 'en';
    }
  }

  static Future<bool> isArabic() async {
    final lang = await getSavedLanguage();
    return lang == 'ar';
  }

  static Future<bool> isEnglish() async {
    final lang = await getSavedLanguage();
    return lang == 'en';
  }
}