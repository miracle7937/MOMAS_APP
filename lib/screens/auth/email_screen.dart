import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/screens/auth/login.dart';

import '../../bloc/registeration_bloc/register_bloc.dart';
import '../../bloc/registeration_bloc/register_event.dart';
import '../../bloc/registeration_bloc/register_state.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/service/auth_service.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import 'email_code_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: BlocProvider(
          create: (context) =>
              RegisterBloc(AuthService(AuthRepository()))
          ,
          child: BlocConsumer<RegisterBloc, RegisterState>(
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Center(child: Image.asset(MoImage.logo)),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Email Verification",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.7,
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
                          MoFormWidget(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            title: "Email",
                          ),
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.1,
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
                                          CheckEmailEvent(
                                              emailController.text));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already has an account?   ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                                TextSpan(
                                  text: 'Login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator
                                          .of(context)
                                          .push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                              const LoginScreen()));},
                                  style: TextStyle(
                                      color: MoColors.mainColor, fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, RegisterState state) {
              switch (state) {
                case RegisterProcessFailure():
                  showErrorBottomSheet(context, state.error);
                case EmailCheckSuccess():
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              EmailCodeScreen(
                                email: state.email,
                              )));
                case EmailCheckFail():
                  showErrorBottomSheet(context, state.error);
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
