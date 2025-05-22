

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/data/request/cable_tv_request.dart';
import '../../domain/data/response/cable_tv_response.dart';
import '../../domain/data/response/cable_tv_verification_response.dart';
import '../../domain/data/response/generic_response.dart';
import '../../domain/repository/bill_repository.dart';
import 'cable_event.dart';
import 'cable_tv_state.dart';

class CableTvBloc extends Bloc<CableTvEvent, CableTvState> {
  final BillRepository repository;

  CableTvBloc({required this.repository}) : super(CableTvInitial()){
    on<BuyCableTv>((event, emit) async {
      await mapEventToState(event, emit);

    });

    on<GetCableTv>((event, emit) async {
      await getCableTv(event, emit);
    });

    on<VerifyDecoderTv>((event, emit) async {
      await verifyCableTv(event, emit);
    });

  }

  Future mapEventToState(CableTvEvent event,  Emitter<CableTvState> emit) async {
    if (event is BuyCableTv) {
      emit(CableTvLoading());
      try {
        final CableTvRequest request = CableTvRequest(
            amount: event.amount,
            variationCode: event.variationCode,
            quantity: event.quantity,
          decoderNo: event.decoderNo,
          decoderType: event.decoderType,
          subscriptionType: event.subscriptionType
        );
        final GenericResponse response = await repository.buyCableTv(request);
        if(response.status ==true){
          emit(BuyCableTvSuccess(response: response));
        }else{
          emit(CableTvFailure(error: response.message ?? ""));
        }
      } catch (e) {
        emit(CableTvFailure(error: e.toString()));
      }
    }
  }

  Future getCableTv(CableTvEvent event,  Emitter<CableTvState> emit) async {
    if (event is GetCableTv) {
      emit(CableTvLoading());
      try {
        final CableTvResponse response = await repository.getCableTv();
        if(response.status ==true){
          emit(CableTvSuccess(response: response));
        }else{
          emit(const CableTvFailure(error:  "failed request to get CableTv plans"));
        }
      } catch (e) {
        emit(CableTvFailure(error: e.toString()));
      }
    }
  }

  Future verifyCableTv(VerifyDecoderTv event,  Emitter<CableTvState> emit) async {
      emit(CableTvVerificationLoading());
      try {
        final CableTvVerificationResponse response = await repository.verifyCable(event.decoderType, event.decoderNo);
        if(response.status ==true){
          emit(CableTvVerificationSuccess(response: response));
        }else{
          emit(const CableTvFailure(error:  "failed request to get CableTv plans"));
        }
      } catch (e) {
        emit(CableTvFailure(error: e.toString()));
      }
  }
}
