import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';

import '../../bloc/setting_bloc/setting_bloc.dart';
import '../../bloc/setting_bloc/setting_event.dart';
import '../../bloc/setting_bloc/setting_state.dart';
import '../../domain/repository/setting_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_form.dart';

class RequestMeterScreen extends StatefulWidget {
  const RequestMeterScreen({super.key});

  @override
  State<RequestMeterScreen> createState() => _RequestMeterScreenState();
}

class _RequestMeterScreenState extends State<RequestMeterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late SettingsBloc settingsBloc;

  @override
  void initState() {
    super.initState();
    settingsBloc = SettingsBloc(SettingRepository())
      ..add(SupportSettingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Meter"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          bloc: settingsBloc,
          builder: (context, state) {
            return Column(
              children: [
                MoFormWidget(
                  controller: fullNameController,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  title: "Full Name",
                ),
                MoFormWidget(
                  controller: emailController,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  title: "Email Address",
                ),
                MoFormWidget(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  title: "Phone Number",
                ),
                MoFormWidget(
                  controller: addressController,
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  title: "Address",
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MoButton(
                      isLoading: state is SettingsStateLoading,
                      title: "Submit",
                      onTap: () {
                        settingsBloc.add(RequestMeterEvent(
                            emailController.text,
                            fullNameController.text,
                            phoneController.text,
                            addressController.text));
                      }),
                )
              ],
            );
          },
          listener: (BuildContext context, SettingsState state) {
            switch (state) {
              case SettingsStateFailed():
                showErrorBottomSheet(context, state.error);
              case SettingsSupportStateSuccess():
                showSuccessBottomSheet(context, state.message);
              default:
                log("state not implemented");
            }
          },
        ),
      ),
    );
  }
}
