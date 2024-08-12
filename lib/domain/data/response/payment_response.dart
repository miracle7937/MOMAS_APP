class PaymentResponse {
  bool? status;
  String? url;
  String? ref;

  PaymentResponse({this.status, this.url, this.ref});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] == "success" ? true : json['status'];
    url = json['url'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['url'] = this.url;
    data['ref'] = this.ref;
    return data;
  }
}
