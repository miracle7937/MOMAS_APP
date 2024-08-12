import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:momas_pay/bloc/access_token_bloc/access_token_bloc.dart';
import 'package:momas_pay/bloc/access_token_bloc/access_token_event.dart';
import 'package:momas_pay/bloc/access_token_bloc/access_token_state.dart';
import 'package:momas_pay/domain/data/request/set_estate_request.dart';
import 'package:momas_pay/domain/data/response/estate_response.dart';
import 'package:momas_pay/domain/repository/access_token_repository.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:momas_pay/utils/images.dart';
import 'package:momas_pay/utils/strings.dart';

import '../../domain/data/request/generate_token_request.dart';
import '../../domain/data/response/user_model.dart';
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

class AccessTokenScreen extends StatefulWidget {
  const AccessTokenScreen({super.key});

  @override
  State<AccessTokenScreen> createState() => _AccessTokenScreenState();
}

class _AccessTokenScreenState extends State<AccessTokenScreen> {
  late AccessTokenBloc accessTokenBloc;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _expectedVisitorController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  EstateData? selectedEstateData;
  bool continueNext = false;
  bool _switchValue = false;

  @override
  void initState() {
    accessTokenBloc = AccessTokenBloc(repository: AccessTokenRepository())
      ..add(const GetAccessToken());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => accessTokenBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<User?>(
            future: SharedPreferenceHelper.getUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: MoColors.mainColor,
                      size: 30.0,
                    ),
                  ),
                );
              }

              if (isEmpty(snapshot.data?.estateId)) {
                return BlocConsumer<AccessTokenBloc, AccessTokenState>(
                  bloc: accessTokenBloc,
                  builder: (context, state) {
                    List<EstateData> estateData =
                        (state is AccessTokenSuccess) ? state.estateData : [];
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                width:
                                    MediaQuery.of(context).size.height * 0.13,
                                child: Lottie.asset(MoImage.estate)),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Please there is no estate assign to you",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            EPDropdownButton<EstateData>(
                                itemsListTitle: "Selected estate",
                                iconSize: 22,
                                value: selectedEstateData,
                                hint: const Text(""),
                                isExpanded: true,
                                underline: const Divider(),
                                searchMatcher: (item, text) {
                                  return ("${item.title!}  ${item..state}")
                                      .toLowerCase()
                                      .contains(text.toLowerCase());
                                },
                                onChanged: (v) {
                                  setState(() {
                                    selectedEstateData = v;
                                  });
                                },
                                items: estateData
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
                                                              FontWeight.w400,
                                                          color: Colors.black)),
                                            ],
                                          )),
                                    )
                                    .toList()),
                            Row(
                              children: [
                                Expanded(
                                  child: MoFormWidget(
                                    controller: _flatNoController,
                                    keyboardType: TextInputType.number,
                                    title: "FLAT/NO",
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: MoFormWidget(
                                    controller: _addressController,
                                    keyboardType: TextInputType.streetAddress,
                                    title: "Address",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            MoButton(
                                isLoading: state is AccessTokenLoading,
                                title: "Proceed",
                                onTap: () {
                                  setState(() {
                                    continueNext = true;
                                  });
                                  if (selectedEstateData != null &&
                                      isNotEmpty(_addressController.text) &&
                                      isNotEmpty(_flatNoController.text)) {
                                    var data = SetEstateRequest(
                                        _addressController.text,
                                        _flatNoController.text,
                                        selectedEstateData?.id.toString());
                                    accessTokenBloc.add(SetEstate(data));
                                  } else {
                                    showErrorBottomSheet(
                                        context, "Please provide all entries");
                                  }
                                })
                          ],
                        ),
                      ),
                    );
                  },
                  listener:
                      (BuildContext context, AccessTokenState state) async {
                    switch (state) {
                      case AccessTokenFailed():
                        showErrorBottomSheet(context, state.error);
                      case SetEstateSuccess():
                        showSuccessBottomSheet(
                                context, "Default estate set successfully")
                            .whenComplete(() => Navigator.pop(context));

                      default:
                        log("state not implemented");
                    }
                  },
                );
              }
              return BlocConsumer<AccessTokenBloc, AccessTokenState>(
                bloc: accessTokenBloc,
                builder: (context, state) {
                  List<EstateData>? estateData;
                  if (state is AccessTokenSuccess) {
                    estateData = state.estateData;
                    selectedEstateData =
                        estateData.firstWhere((v) => v.id == 1);
                    // selectedEstateData = estateData.firstWhere((v)=>v.id.toString() == snapshot.data!.estateId);
                  }
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
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
                                    width:
                                        MediaQuery.of(context).size.width - 15,
                                    child: Row(
                                      children: [
                                        PopButton().pop(context),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        const Text("Generate Access Token"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Easily create access token and  share with your visitor',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            EPDropdownButton<EstateData>(
                                disabled: true,
                                itemsListTitle: "Selected estate",
                                iconSize: 22,
                                value: selectedEstateData,
                                hint: const Text(""),
                                isExpanded: true,
                                underline: const Divider(),
                                searchMatcher: (item, text) {
                                  return ("${item.title!}  ${item..state}")
                                      .toLowerCase()
                                      .contains(text.toLowerCase());
                                },
                                onChanged: (v) {
                                  setState(() {
                                    selectedEstateData = v;
                                  });
                                },
                                items: (estateData ?? [])
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
                                                              FontWeight.w400,
                                                          color: Colors.black)),
                                            ],
                                          )),
                                    )
                                    .toList()),
                            MoFormWidget(
                              title: "Expected Visitor",
                              keyboardType: TextInputType.number,
                              controller: _expectedVisitorController,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              child: Row(
                                children: [
                                  const Text("Send Token to Email"),
                                  const Spacer(),
                                  CupertinoSwitch(
                                    value: _switchValue,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _switchValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            _switchValue
                                ? MoFormWidget(
                                    title: "Email",
                                    keyboardType: TextInputType.number,
                                    controller: _emailController,
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MoButton(
                                      isLoading: state is AccessTokenLoading,
                                      title: "CONTINUE",
                                      onTap: () {
                                        if (isNotEmpty(
                                            _expectedVisitorController.text)) {
                                          var data = GenerateTokenRequest(
                                              qty: _expectedVisitorController
                                                  .text,
                                              email: _emailController.text,
                                              canSendMail:
                                                  _switchValue ? "1" : "0",
                                              estateId: selectedEstateData?.id
                                                  .toString());
                                          accessTokenBloc
                                              .add(GenerateTokenEvent(data));

                                        } else {
                                          showErrorBottomSheet(context,
                                              "Please provide all entries");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                listener: (BuildContext context, AccessTokenState state) {
                  switch (state) {
                    case AccessTokenFailed():
                      showErrorBottomSheet(context, state.error);
                    case GenerateTokenSuccess():
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => TransactionSuccessPage(
                                    details: ReceiptBuilder()
                                        .accessToken(state.data.data!),
                                  )));

                    default:
                      log("state not implemented");
                  }
                },
              );
            }),
      ),
    );
  }
}
