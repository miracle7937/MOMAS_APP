import 'package:equatable/equatable.dart';

abstract class CableTvEvent extends Equatable {
  const CableTvEvent();

  @override
  List<Object> get props => [];
}

class BuyCableTv extends CableTvEvent {
  final String decoderType;
  final String amount;
  final String decoderNo;
  final String variationCode;
  final String? quantity;
  final String subscriptionType;
  final String ref;

  const BuyCableTv(
      {required this.decoderType,
      required this.decoderNo,
      this.quantity = "1",
      required this.subscriptionType,
      required this.amount,
      required this.variationCode,
      required this.ref});

  @override
  List<Object> get props =>
      [decoderNo, amount, decoderType, variationCode, subscriptionType, ref];
}

class GetCableTv extends CableTvEvent {
  const GetCableTv();

  @override
  List<Object> get props => [];
}

class VerifyDecoderTv extends CableTvEvent {
  final String decoderType, decoderNo;

  const VerifyDecoderTv({required this.decoderType, required this.decoderNo});

  @override
  List<Object> get props => [];
}
