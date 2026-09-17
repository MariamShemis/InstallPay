import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/cubits/language/language_services/language_services.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState(Locale('en'))) {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final lang = await LanguageService.getSavedLanguage();
    emit(LanguageState(Locale(lang)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await LanguageService.saveLanguage(languageCode);
    emit(LanguageState(Locale(languageCode)));
  }
}