

class CableTvRequest {
  String? decoderType;
  String? decoderNo;
  String? variationCode;
  String? amount;
  String? subscriptionType;
  String? quantity;
  String? ref;

  CableTvRequest(
      {this.decoderType,
        this.decoderNo,
        this.variationCode,
        this.amount,
        this.subscriptionType,
        this.quantity,
      this.ref});

  CableTvRequest.fromJson(Map<String, dynamic> json) {
    decoderType = json['decoder_type'];
    decoderNo = json['decoder_no'];
    variationCode = json['variation_code'];
    amount = json['amount'];
    subscriptionType = json['subscription_type'];
    quantity = json['quantity'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['decoder_type'] = decoderType;
    data['decoder_no'] = decoderNo;
    data['variation_code'] = variationCode;
    data['amount'] = amount;
    data['subscription_type'] = subscriptionType;
    data['quantity'] = quantity;
    data['ref'] = ref;
    return data;
  }
}
