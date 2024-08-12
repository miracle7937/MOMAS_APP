import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/domain/data/response/user_model.dart';
import 'package:momas_pay/domain/repository/bill_repository.dart';
import 'package:momas_pay/utils/colors.dart';
import '../../bloc/momas_bloc/momas_bloc.dart';
import '../../bloc/momas_bloc/momas_event.dart';
import '../../bloc/momas_bloc/momas_state.dart';
import '../../bloc/service_bloc/service_bloc.dart';
import '../../bloc/service_bloc/service_event.dart';
import '../../bloc/service_bloc/service_state.dart';
import '../../domain/data/response/momas_meter_response.dart';
import '../../domain/data/response/service_data_response.dart';
import '../../domain/repository/service_repository.dart';
import '../../reuseable/bottom_sheet.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/mo_transaction_success_screen.dart';
import '../../reuseable/pop_button.dart';
import '../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../reuseable/shadow_container.dart';
import '../../utils/receipt_builder.dart';
import '../../utils/shared_pref.dart';
import '../../utils/strings.dart';

class MomasPaymentScreen extends StatefulWidget {
  final MomasPaymentType momasPaymentType;

  const MomasPaymentScreen({super.key, required this.momasPaymentType});

  @override
  State<MomasPaymentScreen> createState() => _MomasPaymentScreenState();
}

class _MomasPaymentScreenState extends State<MomasPaymentScreen> {
  late MomasPaymentBloc bloc;
  MomasVerificationResponse? verificationResponse;
  final meterTextFormController = TextEditingController();
  final amountFormController = TextEditingController();
  Estate? selectedEstate;
  late ServiceBloc serviceBloc;
  ServiceDataResponse? serviceDataResponse;
  bool isLoading = false;
  User? user;

  @override
  void initState() {
    super.initState();
    bloc = MomasPaymentBloc(repository: BillRepository());
    load();
    if (widget.momasPaymentType == MomasPaymentType.others) {
      serviceBloc = ServiceBloc(ServiceRepository())
        ..add(const ServicePropertiesEvent());
    }
  }

  load() async {
    user = await SharedPreferenceHelper.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
          bloc: bloc,
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 13,
                      ),
                      Center(
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
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Text("Pay for MOMAS Meter")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      widget.momasPaymentType == MomasPaymentType.others
                          ? Column(
                              children: [
                                BlocConsumer<ServiceBloc, ServiceState>(
                                  bloc: serviceBloc,
                                  builder: (context, state) {
                                    return EPDropdownButton<Estate>(
                                      itemsListTitle: "Choose Estate",
                                      iconSize: 22,
                                      value: selectedEstate,
                                      hint: const Text(""),
                                      isExpanded: true,
                                      underline: const Divider(),
                                      searchMatcher: (item, text) {
                                        return item.title!
                                            .toLowerCase()
                                            .contains(text.toLowerCase());
                                      },
                                      onChanged: (v) {
                                        setState(() {
                                          selectedEstate = v;
                                          verificationResponse= null;
                                        });
                                      },
                                      items: (serviceDataResponse
                                                  ?.data?.estate ??
                                              [])
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Row(
                                                children: [
                                                  Text(e.title.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black)),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                  listener: (BuildContext context,
                                      ServiceState state) {
                                    switch (state) {
                                      case ServiceStateLoading():
                                        setState(() => isLoading = true);
                                      case ServiceStateFailed():
                                        setState(() => isLoading = false);
                                        showErrorBottomSheet(
                                            context, state.error);
                                      case ServiceStateSuccess():
                                        setState(() => isLoading = false);
                                        serviceDataResponse =
                                            state.dataResponse;

                                      default:
                                        log("state not implemented");
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Make payment on your momas meter easily  in few steps",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: MoFormWidget(
                                        controller: meterTextFormController,
                                        keyboardType: TextInputType.number,
                                        prefixIcon: const Icon(
                                          Icons.electric_meter,
                                          color: Colors.grey,
                                        ),
                                        title: "Meter Number",
                                      ),
                                    ),
                                    Expanded(
                                      child: MoButton(
                                        isLoading:
                                            state is MomasVerificationLoading,
                                        title: "VERIFY",
                                        onTap: () {
                                          bloc.add(MomasVerification(
                                              meterNo: meterTextFormController
                                                  .text));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      isNotEmpty(verificationResponse?.data?.customerName)
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MoColors.mainColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        verificationResponse!
                                            .data!.customerName!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MoColors.mainColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      MoFormWidget(
                        controller: amountFormController,
                        keyboardType: TextInputType.number,
                        title: "Amount (NGN)",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text("Min 1,000 | Max 1,000,000",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      MoButton(
                        isLoading: state is MomasPaymentLoading || isLoading,
                        title: "CONTINUE",
                        onTap: () {
                          widget.momasPaymentType == MomasPaymentType.self
                              ? payForSelf()
                              : payForOther();
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (BuildContext context, MomasPaymentState state) {
            switch (state) {
              case MomasPaymentFailure():
                showErrorBottomSheet(context, state.error);
              case MomasMeterVerificationState():
                verificationResponse = state.response;
              case MomasPaymentSuccess():
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => TransactionSuccessPage(
                              details: ReceiptBuilder().meterPayment(
                                  state.momasPaymentResponse.data!),
                            )));
              default:
                log("state not implemented");
            }
          },
        ),
      ),
    );
  }

  payForSelf() {
    var amount = isNotEmpty(amountFormController.text)
        ? int.parse(amountFormController.text)
        : 0;
    if (amount < 1000 || amount > 1000000) {
      showErrorBottomSheet(
          context, "Amount can't exceed the maximum and minimum range");
      return;
    }
    showPaymentModal(context, user!.meterNo!, () {
      MoBottomSheet().payment(context, amount: amountFormController.text,
          onPayment: (String ref) {
        bloc.add(MomasMeterPayment(
            amount: amountFormController.text,
            meterNo: user!.meterNo!,
            meterType: user!.meterType!,
            trxref: ref,
            paymentType: MomasPaymentType.self));
      });
    });
  }

  payForOther() {

    var amount = isNotEmpty(amountFormController.text)
        ? int.parse(amountFormController.text)
        : 0;
    if (amount < 1000 || amount > 1000000) {
      showErrorBottomSheet(
          context, "Amount can't exceed the maximum and minimum range");
      return;
    }

    if(selectedEstate == null){
      showErrorBottomSheet(
          context, "Provide the estate you making the payment for");
      return;
    }
    if(verificationResponse == null || isEmpty(meterTextFormController.text)){
      showErrorBottomSheet(
          context, "Verify meter number before payment");
      return;
    }
    showPaymentModal(context, user!.meterNo!, () {
      MoBottomSheet().payment(context, amount: amountFormController.text,
          onPayment: (String ref) {
            bloc.add(MomasMeterPayment(
                amount: amountFormController.text,
                meterNo: meterTextFormController.text,
                meterType: verificationResponse!.data!.meterType!,
                trxref: ref,
                estateId: selectedEstate!.id.toString(),
                paymentType: MomasPaymentType.others));
          });
    });
  }

  void showPaymentModal(
      BuildContext context, String meter, VoidCallback onYesPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.payment,
                  size: 50,
                  color: MoColors.mainColorII,
                ),
                const SizedBox(height: 20),
                Text(
                  'Pay for Meter :$meter',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Would you like to proceed with the payment for the meter?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onYesPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MoColors.mainColorII,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'Yes, Pay',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        // Handle cancel action here if needed
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: MoColors.mainColorII),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 16, color: MoColors.mainColorII),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
