import 'package:flutter/cupertino.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AppValidators {
  static String? validateName(String? value, BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return appLocalizations.this_field_is_required;
    }
    if (value.trim().length < 3) {
      return appLocalizations.name_must_be_at_least_characters;
    }
    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return appLocalizations.this_field_is_required;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return appLocalizations.enter_a_valid_email;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return appLocalizations.this_field_is_required;
    }
    final phone = value.trim();
    final regex = RegExp(r'^(?:\+20|0)?1[0125][0-9]{8}$');
    if (!regex.hasMatch(phone)) {
      return appLocalizations.enter_a_valid_phone_number;
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return appLocalizations.this_field_is_required;
    }
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');
    if (!regex.hasMatch(value)) {
      return appLocalizations.password_must_contain_at_least_characters;
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String password,
    BuildContext context,
  ) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return appLocalizations.this_field_is_required;
    }
    if (value != password) {
      return appLocalizations.passwords_do_not_match;
    }

    return null;
  }
}
