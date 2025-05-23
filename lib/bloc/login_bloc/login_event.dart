
import 'package:equatable/equatable.dart';

import '../../domain/data/request/login.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class UserLoginEvent extends LoginEvent {
  final Login login;
  const UserLoginEvent(this.login);

  @override
  List<Object> get props => [login];
}