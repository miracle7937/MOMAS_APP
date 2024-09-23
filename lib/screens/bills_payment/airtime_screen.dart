import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:momas_pay/domain/repository/bill_repository.dart';
import 'package:momas_pay/utils/colors.dart';

import '../../bloc/airtime_bloc/airtime_bloc.dart';
import '../../bloc/airtime_bloc/airtime_event.dart';
import '../../bloc/airtime_bloc/airtime_state.dart';
import '../../reuseable/bottom_sheet.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/network_selector.dart';
import '../../utils/network_enum.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  _AirtimeScreenState createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  Network? _selectedNetwork;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  Contact? _contact;

  void _selectNetwork(Network network) {
    setState(() {
      _selectedNetwork = network;
    });
    // Callback to return the selected network
    if (kDebugMode) {
      print('Selected Network: ${network.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MoColors.mainColor,
        title: const Text('Airtime'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => AirtimeBloc(repository: BillRepository()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Network', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                NetworkSelector(
                  selectedNetwork: _selectedNetwork,
                  onSelectNetwork: (network) => _selectNetwork(network),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        Contact? contact = await _contactPicker.selectContact();
                        setState(() {
                          _contact = contact == null ? null : contact;
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
                MoFormWidget(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(
                    Icons.wallet,
                    color: Colors.grey,
                  ),
                  title: "Amount",
                ),
                const SizedBox(height: 20),
                BlocConsumer<AirtimeBloc, AirtimeState>(
                  builder: (context, state) {
                    return MoButton(
                      isLoading: state is AirtimeLoading,
                      title: "BUY NOW",
                      onTap: () {
                        if (_selectedNetwork == null) {
                          showErrorBottomSheet(
                              context, "Please select network");
                          return;
                        }
                        String serviceId = _selectedNetwork!.name.toLowerCase();
                        final String amount = _amountController.text;
                        final String phone = _phoneController.text;
                        MoBottomSheet().payment(context,
                            amount: amount,
                            service: "Airtime", onPayment: (String ref) {
                          BlocProvider.of<AirtimeBloc>(context).add(
                            BuyAirtime(
                              ref: ref,
                              serviceId: serviceId,
                              amount: amount,
                              phone: phone,
                            ),
                          );
                        });
                      },
                    );
                  },
                  listener: (BuildContext context, AirtimeState state) {
                    switch (state) {
                      case AirtimeFailure():
                        showErrorBottomSheet(context, state.error);
                      case AirtimeSuccess():
                        showSuccessBottomSheet(
                            context, state.response.message ?? "");
                      default:
                        log("state not implemented");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
