import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_event.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_state.dart';

import '../../domain/repository/setting_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingRepository serviceRepository;

  SettingsBloc(this.serviceRepository) : super(SettingsStateInitial()) {
    on<SupportSettingEvent>((event, emit) async => onServiceEvent(event, emit));

    on<DeleteEvent>((event, emit) async => onDeleteEvent(event, emit));

    on<RequestMeterEvent>(
        (event, emit) async => onRequestMeteEvent(event, emit));
  }

  void onServiceEvent(
      SupportSettingEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);
    try {
      emit(SettingsStateLoading());
      var response = await serviceRepository.support();
      if (response.status == true) {
        emit(SettingsSupportStateLoading(response: response));
      } else {
        emit(const SettingsStateFailed("Fail to get list of support"));
      }
    } catch (_, e) {
      emit(SettingsStateFailed(_.toString()));
    }
  }

  void onDeleteEvent(DeleteEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);
    try {
      emit(SettingsStateLoading());
      var response = await serviceRepository.deleteUser(event.email);
      if (response.status == true) {
        emit(SettingsSupportStateSuccess(response.message ?? ""));
      } else {
        emit(const SettingsStateFailed("Fail to get list of support"));
      }
    } catch (_, e) {
      emit(SettingsStateFailed(_.toString()));
    }
  }

  void onRequestMeteEvent(
      RequestMeterEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);
    try {
      emit(SettingsStateLoading());
      var response = await serviceRepository.requestMeter(
          event.email, event.fullName, event.phoneNumber, event.address);
      if (response.status == true) {
        emit(SettingsSupportStateSuccess(response.message ?? ""));
        return;
      } else {
        emit(
            SettingsStateFailed(response.message ?? "Failed to request meter"));
      }
    } catch (_, e) {
      emit(SettingsStateFailed(_.toString()));
    }
  }
}
