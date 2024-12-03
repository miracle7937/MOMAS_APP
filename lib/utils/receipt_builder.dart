import 'package:momas_pay/domain/data/response/transaction_data_response.dart';
import 'package:momas_pay/utils/time_util.dart';

import '../domain/data/request/momas_payent_response.dart';
import '../domain/data/response/generate_token_response.dart';
import '../domain/data/response/meter_payment_response.dart';
import '../domain/data/transaction_details.dart';
import 'amount_formatter.dart';

class ReceiptBuilder {
  List<TransactionDetail> accessToken(TokenData data) {
    return [
      TransactionDetail(label: 'Service:', value: data.service),
      TransactionDetail(label: 'Address:', value: data.address),
      TransactionDetail(label: 'Name:', value: data.name),
      TransactionDetail(label: 'Token:', value: data.token.toString() ?? ""),
    ];
  }

  List<TransactionDetail> meterPayment(MomasPaymentData data) {
    return [
      TransactionDetail(label: 'Service:', value: data.service),
      TransactionDetail(label: 'Address:', value: data.address),
      TransactionDetail(label: 'Name:', value: data.fullName),
      TransactionDetail(label: 'Token:', value: data.token ?? ""),
      TransactionDetail(label: 'Date:', value: data.date ?? ""),
      TransactionDetail(label: 'KCT1  Token:', value: data.kctToken1 ?? ""),
      TransactionDetail(label: 'KCT2  Token:', value: data.kctToken2 ?? ""),
      TransactionDetail(label: 'Amount  :', value: "NGN ${data.amount}"),
      TransactionDetail(
          label: 'Unit  :', value: "${data.vendAmountKwPerNaira}KWH"),
      TransactionDetail(
          label: 'VAT Amount  :', value: "NGN${data.vatAmount}" ?? ""),
    ];
  }

  List<TransactionDetail> meterHistory(MeterData data) {
    return [
      TransactionDetail(label: 'Order ID:', value: data.orderId),
      TransactionDetail(label: 'Address:', value: data.address),
      TransactionDetail(
          label: 'Amount:',
          value: "NGN ${AmountFormatter.formatNaira(data.amount!.toDouble())}"),
      TransactionDetail(label: 'Token:', value: data.token.toString() ?? ""),
      TransactionDetail(
          label: 'Date:', value: TimeUtil.formatMMMMDY(data.createdAt!)),
    ];
  }

  List<TransactionDetail> transactionHistory(TransactionData data) {
    return [
      TransactionDetail(label: 'Transaction ID:', value: data.trxId),
      TransactionDetail(label: 'Payment Type:', value: data.payType ?? ""),
      TransactionDetail(label: 'Service Type:', value: data.serviceType ?? ""),
      TransactionDetail(label: 'Amount:', value: 'NGN ${data.amount}'),
      TransactionDetail(label: 'Status:', value: data.status?.name ?? ""),
      TransactionDetail(label: 'Note:', value: data.note ?? ""),
      TransactionDetail(
          label: 'Date:', value: TimeUtil.formatMMMMDY(data.createdAt!)),
    ];
  }
}
