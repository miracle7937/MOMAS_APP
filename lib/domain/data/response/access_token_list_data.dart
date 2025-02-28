class AccessTokenListDataResponse {
  final bool status;
  final List<TokenBody> data;

  AccessTokenListDataResponse({required this.status, required this.data});

  factory AccessTokenListDataResponse.fromJson(Map<String, dynamic> json) {
    return AccessTokenListDataResponse(
      status: json['status'],
      data: List<TokenBody>.from(
          json['data'].map((item) => TokenBody.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class TokenBody {
  final int id;
  final String userId;
  final String validDate;
  final String token;
  final String estateId;
  final String visitor;
  final String address;
  final String email;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  TokenBody({
    required this.id,
    required this.userId,
    required this.validDate,
    required this.token,
    required this.estateId,
    required this.visitor,
    required this.address,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TokenBody.fromJson(Map<String, dynamic> json) {
    return TokenBody(
      id: json['id'],
      userId: json['user_id'].toString(),
      validDate: json['valid_date'],
      token: json['token'],
      estateId: json['estate_id'].toString(),
      visitor: json['visitor'],
      address: json['address'],
      email: json['email'],
      status: json['status'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'valid_date': validDate,
      'token': token,
      'estate_id': estateId,
      'visitor': visitor,
      'address': address,
      'email': email,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
