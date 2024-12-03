import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/domain/service/auth_service.dart';

import '../../../bloc/registeration_bloc/register_bloc.dart';
import '../../../bloc/registeration_bloc/register_event.dart';
import '../../../bloc/registeration_bloc/register_state.dart';
import '../../../domain/repository/auth_repository.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/mo_button.dart';
import '../../../reuseable/mo_form.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late RegisterBloc registerBloc;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    registerBloc = RegisterBloc(AuthService(AuthRepository()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MoColors.mainColor,
        title: const Text('Reset Password'),
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        bloc: registerBloc,
        builder: (context, state) {
          return Column(
            children: [
              MoFormWidget(
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                title: "Password",
              ),
              MoFormWidget(
                controller: confirmPasswordController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                title: "Confirm Password",
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MoButton(
                        isLoading: state is RegisterLoading,
                        title: "RESET",
                        onTap: () {
                          if (passwordController.text.length < 4 ||
                              confirmPasswordController.text.length < 4) {
                            showErrorBottomSheet(context,
                                "Please you password length to should..");
                            return;
                          }
                          if (isNotEmpty(passwordController.text) &&
                              isNotEmpty(confirmPasswordController.text)) {
                            registerBloc.add(ResetPasswordEvent(
                                widget.email,
                                passwordController.text,
                                confirmPasswordController.text));
                          } else {
                            showErrorBottomSheet(
                                context, "Please provide all entries");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, RegisterState state) {
          switch (state) {
            case RegisterProcessFailure():
              showErrorBottomSheet(context, state.error);
            case RegisterSuccess():
              showSuccessBottomSheet(context, state.message, onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
              });

            default:
              log("state not implemented");
          }
        },
      ),
    );
  }
}
