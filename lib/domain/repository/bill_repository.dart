import 'package:momas_pay/domain/data/request/airtime_request.dart';
import 'package:momas_pay/domain/data/request/cable_tv_request.dart';
import 'package:momas_pay/domain/data/request/data_request.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';

import '../../utils/routes.dart';
import '../data/request/momas_meter_buy.dart';
import '../data/request/momas_payent_response.dart';
import '../data/response/cable_tv_response.dart';
import '../data/response/cable_tv_verification_response.dart';
import '../data/response/data_response.dart';
import '../data/response/meter_payment_response.dart';
import '../data/response/momas_meter_response.dart';
import '../data/response/vending_properties.dart';
import '../request.dart';

class BillRepository {
  final ServerRequest _request = ServerRequest();

  Future<GenericResponse> buyAirtime(AirtimeRequest data) async {
    var response =
        await _request.postData(path: Routes.buyAirtime, body: data.toJson());
    return GenericResponse.fromJson(response.data);
  }

  Future<GenericResponse> buyData(DataRequest data) async {
    var response =
        await _request.postData(path: Routes.buyData, body: data.toJson());
    return GenericResponse.fromJson(response.data);
  }

  Future<DataResponse> getData() async {
    var response = await _request.getData(
      path: Routes.getData,
    );
    return DataResponse.fromJson(response.data);
  }

  Future<GenericResponse> buyCableTv(CableTvRequest data) async {
    var response =
        await _request.postData(path: Routes.buyCable, body: data.toJson());
    return GenericResponse.fromJson(response.data);
  }

  Future<CableTvResponse> getCableTv() async {
    var response = await _request.getData(
      path: Routes.cablePlan,
    );
    return CableTvResponse.fromJson(response.data);
  }

  Future<CableTvVerificationResponse> verifyCable(
      String decoderType, String decoderNo) async {
    var response = await _request.postData(
        path: Routes.validateCable,
        body: {"decoder_type": decoderType, "decoder_no": decoderNo});
    return CableTvVerificationResponse.fromJson(response.data);
  }

  Future<MomasVerificationResponse> verifyMomasMeter(String meterNo) async {
    var response =
        await _request.postData(path: Routes.vereifyMomasMeter, body: {
      "meterNo": meterNo,
    });
    return MomasVerificationResponse.fromJson(response.data);
  }

  Future<MomasPaymentResponse> payMomasMeter(MomasMeterBuy momasPayment) async {
    var response = await _request.postData(
        path: Routes.payMomasMeter, body: momasPayment.toJson());
    return MomasPaymentResponse.fromJson(response.data);
  }

  Future<MomasPaymentResponse> payOtherMomasMeter(
      MomasMeterBuy momasPayment) async {
    var response = await _request.postData(
        path: Routes.buyMeterOthers, body: momasPayment.toJson());
    return MomasPaymentResponse.fromJson(response.data);
  }

  Future<MeterPaymentResponse> getMomasMeterHistory() async {
    var response = await _request.postData(path: Routes.reprintMeter, body: {});
    return MeterPaymentResponse.fromJson(response.data);
  }

  Future<VendingPropertiesData> getVendingProperties() async {
    var response = await _request.getData(path: Routes.vendingProperties);
    return VendingPropertiesData.fromJson(response.data);
  }
}
