import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:momaspayplus/bloc/data_bloc/data_state.dart';
import 'package:momaspayplus/domain/data/response/data_response.dart';
import 'package:momaspayplus/domain/repository/bill_repository.dart';

import '../../bloc/data_bloc/data_bloc.dart';
import '../../bloc/data_bloc/data_event.dart';
import '../../bloc/payment_bloc/payment_bloc.dart';
import '../../reuseable/bottom_sheet.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/network_selector.dart';
import '../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../utils/network_enum.dart';
import '../auth/registation/registration_success_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Network? _selectedNetwork;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DataResponse? dataResponse;
  late DataBloc dataBloc;
  DataPlan? selectedDataPlan;

  Contact? _contact;
  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  void _selectNetwork(Network network) {
    setState(() {
      _selectedNetwork = network;
    });
    // Callback to return the selected network
    if (kDebugMode) {
      print('Selected Network: ${network.name}');
      print(
          'data response Network: ${dataResponse?.dataMap[network.displayName]}');
    }
  }

  @override
  void initState() {
    super.initState();
    dataBloc = DataBloc(repository: BillRepository())..add(const GetData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Data Bundle'),
      ),
      body: BlocProvider(
        create: (context) => DataBloc(repository: BillRepository()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<DataBloc, DataState>(
            bloc: dataBloc,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Network',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    NetworkSelector(
                      selectedNetwork: _selectedNetwork,
                      onSelectNetwork: (network) => _selectNetwork(network),
                    ),
                    EPDropdownButton<DataPlan>(
                        itemsListTitle: "Select Plan",
                        iconSize: 22,
                        value: selectedDataPlan,
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
                            selectedDataPlan = v;
                          });
                        },
                        items: (dataResponse
                                    ?.dataMap[_selectedNetwork?.displayName] ??
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
                    Row(
                      children: [
                        Expanded(
                          child: MoFormWidget(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            title: "Phone Number",
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Contact? contact =
                                await _contactPicker.selectContact();
                            setState(() {
                              _contact = contact;
                            });
                            _phoneController.text =
                                _contact?.phoneNumbers?.first ?? "";
                          },
                          child: const Column(
                            children: [
                              SizedBox(
                                height: 53,
                              ),
                              Icon(
                                Icons.perm_contact_cal_outlined,
                                size: 40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    selectedDataPlan != null
                        ? MoFormWidget(
                            enable: false,
                            controller: TextEditingController(
                                text:
                                    "NGN ${selectedDataPlan?.variationAmount}"),
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
                      isLoading: state is DataLoading,
                      title: "BUY NOW",
                      onTap: () {
                        String serviceId = _selectedNetwork!.name.toLowerCase();
                        String? variantCode = selectedDataPlan?.variationCode;
                        final String amount =
                            selectedDataPlan?.variationAmount ?? "0";
                        final String phone = _phoneController.text;
                        if (selectedDataPlan != null) {
                          MoBottomSheet().payment(context,
                              amount: amount, serviceType: ServiceType.data,
                              onPayment: (String ref) {
                            dataBloc.add(
                              BuyData(
                                  serviceId: serviceId,
                                  amount: amount,
                                  phone: phone,
                                  variationCode: variantCode ?? "",
                                  ref: ref),
                            );
                          });
                        } else {
                          showErrorBottomSheet(
                              context, "Please select data plan");
                        }
                      },
                    )
                  ],
                ),
              );
            },
            listener: (BuildContext context, DataState state) {
              switch (state) {
                case DataFailure():
                  showErrorBottomSheet(context, state.error);
                case DataSuccess():
                  dataResponse = state.response;
                case BuyDataSuccess():
                  showSuccessBottomSheet(context, state.response.message ?? "");
                default:
                  log("state not implemented");
              }
            },
          ),
        ),
      ),
    );
  }
}
