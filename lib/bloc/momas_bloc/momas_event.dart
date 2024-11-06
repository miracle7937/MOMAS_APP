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
  final String estateId;

  const MomasVerification({required this.meterNo, required this.estateId});

  @override
  List<Object> get props => [meterNo];
}

class MomasMeterPayment extends MomasPaymentEvent {
  final MomasPaymentType paymentType;
  final String amount, meterType, trxref;
  final String? estateId;
  final String? meterNo;
  final String? amountForVending;
  final String? totalPayable;
  final String? tariffId;

  const MomasMeterPayment(
      {required this.amount,
      required this.meterType,
      required this.trxref,
      required this.paymentType,
      this.estateId,
      this.meterNo,
      this.amountForVending,
      this.tariffId,
      this.totalPayable});

  @override
  List<Object> get props => [amount, meterType, trxref, paymentType];
}

class MomasPaymentHistory extends MomasPaymentEvent {
  const MomasPaymentHistory();
}

class MomasGetVentingProperties extends MomasPaymentEvent {
  const MomasGetVentingProperties();
}
