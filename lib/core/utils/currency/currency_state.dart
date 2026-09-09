enum CurrencyType { egp, usd }

class CurrencyState {
  final CurrencyType currencyType;

  const CurrencyState({this.currencyType = CurrencyType.egp});
}