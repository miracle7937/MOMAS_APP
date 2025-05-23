

class Register{
  String firstName;
  String lastName;
  String meterNo;
  String phone;
  String email;
  String password;
  String confirmPassword;

  Register({
    required this.firstName,
    required this.lastName,
    required this.meterNo,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  // Method to convert from JSON to UserModel
  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      firstName: json['first_name'],
      lastName: json['last_name'],
      meterNo: json['meterNo'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      confirmPassword: "",
    );
  }

  // Method to convert from UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'meterNo': meterNo,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }


}