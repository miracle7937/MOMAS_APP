class SetEstateRequest {
  String? address;
  String? hno;
  String? estateId;

  SetEstateRequest(this.address, this.hno, this.estateId);

  SetEstateRequest.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    hno = json['hno'];
    estateId = json['estate_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['hno'] = hno;
    data['estate_id'] = estateId;
    return data;
  }
}
