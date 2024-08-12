import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/bloc/login_bloc/login_bloc.dart';
import 'package:momas_pay/domain/repository/auth_repository.dart';
import 'package:momas_pay/domain/service/auth_service.dart';
import 'package:momas_pay/screens/auth/email_screen.dart';
import 'package:momas_pay/screens/dashboard/root_screen.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:momas_pay/utils/shared_pref.dart';

import '../../bloc/login_bloc/login_event.dart';
import '../../bloc/login_bloc/login_state.dart';
import '../../domain/data/request/login.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../utils/bio_metric.dart';
import '../../utils/images.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController generalController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoColors.mainColorII,
      body: BlocProvider(
        create: (context) => LoginBloc(AuthService(AuthRepository())),
        child: BlocConsumer<LoginBloc, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
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
                          const Spacer(),
                          Center(child: Image.asset(MoImage.logo)),
                          const Spacer(),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome Back",
                                style: TextStyle(
                                    fontSize: 32, color: Colors.white),
                              ),
                              Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
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
                          controller: generalController,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          title: "Email / Meter Number",
                        ),
                        MoFormWidget(
                          controller: passwordController,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          title: "Password",
                          isPassword: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 15),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                "Forgot Password",
                                style: TextStyle(color: MoColors.mainColor),
                              )
                            ],
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
                                  title: "LOGIN",
                                  isLoading: context.watch<LoginBloc>().state
                                      is LoginLoading,
                                  onTap: () {
                                    var meterNo = "";
                                    var email = "";
                                    if (FormValidators.isValidEmail(email)) {
                                      email = generalController.text;
                                    } else {
                                      meterNo = generalController.text;
                                    }
                                    final password = passwordController.text;
                                    final login = Login(
                                        meterNo: meterNo,
                                        password: password,
                                        email: email);
                                    context
                                        .read<LoginBloc>()
                                        .add(UserLoginEvent(login));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              FutureBuilder<List<dynamic>>(
                                  future: Future.wait([
                                    SharedPreferenceHelper.getLogin(),
                                    BioMetric().isBiometricAvailable()
                                  ]),
                                  builder: (context, snapshot) {
                                    return (snapshot.data?[0] != null ||
                                            snapshot.data?[1] == true)
                                        ? InkWell(
                                            onTap: () {
                                              context.read<LoginBloc>().add(
                                                  UserLoginEvent(
                                                      snapshot.data?[0]));
                                            },
                                            child: Image.asset(
                                                MoImage.fingerPrint))
                                        : Container();
                                  }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'New on MOMAS PAY?  ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              TextSpan(
                                text: 'Register Here!',
                                style: TextStyle(
                                    color: MoColors.mainColor, fontSize: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const EmailScreen()));
                                  },
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
          listener: (BuildContext context, LoginState state) {
            switch (state) {
              case LoginFailure():
                showErrorBottomSheet(context, state.error);
              case LoginSuccess():
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RootScreen()),
                    (v) => false);
              default:
                log("state not implemented");
            }
          },
        ),
      ),
    );
  }
}
