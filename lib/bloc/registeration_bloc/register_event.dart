import 'package:equatable/equatable.dart';

import '../../domain/data/request/register.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class UserRegisterEvent extends RegisterEvent {
  final Register register;
  const UserRegisterEvent(this.register);

  @override
  List<Object> get props => [register];
}

class CheckEmailEvent extends RegisterEvent {
  final String email;
  final CheckEmail checkEmailType;
  const CheckEmailEvent(this.email, this.checkEmailType);

  @override
  List<Object> get props => [email];
}

class VerifyEmailEvent extends RegisterEvent {
  final String email;
  final String code;
  const VerifyEmailEvent(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}

class ResetPasswordEvent extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const ResetPasswordEvent(this.email, this.password, this.confirmPassword);

  @override
  List<Object> get props => [email, password, confirmPassword];
}

enum CheckEmail { register, forget }
