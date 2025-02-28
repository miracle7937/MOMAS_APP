import '../../utils/routes.dart';
import '../data/request/momas_payent_response.dart';
import '../data/response/bank_details.dart';
import '../data/response/payment_response.dart';
import '../data/response/transaction_data_response.dart';
import '../request.dart';

class PaymentRepository {
  final ServerRequest _request = ServerRequest();

  Future<PaymentResponse> fudWallet(
      String amount, String paymentType, String serviceType) async {
    var response = await _request.postData(path: Routes.pay, body: {
      'pay_type': paymentType,
      'amount': amount,
      "service": serviceType
    });
    return PaymentResponse.fromJson(response.data);
  }

  Future<TransactionDataResponse> searchTransaction() async {
    var response = await _request.getData(path: Routes.getTransaction);
    return TransactionDataResponse.fromJson(response.data);
  }

  Future<MomasPaymentResponse> retryPayment(String transactionRef) async {
    var response = await _request
        .postData(path: Routes.retryMeter, body: {"trxref": transactionRef});
    return MomasPaymentResponse.fromJson(response.data);
  }

  Future<BankDetail> generateAccount() async {
    var response = await _request.getData(
      path: Routes.getAccount,
    );
    return BankDetail.fromJson(response.data);
  }
}
