class BankDetail {
  bool? status;
  String? bank;
  String? accountNo;
  String? accountName;
  int? amount;

  BankDetail(
      {this.status, this.bank, this.accountNo, this.accountName, this.amount});

  BankDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    bank = json['bank'];
    accountNo = json['account_no'];
    accountName = json['account_name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['bank'] = this.bank;
    data['account_no'] = this.accountNo;
    data['account_name'] = this.accountName;
    data['amount'] = this.amount;
    return data;
  }
}
