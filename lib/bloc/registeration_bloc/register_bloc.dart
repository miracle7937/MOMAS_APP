import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/bloc/registeration_bloc/register_event.dart';
import 'package:momas_pay/bloc/registeration_bloc/register_state.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';

import '../../domain/service/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async => onLoginEvent(event, emit));
    on<ResetPasswordEvent>(
        (event, emit) async => onResetPasswordEvent(event, emit));
  }

  void onLoginEvent(RegisterEvent event, Emitter<RegisterState> emit) async {
    super.onEvent(event);

    try {
      if (event is UserRegisterEvent) {
        emit(RegisterLoading());
        GenericResponse response = await authService.register(event.register);
        if (response.status == true) {
          emit(RegisterSuccess(response.message ?? ""));
        } else {
          emit(RegisterProcessFailure(response.message ?? ""));
        }
      }
      if (event is CheckEmailEvent) {
        emit(RegisterLoading());
        GenericResponse response = await authService.checkEmail(
            event.email, event.checkEmailType.name);
        if (response.status == true) {
          emit(EmailCheckSuccess(event.email));
        } else {
          emit(EmailCheckFail(response.message ?? ""));
        }
      }

      if (event is VerifyEmailEvent) {
        emit(RegisterLoading());
        GenericResponse response =
            await authService.verifyEmail(event.email, event.code);
        if (response.status == true) {
          emit(EmailVerificationSuccess());
        } else {
          emit(EmailVerificationFail(response.message ?? ""));
        }
      }
    } catch (_, e) {
      emit(RegisterProcessFailure(_.toString()));
    }
  }

  onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(RegisterLoading());
      GenericResponse response = await authService.resetPassword(
          event.email, event.password, event.confirmPassword);
      if (response.status == true) {
        emit(RegisterSuccess(response.message ?? ""));
      } else {
        emit(RegisterProcessFailure(response.message ?? ""));
      }
    } catch (_, e) {
      emit(RegisterProcessFailure(_.toString()));
    }
  }
}
