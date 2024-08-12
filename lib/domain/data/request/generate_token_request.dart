class GenerateTokenRequest {
  String? qty;
  String? email;
  String? canSendMail;
  String? estateId;

  GenerateTokenRequest({this.qty, this.email, this.canSendMail, this.estateId});

  GenerateTokenRequest.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    email = json['email'];
    canSendMail = json['can_send_mail'];
    estateId = json['estate_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['email'] = email;
    data['can_send_mail'] = canSendMail;
    data['estate_id'] = estateId;
    return data;
  }
}
