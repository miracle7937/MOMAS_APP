import 'package:momas_pay/domain/data/request/register.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';
import 'package:momas_pay/domain/data/response/user_model.dart';
import 'package:momas_pay/domain/request.dart';

import '../../utils/routes.dart';
import '../data/request/login.dart';

class AuthRepository {
  final ServerRequest _request = ServerRequest();

  Future<UserModel> login(Login data) async {
    var response =
        await _request.postData(path: Routes.login, body: data.toJson());
    return UserModel.fromJson(response.data);
  }

  Future<GenericResponse> register(Register data) async {
    var response =
        await _request.postData(path: Routes.register, body: data.toJson());
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> checkEmail(String email) async {
    var response = await _request
        .postData(path: Routes.checkEmail, body: {"email": email});
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> verifyEmail(String email, String code) async {
    var response = await _request.postData(
        path: Routes.verifyEmail, body: {"email": email, "code": code});
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> confirmPassword(
      String email, String password, String confirmPassword) async {
    var response = await _request.postData(path: Routes.verifyEmail, body: {
      "email": email,
      "password": password,
      "confirm_password": confirmPassword
    });
    return GenericResponse.fromJson(response.data);
  }
}
