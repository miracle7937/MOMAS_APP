class VatCalculator {
  double _parseAmount(String? text) =>
      text != null && text.isNotEmpty ? double.parse(text) : 0;

  num _calculateAmountReceivable({
    required double amount,
    required num utilitiesAmount,
  }) {
    return amount - utilitiesAmount;
  }

  num _calculateVatUnit(num vatValue) {
    return (100 + vatValue) / 100;
  }

  num calculateVatAmount({
    required String? amountText,
    required num? tariffAmount,
    required num utilitiesAmount,
    required num? vat,
  }) {
    double amount = _parseAmount(amountText);
    num vatValue = vat ?? 0;
    num amountReceivable = _calculateAmountReceivable(
      amount: amount,
      utilitiesAmount: utilitiesAmount,
    );
    num vatUnit = _calculateVatUnit(vatValue);
    num costOfUnit = amountReceivable / vatUnit;
    return amountReceivable - costOfUnit;
  }

  num calculateCostOfUnit({
    required String? amountText,
    required num? tariffAmount,
    required num utilitiesAmount,
    required num? vat,
  }) {
    double amount = _parseAmount(amountText);
    num vatValue = vat ?? 0;
    num amountReceivable = _calculateAmountReceivable(
      amount: amount,
      utilitiesAmount: utilitiesAmount,
    );
    num vatUnit = _calculateVatUnit(vatValue);
    return amountReceivable / vatUnit;
  }

  num calculateTariffAmountPerKWatt({
    required String? amountText,
    required num? tariffAmount,
    required num utilitiesAmount,
    required num? vat,
  }) {
    double amount = _parseAmount(amountText);
    num tariffAmountValue = tariffAmount ?? 0;
    num vatValue = vat ?? 0;
    num amountReceivable = _calculateAmountReceivable(
      amount: amount,
      utilitiesAmount: utilitiesAmount,
    );
    num vatUnit = _calculateVatUnit(vatValue);
    num costOfUnit = amountReceivable / vatUnit;
    return costOfUnit / tariffAmountValue;
  }
}
