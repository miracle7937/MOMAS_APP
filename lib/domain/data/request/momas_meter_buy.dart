class MomasMeterBuy {
  String? amount;
  String? trxref;
  String? meterType;
  String? estateId;
  String? meterNo;
  String? amountForVending;
  String? tariffId;

  MomasMeterBuy(
      {this.amount,
      this.trxref,
      this.meterType,
      this.estateId,
      this.meterNo,
      this.amountForVending,
      this.tariffId});

  MomasMeterBuy.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    trxref = json['trxref'];
    meterType = json['meterType'];
    estateId = json['estate_id'];
    meterNo = json['meterNo'];
    amountForVending = json['min_vend_amount'];
    tariffId = json['tariff_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['trxref'] = trxref;
    data['meterType'] = meterType;
    data['estate_id'] = estateId;
    data['meterNo'] = meterNo;
    data['min_vend_amount'] = amountForVending;
    data['tariff_id'] = tariffId;
    return data;
  }
}
