


import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}


class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterProcessFailure extends RegisterState {
  final String error;
  const RegisterProcessFailure(this.error);

  @override
  List<Object> get props => [error];
}


class EmailCheckSuccess extends RegisterState {
  final String email;
  const EmailCheckSuccess(this.email);

  @override
  List<Object> get props => [email];
}
class EmailCheckFail extends RegisterState {
  final String error;
  const EmailCheckFail(this.error);

  @override
  List<Object> get props => [error];
}


class EmailVerificationSuccess extends RegisterState {
}
class  EmailVerificationFail extends RegisterState {
  final String error;
  const EmailVerificationFail(this.error);

  @override
  List<Object> get props => [error];
}