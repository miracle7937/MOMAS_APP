


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/utils/strings.dart';

import '../../../bloc/payment_bloc/payment_bloc.dart';
import '../../../bloc/payment_bloc/payment_event.dart';
import '../../../bloc/payment_bloc/payment_state.dart';
import '../../../domain/data/response/transaction_data_response.dart';
import '../../../domain/repository/payment_repository.dart';
import '../../../reuseable/mo_form.dart';
import '../../../reuseable/mo_transaction_success_screen.dart';
import '../../../reuseable/pop_button.dart';
import '../../../reuseable/shadow_container.dart';
import '../../../utils/colors.dart';
import '../../../utils/receipt_builder.dart';
import '../../../utils/time_util.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late PaymentBloc paymentBloc;
  List<TransactionData>? transactionDataList = [];
  List<TransactionData>? filteredTransactionDataList = [];
  @override
  void initState() {
    super.initState();
    paymentBloc = PaymentBloc(PaymentRepository())..add(const SearchPayment());
  }


  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTransactionDataList = List.from(transactionDataList!);
      });
    } else {
      setState(() {
        filteredTransactionDataList = transactionDataList!.where((data) {
          return data.payType!.contains(query) || data.trxId!.contains(query);
        }).toList();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<PaymentBloc, PaymentState>(
            bloc: paymentBloc,
            builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: ShadowContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 15,
                          child: const Row(
                            children: [
                              // PopButton().pop(context),
                              SizedBox(width: 20),
                              Text("Search Transaction"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 16.0),
                      MoFormWidget(
                        prefixIcon: Icon(Icons.search, color: MoColors.mainColor),
                        hintText: "Search",
                        onChange: (value) {
                          _filterData(value);
                        },
                      ),
                    ],
                  ),
                ),
                state is PaymentLoading
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: MoColors.mainColorII,
                      size: 50.0,
                    )
                  ],
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: filteredTransactionDataList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => TransactionSuccessPage(
                                details: ReceiptBuilder().transactionHistory(
                                    filteredTransactionDataList![index]),
                              ),
                            ),
                          );
                        },
                        child: TransactionCard(data: filteredTransactionDataList![index]),
                      );
                    },
                  ),
                ),
              ],
            );
          }, listener: (BuildContext context, PaymentState state) {
          if (state is PaymentHistorySuccess) {
            transactionDataList = state.data;
            filteredTransactionDataList = List.from(transactionDataList!);
          }
          else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );


          }
        },
        ),
      ),
    );
  }
}


class TransactionCard extends StatelessWidget {
  final TransactionData data;

  const TransactionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ShadowContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.receipt, color: Colors.green, size: 15,),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NGN${data.amount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text( isNotEmpty(data.note)? "${data.note}" : "|${data.payType}", style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      )),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(TimeUtil.formatMMMMDY(data.createdAt ?? "")
                      , style: const TextStyle(fontSize: 10),),
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(color:data.status!.color, borderRadius: BorderRadius.circular(18) ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.status.toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}