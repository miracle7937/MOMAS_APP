

import 'package:equatable/equatable.dart';

import '../../domain/data/response/cable_tv_response.dart';
import '../../domain/data/response/cable_tv_verification_response.dart';
import '../../domain/data/response/generic_response.dart';



abstract class CableTvState extends Equatable {
  const CableTvState();

  @override
  List<Object> get props => [];
}

class CableTvInitial extends CableTvState {}

class CableTvLoading extends CableTvState {}
class CableTvVerificationLoading extends CableTvState {}

class CableTvSuccess extends CableTvState {
  final CableTvResponse response;

  const CableTvSuccess({required this.response});

  @override
  List<Object> get props => [response];
}


class BuyCableTvSuccess extends CableTvState {
  final GenericResponse response;

  const BuyCableTvSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class CableTvFailure extends CableTvState {
  final String error;

  const CableTvFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CableTvVerificationSuccess extends CableTvState {
  final CableTvVerificationResponse response;

  const CableTvVerificationSuccess({required this.response});

  @override
  List<Object> get props => [response];
}
