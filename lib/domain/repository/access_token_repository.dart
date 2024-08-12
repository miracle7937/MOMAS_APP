import 'package:momas_pay/domain/data/request/generate_token_request.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';

import '../../utils/routes.dart';
import '../data/request/set_estate_request.dart';
import '../data/response/estate_response.dart';
import '../data/response/user_model.dart';
import '../request.dart';

class AccessTokenRepository {

  final ServerRequest _request = ServerRequest();
  Future<EstateResponse> getEstate() async {
    var response = await _request.getData(path: Routes.getEstate,);
    return EstateResponse.fromJson(response.data);
  }

  Future<GenericResponse> setEstate(SetEstateRequest  request) async {
    var response = await _request.postData(path: Routes.setDefault, body: request.toJson() );
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> generateToken(GenerateTokenRequest  request) async {
    var response = await _request.postData(path: Routes.generateToken, body: request.toJson() );
    return GenericResponse.fromJson(response.data);
  }

  Future<UserModel> getUser() async {
    var response = await _request.getData(path: Routes.getUser, );
    return UserModel.fromJson(response.data);
  }
}