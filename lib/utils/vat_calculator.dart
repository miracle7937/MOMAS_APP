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
    return (vatValue) * 10;
    // return (100 + vatValue) / 100;
  }

  num _removePaymentCharge(num amount) {
    return amount - (2.5 / 100) * amount;
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
    return _removePaymentCharge(amountReceivable) * (vatUnit / (100 + vatUnit));
  }

  num calculateCostOfUnit({
    required String? amountText,
    required num? tariffAmount,
    required num utilitiesAmount,
    required num? vat,
  }) {
    double amount = _parseAmount(amountText);
    num amountReceivable = _calculateAmountReceivable(
      amount: amount,
      utilitiesAmount: utilitiesAmount,
    );
    num vatAmount = calculateVatAmount(
        amountText: amountText,
        utilitiesAmount: utilitiesAmount,
        tariffAmount: tariffAmount,
        vat: vat);
    return _removePaymentCharge(amountReceivable) - vatAmount;
  }

  num calculateTariffAmountPerKWatt({
    required String? amountText,
    required num? tariffAmount,
    required num utilitiesAmount,
    required num? vat,
  }) {
    num tariffAmountValue = tariffAmount ?? 0;
    num costOfUnit = calculateCostOfUnit(
        amountText: amountText,
        utilitiesAmount: utilitiesAmount,
        tariffAmount: tariffAmount,
        vat: vat);

    print(tariffAmountValue);
    print("JJJJ ${costOfUnit / tariffAmountValue}");
    return tariffAmountValue > 0 ? costOfUnit / tariffAmountValue : 0;
  }
}
