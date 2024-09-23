import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/utils/shared_pref.dart';

import '../../domain/repository/access_token_repository.dart';
import 'access_token_event.dart';
import 'access_token_state.dart';

class AccessTokenBloc extends Bloc<AccessTokenEvent, AccessTokenState> {
  final AccessTokenRepository repository;

  AccessTokenBloc({required this.repository}) : super(AccessTokenInitial()) {
    on<GetAccessToken>((event, emit) async {
      await mapEventToState(event, emit);
    });
    on<SetEstate>((event, emit) async {
      await setEstate(event, emit);
    });

    on<GenerateTokenEvent>((event, emit) async {
      await generateToken(event, emit);
    });

    on<VerifyAccessToken>((event, emit) async {
      await verifyToken(event, emit);
    });
  }

  Future mapEventToState(
      AccessTokenEvent event, Emitter<AccessTokenState> emit) async {
    if (event is GetAccessToken) {
      emit(AccessTokenLoading());
      try {
        final response = await repository.getEstate();
        if (response.status == true) {
          emit(AccessTokenSuccess(response.data ?? []));
        } else {
          emit(AccessTokenFailed(response.message ?? ""));
        }
      } catch (e) {
        emit(AccessTokenFailed(e.toString()));
      }
    }
  }

  Future setEstate(
      AccessTokenEvent event, Emitter<AccessTokenState> emit) async {
    if (event is SetEstate) {
      emit(AccessTokenLoading());
      try {
        final response = await repository.setEstate(event.data);
        if (response.status == true) {
          final userModel = await repository.getUser();
          SharedPreferenceHelper.saveUser(userModel.user!.toJson());
          emit(SetEstateSuccess(response.message ?? ""));
        } else {
          emit(AccessTokenFailed(response.message ?? ""));
        }
      } catch (e) {
        emit(AccessTokenFailed(e.toString()));
      }
    }
  }

  Future generateToken(
      AccessTokenEvent event, Emitter<AccessTokenState> emit) async {
    if (event is GenerateTokenEvent) {
      emit(AccessTokenLoading());
      try {
        final response = await repository.generateToken(event.data);
        if (response.status == true) {
          emit(SetEstateSuccess(response.message ?? ""));
        } else {
          emit(AccessTokenFailed(response.message ?? ""));
        }
      } catch (e) {
        emit(AccessTokenFailed(e.toString()));
      }
    }
  }

  Future verifyToken(
      VerifyAccessToken event, Emitter<AccessTokenState> emit) async {
      emit(AccessTokenLoading());
      try {
        final response = await repository.verifyToken(event.token);
        if (response.status == true) {
          emit(VerifyTokenSuccess(response.message ?? ""));
        } else {
          emit(AccessTokenFailed(response.message ?? ""));
        }
      } catch (e) {
        emit(AccessTokenFailed(e.toString()));
      }

  }
}
