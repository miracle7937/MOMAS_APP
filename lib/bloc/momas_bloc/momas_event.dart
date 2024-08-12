import 'package:equatable/equatable.dart';

import '../payment_bloc/payment_bloc.dart';
import 'momas_bloc.dart';

abstract class MomasPaymentEvent extends Equatable {
  const MomasPaymentEvent();

  @override
  List<Object> get props => [];
}

class MomasVerification extends MomasPaymentEvent {
  final String meterNo;

  const MomasVerification({required this.meterNo});

  @override
  List<Object> get props => [meterNo];
}



class MomasMeterPayment extends MomasPaymentEvent {
  final MomasPaymentType paymentType;
  final String amount, meterType, trxref;
  final String? estateId;
  final String? meterNo;

  const MomasMeterPayment(
      {required this.amount,
      required this.meterType,
      required this.trxref,
      required this.paymentType,
      this.estateId,
      this.meterNo});

  @override
  List<Object> get props => [amount, meterType, trxref, paymentType];
}

class MomasPaymentHistory extends MomasPaymentEvent {
  const MomasPaymentHistory();

}
