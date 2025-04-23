import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/service_bloc/service_event.dart';
import 'package:momaspayplus/bloc/service_bloc/service_state.dart';

import '../../domain/repository/service_repository.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;

  ServiceBloc(this.serviceRepository) : super(ServiceStateInitial()) {
    on<ServicePropertiesEvent>(
        (event, emit) async => onServiceEvent(event, emit));
    on<ServiceSearchEvent>(
        (event, emit) async => onServiceSearchEvent(event, emit));
    on<ServicePostCommentEvent>(
        (event, emit) async => postCommentEvent(event, emit));
    on<GetCommentEvent>((event, emit) async => getCommentEvent(event, emit));
  }

  void onServiceEvent(ServiceEvent event, Emitter<ServiceState> emit) async {
    super.onEvent(event);
    try {
      emit(ServiceStateLoading());
      var response = await serviceRepository.getService();
      if (response.status == true) {
        emit(ServiceStateSuccess(response));
      } else {
        emit(ServiceStateFailed(response.message ?? ""));
      }
    } catch (_, e) {
      print(e);
      emit(ServiceStateFailed(_.toString()));
    }
  }

  void onServiceSearchEvent(
      ServiceSearchEvent event, Emitter<ServiceState> emit) async {
    super.onEvent(event);
    try {
      emit(ServiceStateLoading());
      var response = await serviceRepository.searchService(
          event.serviceId, event.estateId);
      if (response.status == true) {
        emit(ServiceSearchStateSuccess(response));
      } else {
        emit(ServiceStateFailed(response.message ?? ""));
      }
    } catch (_, e) {
      emit(ServiceStateFailed(_.toString()));
    }
  }

  void postCommentEvent(
      ServicePostCommentEvent event, Emitter<ServiceState> emit) async {
    try {
      emit(ServiceStateLoading());
      var response = await serviceRepository.saveServiceComment(
          event.jobId, event.rating, event.comment);
      var responseComment =
          await serviceRepository.getServiceComment(event.jobId);
      if (response.status == true) {
        emit(ServiceSaveChatStateSuccess(response.message ?? ""));
        emit(ServiceGetChatStateSuccess(responseComment));
      } else {
        emit(ServiceStateFailed(response.message ?? ""));
      }
    } catch (_, e) {
      emit(ServiceStateFailed(_.toString()));
    }
  }

  void getCommentEvent(
      GetCommentEvent event, Emitter<ServiceState> emit) async {
    try {
      emit(ServiceStateLoading());
      var response = await serviceRepository.getServiceComment(event.jobId);
      if (response.status == true) {
        emit(ServiceGetChatStateSuccess(response));
      } else {
        emit(const ServiceStateFailed("request fails to get comments"));
      }
    } catch (_, e) {
      print(e);
      emit(ServiceStateFailed(_.toString()));
    }
  }
}
