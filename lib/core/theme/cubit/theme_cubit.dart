import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  static const String _themeKey = 'theme_mode';

  Future<void> changeTheme(ThemeMode themeMode) async {
    await setTheme(themeMode);
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'dark':
        emit(state.copyWith(themeMode: ThemeMode.dark));
        break;
      case 'light':
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
      default:
        emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    await setTheme(newTheme);
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    emit(state.copyWith(themeMode: themeMode));

    final prefs = await SharedPreferences.getInstance();

    switch (themeMode) {
      case ThemeMode.dark:
        await prefs.setString(_themeKey, 'dark');
        break;
      case ThemeMode.light:
        await prefs.setString(_themeKey, 'light');
        break;
      case ThemeMode.system:
        await prefs.setString(_themeKey, 'system');
        break;
    }
  }
}
