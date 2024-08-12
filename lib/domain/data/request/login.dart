
class Login {
  String? meterNo;
  String? email;
  String? password;

  Login({this.meterNo, this.password, this.email});

  Login.fromJson(Map<String, dynamic> json) {
    meterNo = json['meterNo'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meterNo'] = meterNo;
    data['password'] = password;
    data['email'] = email;
    return data;
  }
}
