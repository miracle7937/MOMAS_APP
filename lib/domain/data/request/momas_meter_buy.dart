class MomasMeterBuy {
  String? vendingAmount;
  String? trxref;
  String? meterType;
  String? estateId;
  String? meterNo;
  String? vendValueKWPerNaira;
  String? totalPaidAmount;
  String? tariffId;
  String? utilityAmount;
  String? vatAmount;

  MomasMeterBuy({
    this.vendingAmount,
    this.trxref,
    this.meterType,
    this.estateId,
    this.meterNo,
    this.vendValueKWPerNaira,
    this.tariffId,
    this.totalPaidAmount,
    this.utilityAmount,
    this.vatAmount,
  });

  MomasMeterBuy.fromJson(Map<String, dynamic> json) {
    vendingAmount = json['vending_amount'];
    trxref = json['trxref'];
    meterType = json['meterType'];
    estateId = json['estate_id'];
    meterNo = json['meterNo'];
    vendValueKWPerNaira = json['vend_amount_kw_per_naira'];
    tariffId = json['tariff_id'];
    totalPaidAmount = json['total_paid_amount'];
    utilityAmount = json['utility_amount'];
    vatAmount = json['vat_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vending_amount'] = vendingAmount;
    data['trxref'] = trxref;
    data['meterType'] = meterType;
    data['estate_id'] = estateId;
    data['meterNo'] = meterNo;
    data['tariff_id'] = tariffId;
    data['vend_amount_kw_per_naira'] = vendValueKWPerNaira;
    data['total_paid_amount'] = totalPaidAmount;
    data['utility_amount'] = utilityAmount;
    data['vat_amount'] = vatAmount;
    return data;
  }
}
