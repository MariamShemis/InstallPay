import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_cubit.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

extension CurrencySymbolExtension on BuildContext {
  String get currencySymbol {
    final currencyType = watch<CurrencyCubit>().state.currencyType;
    final appLocalizations = AppLocalizations.of(this)!;

    switch (currencyType) {
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.egp:
      default:
        return appLocalizations.lE;
    }
  }
}