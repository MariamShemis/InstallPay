import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit() : super(const CurrencyState(currencyType: CurrencyType.egp));

  void changeCurrency(CurrencyType currencyType) {
    emit(CurrencyState(currencyType: currencyType));
  }

  void toggleCurrency() {
    if (state.currencyType == CurrencyType.egp) {
      changeCurrency(CurrencyType.usd);
    } else {
      changeCurrency(CurrencyType.egp);
    }
  }
}