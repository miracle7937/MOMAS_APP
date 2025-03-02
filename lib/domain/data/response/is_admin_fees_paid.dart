class IsAdminPaidModel {
  bool? status;
  bool? monthlyAdminFee;

  IsAdminPaidModel({this.status, this.monthlyAdminFee});

  IsAdminPaidModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    monthlyAdminFee =
        (json['monthly_admin_fee']).toString() == "1" ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['monthly_admin_fee'] = this.monthlyAdminFee;
    return data;
  }
}
