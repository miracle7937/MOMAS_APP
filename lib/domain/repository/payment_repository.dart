



import '../../utils/routes.dart';
import '../data/response/payment_response.dart';
import '../data/response/transaction_data_response.dart';
import '../request.dart';

class PaymentRepository {

  final ServerRequest _request = ServerRequest();

  Future<PaymentResponse> fudWallet(String amount, String paymentType) async {
    var response = await _request.postData(path: Routes.pay, body: {'pay_type': paymentType, 'amount':amount});
    return PaymentResponse.fromJson(response.data);
  }

  Future<TransactionDataResponse> searchTransaction() async {
    var response = await _request.getData(path: Routes.getTransaction);
    return TransactionDataResponse.fromJson(response.data);
  }
}