import 'package:momaspayplus/domain/data/response/generic_response.dart';

import '../../utils/routes.dart';
import '../data/response/comment_response.dart';
import '../data/response/service_data_response.dart';
import '../data/response/service_response.dart';
import '../request.dart';

class ServiceRepository {
  final ServerRequest _request = ServerRequest();

  Future<ServiceDataResponse> getService() async {
    var response = await _request.getData(path: Routes.serviceProperties);
    return ServiceDataResponse.fromJson(response.data);
  }

  Future<ServiceSearchResponse> searchService(
      String serviceId, String estateId) async {
    var response = await _request.postData(
        path: Routes.serviceSearch,
        body: {"estate_id": estateId, "service_id": serviceId});
    return ServiceSearchResponse.fromJson(response.data);
  }

  Future<GenericResponse> saveServiceComment(
      String jobId, String rate, String comment) async {
    var response = await _request.postData(
        path: Routes.saveComment,
        body: {"job_id": jobId, "rate": rate, "comment": comment});
    return GenericResponse.fromJson(response.data);
  }

  Future<CommentResponse> getServiceComment(
    String jobId,
  ) async {
    var response = await _request
        .postData(path: Routes.getComment, body: {"job_id": jobId});
    return CommentResponse.fromJson(response.data);
  }
}
