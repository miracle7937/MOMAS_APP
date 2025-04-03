import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/time_util.dart';

import '../../bloc/momas_bloc/momas_bloc.dart';
import '../../bloc/momas_bloc/momas_event.dart';
import '../../bloc/momas_bloc/momas_state.dart';
import '../../domain/data/response/meter_payment_response.dart';
import '../../domain/repository/bill_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/mo_transaction_success_screen.dart';
import '../../reuseable/pop_button.dart';
import '../../reuseable/shadow_container.dart';
import '../../utils/amount_formatter.dart';
import '../../utils/receipt_builder.dart';

class ReprintTokenScreen extends StatefulWidget {
  ReprintTokenScreen({super.key});

  @override
  State<ReprintTokenScreen> createState() => _ReprintTokenScreenState();
}

class _ReprintTokenScreenState extends State<ReprintTokenScreen> {
  late MomasPaymentBloc bloc;
  List<MeterData>? meterDataList = [];
  List<MeterData>? filteredMeterDataList = [];

  @override
  void initState() {
    bloc = MomasPaymentBloc(repository: BillRepository())
      ..add(const MomasPaymentHistory());
    super.initState();
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMeterDataList = List.from(meterDataList!);
      });
    } else {
      setState(() {
        filteredMeterDataList = meterDataList!.where((data) {
          return data.token!.contains(query) || data.orderId!.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: ShadowContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width - 15,
                          child: Row(
                            children: [
                              PopButton().pop(context),
                              const SizedBox(width: 20),
                              const Text("Make Payment for MOMAS"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Easily reprint all purchased token',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      MoFormWidget(
                        prefixIcon:
                            Icon(Icons.search, color: MoColors.mainColor),
                        hintText: "Search",
                        onChange: (value) {
                          _filterData(value);
                        },
                      ),
                    ],
                  ),
                ),
                state is MomasPaymentLoading
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
                          itemCount: filteredMeterDataList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) =>
                                        TransactionSuccessPage(
                                      details: ReceiptBuilder().meterHistory(
                                          filteredMeterDataList![index]),
                                    ),
                                  ),
                                );
                              },
                              child: TokenCard(
                                  token: filteredMeterDataList![index]),
                            );
                          },
                        ),
                      ),
              ],
            );
          },
          listener: (BuildContext context, MomasPaymentState state) {
            if (state is MomasPaymentFailure) {
              showErrorBottomSheet(context, state.error);
            } else if (state is MomasMeterSuccess) {
              meterDataList = state.meterPaymentResponse.data;
              filteredMeterDataList = List.from(meterDataList!);
            } else {
              log("State not implemented");
            }
          },
        ),
      ),
    );
  }
}

class TokenCard extends StatelessWidget {
  final MeterData token;

  const TokenCard({super.key, required this.token});

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
                    child: const Icon(
                      Icons.receipt,
                      color: Colors.green,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${token.orderId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(token.token ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          )),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TimeUtil.formatMMMMDY(token.createdAt ?? ""),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AmountFormatter.formatNaira(token.amount!.toDouble()),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
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
