class MomasMeterBuy {
  String? amount;
  String? trxref;
  String? meterType;
  String? estateId;
  String? meterNo;

  MomasMeterBuy({this.amount, this.trxref, this.meterType, this.estateId,this.meterNo});

  MomasMeterBuy.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    trxref = json['trxref'];
    meterType = json['meterType'];
    estateId = json['estate_id'];
    meterNo = json['meterNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['trxref'] = trxref;
    data['meterType'] = meterType;
    data['estate_id'] = estateId;
    data['meterNo'] = meterNo;
    return data;
  }
}
