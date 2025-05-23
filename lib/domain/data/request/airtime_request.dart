class AirtimeRequest {
  final String serviceId;
  final String amount;
  final String phone;
  final String ref;

  AirtimeRequest({required this.serviceId, required this.amount, required this.phone, required this.ref});

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'amount': amount,
      'phone': phone,
      'ref': ref,
    };
  }
}
