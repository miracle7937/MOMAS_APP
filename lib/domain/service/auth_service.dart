import 'package:flutter/cupertino.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';
import 'package:momas_pay/domain/repository/auth_repository.dart';
import 'package:momas_pay/utils/validators.dart';

import '../../utils/strings.dart';
import '../data/request/login.dart';
import '../data/request/register.dart';
import '../data/response/user_model.dart';

class AuthService {
  final AuthRepository repository;

  AuthService(this.repository);

  Future<UserModel> login(Login data) async {
    // if(isEmpty(data.meterNo) ){
    //   throw Exception("meter number is not valid");
    // }
    if (!FormValidators.isValidPassword(data.password ?? "")) {
      throw Exception("password is not valid");
    }

    return await repository.login(data);
  }

  Future<GenericResponse> register(Register data) async {
    if (data.password != data.confirmPassword) {
      throw Exception("password mismatch");
    }

    if (isEmpty(data.meterNo)) {
      throw Exception("meter number is not valid");
    }
    if (!FormValidators.isValidPassword(data.password ?? "")) {
      throw Exception("password is not valid");
    }
    if (isEmpty(data.firstName)) {
      throw Exception("first name can't be empty");
    }
    if (isEmpty(data.lastName)) {
      throw Exception("last name can't be empty");
    }
    return await repository.register(data);
  }

  Future<GenericResponse> checkEmail(String email) async {
    if (!FormValidators.isValidEmail(email)) {
      throw Exception("This email is not valid");
    }
    return await repository.checkEmail(email);
  }

  Future<GenericResponse> verifyEmail(String email, String code) async {
    return await repository.verifyEmail(email, code);
  }

  Future<GenericResponse> resetPassword(
      String email, String passWord, conFirmPassword) async {
    return await repository.confirmPassword(email, passWord, conFirmPassword);
  }
}
