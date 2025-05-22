import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:momaspayplus/bloc/cable_tv/cable_tv_bloc.dart';
import 'package:momaspayplus/domain/data/response/cable_tv_response.dart';
import '../../bloc/cable_tv/cable_event.dart';
import '../../bloc/cable_tv/cable_tv_state.dart';
import '../../bloc/data_bloc/data_state.dart';
import '../../bloc/payment_bloc/payment_bloc.dart';
import '../../domain/data/response/cable_tv_verification_response.dart';
import '../../domain/repository/bill_repository.dart';
import '../../reuseable/bottom_sheet.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/network_selector.dart';
import '../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../utils/network_enum.dart';
import '../../utils/strings.dart';
import '../auth/registation/registration_success_screen.dart';

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen> {
  CableEnum? _selectedCable;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _decoderNumber = TextEditingController();
  CableTvResponse? cableTvResponse;
  CableTvVerificationResponse? cableTvVerificationResponse;
  late CableTvBloc cableTvBloc;
  CableData? selectedCableTvPlan;
  var subscriptionTypes = ["renew", "new"];
  var selectedSubscriptionTypes = "";
  var numberOfMonth = "1";

  void _selectNetwork(CableEnum network) {
    setState(() {
      _selectedCable = network;
    });
    // Callback to return the selected network
    if (kDebugMode) {
      print('Selected Network: ${network.name}');
      print('data response Network: ${cableTvResponse?.dataMap[network.name]}');
    }
  }

  @override
  void initState() {
    super.initState();
    cableTvBloc = CableTvBloc(repository: BillRepository())
      ..add(const GetCableTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Cable Tv'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => CableTvBloc(repository: BillRepository()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<CableTvBloc, CableTvState>(
              bloc: cableTvBloc,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select cable tv',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      CableTvSelector(
                        selectedNetwork: _selectedCable,
                        onSelectNetwork: (network) => _selectNetwork(network),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: MoFormWidget(
                              controller: _decoderNumber,
                              keyboardType: TextInputType.number,
                              hintText: '',
                              title: "Decoder Number",
                              onChange: (query) {},
                            ),
                          ),
                          Expanded(
                              child: MoButton(
                            isLoading: state is CableTvVerificationLoading,
                            title: "Verify",
                            onTap: () {
                              if (isNotEmpty(_selectedCable?.name) &&
                                  isNotEmpty(_decoderNumber.text)) {
                                cableTvBloc.add(VerifyDecoderTv(
                                    decoderType: _selectedCable!.name,
                                    decoderNo: _decoderNumber.text));
                              } else {
                                showErrorBottomSheet(
                                    context, "Provide decoder data to verify");
                              }
                            },
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isNotEmpty(
                              cableTvVerificationResponse?.data?.customerName)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                cableTvVerificationResponse
                                        ?.data?.customerName ??
                                    "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            )
                          : Container(),
                      EPDropdownButton<CableData>(
                          itemsListTitle: "Select Plan",
                          iconSize: 22,
                          value: selectedCableTvPlan,
                          hint: const Text(""),
                          isExpanded: true,
                          underline: const Divider(),
                          searchMatcher: (item, text) {
                            return item.name!
                                .toLowerCase()
                                .contains(text.toLowerCase());
                          },
                          onChanged: (v) {
                            setState(() {
                              selectedCableTvPlan = v;
                            });
                          },
                          items: (cableTvResponse
                                      ?.dataMap[_selectedCable?.name] ??
                                  [])
                              .map(
                                (e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text(e.name.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                      ],
                                    )),
                              )
                              .toList()),
                      const SizedBox(height: 20),
                      EPDropdownButton<String>(
                          itemsListTitle: "Subscription Type",
                          iconSize: 22,
                          value: selectedSubscriptionTypes,
                          hint: const Text(""),
                          isExpanded: true,
                          underline: const Divider(),
                          searchMatcher: (item, text) {
                            return item
                                .toLowerCase()
                                .contains(text.toLowerCase());
                          },
                          onChanged: (v) {
                            setState(() {
                              selectedSubscriptionTypes = v;
                            });
                          },
                          items: subscriptionTypes
                              .map(
                                (e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text(e.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                      ],
                                    )),
                              )
                              .toList()),
                      const SizedBox(height: 10),
                      selectedSubscriptionTypes == "new"
                          ? EPDropdownButton<String>(
                              itemsListTitle: "Number of Month",
                              iconSize: 22,
                              value: numberOfMonth,
                              hint: const Text(""),
                              isExpanded: true,
                              underline: const Divider(),
                              searchMatcher: (item, text) {
                                return item
                                    .toLowerCase()
                                    .contains(text.toLowerCase());
                              },
                              onChanged: (v) {
                                setState(() {
                                  numberOfMonth = v;
                                });
                              },
                              items:
                                  List.generate(12, (v) => (v + 1).toString())
                                      .map(
                                        (e) => DropdownMenuItem(
                                            value: e,
                                            child: Row(
                                              children: [
                                                Text("$e Month",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black)),
                                              ],
                                            )),
                                      )
                                      .toList())
                          : Container(),
                      const SizedBox(height: 10),
                      selectedCableTvPlan != null
                          ? MoFormWidget(
                              enable: false,
                              controller: TextEditingController(
                                  text:
                                      "NGN ${selectedCableTvPlan?.variationAmount}"),
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(
                                Icons.wallet,
                                color: Colors.grey,
                              ),
                              title: "Amount",
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      MoButton(
                        isLoading: state is CableTvLoading,
                        title: "PAY NOW",
                        onTap: () {
                          if (cableTvVerificationResponse == null) {
                            showErrorBottomSheet(context,
                                "Please verify decoder before payment.");
                            return;
                          }
                          String? variantCode =
                              selectedCableTvPlan?.variationCode;
                          final String amount =
                              selectedCableTvPlan?.variationAmount ?? "0";
                          if (selectedCableTvPlan != null) {
                            MoBottomSheet().payment(context,
                                serviceType: ServiceType.cable,
                                amount: amount, onPayment: (String ref) {
                              cableTvBloc.add(
                                BuyCableTv(
                                    ref: ref,
                                    quantity: numberOfMonth,
                                    subscriptionType:
                                        selectedSubscriptionTypes == "renew"
                                            ? "renew"
                                            : "",
                                    decoderType: _selectedCable!.name,
                                    decoderNo: _decoderNumber.text,
                                    amount: amount,
                                    variationCode: variantCode ?? ""),
                              );
                            });
                          } else {
                            showErrorBottomSheet(
                                context, "Please select tv plan");
                          }
                        },
                      )
                    ],
                  ),
                );
              },
              listener: (BuildContext context, CableTvState state) {
                switch (state) {
                  case CableTvFailure():
                    showErrorBottomSheet(context, state.error);
                  case CableTvSuccess():
                    cableTvResponse = state.response;
                  case CableTvVerificationSuccess():
                    cableTvVerificationResponse = state.response;
                  case BuyCableTvSuccess():
                    showSuccessBottomSheet(
                        context, state.response.message ?? "");
                  default:
                    log("state not implemented");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
