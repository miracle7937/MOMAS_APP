import 'package:equatable/equatable.dart';

import '../../domain/data/request/momas_payent_response.dart';
import '../../domain/data/response/transaction_data_response.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String url;

  const PaymentSuccess({required this.url});

  @override
  List<Object> get props => [url];
}

class PaymentWalletSuccess extends PaymentState {
  final String message;
  final String ref;

  const PaymentWalletSuccess({required this.message, required this.ref});

  @override
  List<Object> get props => [message];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class PaymentHistorySuccess extends PaymentState {
  final List<TransactionData> data;

  const PaymentHistorySuccess(this.data);

  @override
  List<Object> get props => [];
}

class MomasPaymentSuccess extends PaymentState {
  final MomasPaymentResponse momasPaymentResponse;

  const MomasPaymentSuccess(this.momasPaymentResponse);

  @override
  List<Object> get props => [momasPaymentResponse];
}
