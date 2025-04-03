
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/domain/data/response/data_response.dart';

import '../../domain/data/request/data_request.dart';
import '../../domain/data/response/generic_response.dart';
import '../../domain/repository/bill_repository.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final BillRepository repository;

  DataBloc({required this.repository}) : super(DataInitial()){
    on<BuyData>((event, emit) async {
      await mapEventToState(event, emit);

    });

    on<GetData>((event, emit) async {
      await getData(event, emit);

    });

  }

  Future mapEventToState(DataEvent event,  Emitter<DataState> emit) async {

    if (event is BuyData) {
      emit(DataLoading());
      try {
        final DataRequest request = DataRequest(
          serviceId: event.serviceId,
          amount: event.amount,
          phone: event.phone,
          variationCode: event.variationCode,
            ref: event.ref

        );
        final GenericResponse response = await repository.buyData(request);
        if(response.status ==true){
          emit(BuyDataSuccess(response: response));
        }else{
          emit(DataFailure(error: response.message ?? ""));
        }
      } catch (e) {
        emit(DataFailure(error: e.toString()));
      }
    }
  }

  Future getData(DataEvent event,  Emitter<DataState> emit) async {
    if (event is GetData) {
      emit(DataLoading());
      try {
        final DataResponse response = await repository.getData();
        if(response.status ==true){
          emit(DataSuccess(response: response));
        }else{
          emit(const DataFailure(error:  "failed request to get data plans"));
        }
      } catch (e) {
        emit(DataFailure(error: e.toString()));
      }
    }
  }
}
