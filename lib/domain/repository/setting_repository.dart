import 'package:momaspayplus/domain/data/response/generic_response.dart';

import '../../utils/routes.dart';
import '../data/response/setting_response.dart';
import '../request.dart';

class SettingRepository {
  final ServerRequest _request = ServerRequest();

  Future<GenericResponse> deleteUser(String email) async {
    var response = await _request
        .postData(path: Routes.deleteUser, body: {"email": email});
    return GenericResponse.fromJson(response.data);
  }

  Future<SettingsDataResponse> support() async {
    var response = await _request.getData(
      path: Routes.support,
    );
    return SettingsDataResponse.fromJson(response.data);
  }

  Future<GenericResponse> requestMeter(
      String email, String fullName, String phoneNumber, String address) async {
    var response = await _request.postData(path: Routes.requestMeter, body: {
      "email": email,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "address": address
    });
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> deleteAccount(String email) async {
    var response = await _request.postData(path: Routes.deleteUser, body: {
      "email": email,
    });
    return GenericResponse.fromJson(response.data);
  }
}
