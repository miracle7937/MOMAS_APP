class CableTvVerificationResponse {
  bool? status;
  Data? data;

  CableTvVerificationResponse({this.status, this.data});

  CableTvVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? customerName;
  String? dueDate;
  String? decoderType;
  String? currentBouquet;
  int? renewalAmount;

  Data(
      {this.customerName,
        this.dueDate,
        this.decoderType,
        this.currentBouquet,
        this.renewalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    dueDate = json['Due_Date'];
    decoderType = json['decoder_type'];
    currentBouquet = json['Current_Bouquet'];
    renewalAmount = json['Renewal_Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['Due_Date'] = dueDate;
    data['decoder_type'] = decoderType;
    data['Current_Bouquet'] = currentBouquet;
    data['Renewal_Amount'] = renewalAmount;
    return data;
  }
}
