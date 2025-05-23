class VendingPropertiesData {
  bool? status;
  num? minPurchase;
  num? minVend;

  VendingPropertiesData({this.status, this.minPurchase, this.minVend});

  factory VendingPropertiesData.fromJson(Map<String, dynamic> json) {
    return VendingPropertiesData(
      status: json['status'],
      minPurchase: json['min_purchase'],
      minVend: json['min_vend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'min_purchase': minPurchase,
      'min_vend': minVend,
    };
  }
}
