class DataRequest {
  final String serviceId;
  final String amount;
  final String phone;
  final String variationCode;
  final String ref;

  DataRequest({required this.serviceId,
    required this.ref,
    required this.amount,
    required this.phone,
    required this.variationCode});

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'amount': amount,
      'phone': phone,
      'variation_code': variationCode,
      'ref': ref,
    };
  }
}
