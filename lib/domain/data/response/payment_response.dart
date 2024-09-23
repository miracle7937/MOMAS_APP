class PaymentResponse {
  bool? status;
  String? url;
  String? ref;
  String? message;

  PaymentResponse({this.status, this.url, this.ref, this.message});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] == "success" ? true : json['status'];
    url = json['url'];
    ref = json['ref'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['url'] = this.url;
    data['ref'] = this.ref;
    data['message'] = this.message;
    return data;
  }
}
