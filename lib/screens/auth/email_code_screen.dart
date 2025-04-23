import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/screens/auth/reset_password/reset_passord_screen.dart';

import '../../bloc/registeration_bloc/register_bloc.dart';
import '../../bloc/registeration_bloc/register_event.dart';
import '../../bloc/registeration_bloc/register_state.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/service/auth_service.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_passcode.dart';
import '../../reuseable/pop_button.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../dashboard/root_screen.dart';
import 'registation/account_setup.dart';

class EmailCodeScreen extends StatefulWidget {
  final String email;
  final PassCode passCode;

  const EmailCodeScreen(
      {super.key, required this.email, this.passCode = PassCode.register});

  @override
  State<EmailCodeScreen> createState() => _EmailCodeScreenState();
}

class _EmailCodeScreenState extends State<EmailCodeScreen> {
  String _code = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: BlocProvider(
          create: (context) => RegisterBloc(AuthService(AuthRepository())),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: const [0.5, 0.8],
                            colors: [
                              MoColors.mainColor,
                              MoColors.mainColorII,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(100)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  PopButton().pop(context),
                                  const Spacer(),
                                  Center(
                                      child: Image.asset(
                                    MoImage.logo,
                                    width: 150,
                                  )),
                                ],
                              ),
                              const Spacer(),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Code Validation",
                                    style: TextStyle(
                                        fontSize: 23, color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(100)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: '4 Digit code has been sent to '),
                                TextSpan(
                                  text: widget.email,
                                  style: TextStyle(
                                      color: MoColors.mainColorII,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                    text:
                                        '.\nCheck your inbox or spam folder.'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: DynamicPasscodeForm(
                              title: 'Enter Passcode',
                              passcodeLength: 4,
                              onPasscodeEntered: (v) {
                                _code = v;
                                log("Miracle $v");
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MoButton(
                                    isLoading: context
                                        .watch<RegisterBloc>()
                                        .state is RegisterLoading,
                                    title: "CONTINUE",
                                    onTap: () {
                                      context.read<RegisterBloc>().add(
                                          VerifyEmailEvent(
                                              widget.email, _code));
                                      // Navigator.of(context).push(MaterialPageRoute(builder:
                                      //     (_)=> AccountSetupScreen(email: widget.email,)));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, RegisterState state) {
              switch (state) {
                case EmailVerificationFail():
                  showErrorBottomSheet(context, state.error);
                case EmailVerificationSuccess():
                  if (widget.passCode == PassCode.register) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => AccountSetupScreen(
                              email: widget.email,
                            )));
                  } else if (widget.passCode == PassCode.resetPassword) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ResetPasswordScreen(
                              email: widget.email,
                            )));
                  }

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

enum PassCode { register, resetPassword }
