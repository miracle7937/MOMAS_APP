import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/access_token_bloc/access_token_bloc.dart';
import '../../bloc/access_token_bloc/access_token_event.dart';
import '../../bloc/access_token_bloc/access_token_state.dart';
import '../../domain/repository/access_token_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';

class AccessTokenVerification extends StatefulWidget {
  const AccessTokenVerification({super.key});

  @override
  State<AccessTokenVerification> createState() =>
      _AccessTokenVerificationState();
}

class _AccessTokenVerificationState extends State<AccessTokenVerification> {
  final TextEditingController tokenController = TextEditingController();
  late AccessTokenBloc accessTokenBloc;


  @override
  void initState() {
    accessTokenBloc = AccessTokenBloc(repository: AccessTokenRepository());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Access Token"),
      ),
      body: BlocConsumer<AccessTokenBloc, AccessTokenState>(
          bloc: accessTokenBloc,
          builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MoFormWidget(
                  controller: tokenController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(
                    Icons.token,
                    color: Colors.grey,
                  ),
                  title: "Enter Token",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: MoButton(
                    isLoading: state is AccessTokenLoading,
                    title: "CONTINUE",
                    onTap: () {
                      accessTokenBloc.add(VerifyAccessToken(tokenController.text));
                    },
                  ),
                )
              ],
            ),
          );
        }, listener: (BuildContext context, AccessTokenState state) {

        switch (state) {
          case AccessTokenFailed():
            showErrorBottomSheet(context, state.error);
          case VerifyTokenSuccess():
            showSuccessBottomSheet(context, state.message);
          default:
            log("state not implemented");
        }
      },
      ),
    );
  }
}
