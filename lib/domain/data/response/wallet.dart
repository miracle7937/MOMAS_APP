class Wallet {
  bool status;
  int mainWallet;
  int unit;

  Wallet({
    required this.status,
    required this.mainWallet,
    required this.unit,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      status: json['status'],
      mainWallet: json['main_wallet'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'main_wallet': mainWallet,
      'unit': unit,
    };
  }}