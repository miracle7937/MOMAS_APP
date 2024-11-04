import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/screens/generate_token/widget/token_tile_view.dart';

import '../../bloc/access_token_bloc/access_token_bloc.dart';
import '../../bloc/access_token_bloc/access_token_event.dart';
import '../../bloc/access_token_bloc/access_token_state.dart';
import '../../domain/data/response/access_token_list_data.dart';
import '../../domain/repository/access_token_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_button.dart';
import '../../reuseable/mo_form.dart';
import '../../utils/colors.dart';

class AccessTokenVerification extends StatefulWidget {
  const AccessTokenVerification({super.key});

  @override
  State<AccessTokenVerification> createState() =>
      _AccessTokenVerificationState();
}

class _AccessTokenVerificationState extends State<AccessTokenVerification> {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late AccessTokenBloc accessTokenBloc;
  List<TokenBody> tokenList = [];
  List<TokenBody> filteredTokenList = [];

  @override
  void initState() {
    accessTokenBloc = AccessTokenBloc(repository: AccessTokenRepository());
    accessTokenBloc.add(const GetEstateTokenList());
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    tokenController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredTokenList = tokenList
          .where((token) => token.token
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _refreshTokenList() async {
    accessTokenBloc.add(const GetEstateTokenList());
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
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  prefixIcon: const Icon(
                    Icons.token,
                    color: Colors.grey,
                  ),
                  title: "Search tokens..",
                ),
                const SizedBox(height: 10),
                state is AccessTokenLoading
                    ? Center(
                        child: SpinKitFadingCircle(
                        color: MoColors.mainColor,
                        size: 40.0,
                      ))
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshTokenList,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredTokenList.length,
                            itemBuilder: (context, index) {
                              final tokenBody = filteredTokenList[index];
                              return Dismissible(
                                key: Key(tokenBody.token),
                                background: Container(
                                  color: Colors.green,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.approval,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    accessTokenBloc.add(VerifyAccessToken(
                                        tokenBody.id.toString()));
                                    return true;
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    accessTokenBloc.add(DisApproveToken(
                                        tokenBody.id.toString()));

                                    return false;
                                  }
                                  return false;
                                },
                                child: TokenTileView(tokenBody: tokenBody),
                              );
                            },
                          ),
                        ),
                      )
              ],
            ),
          );
        },
        listener: (BuildContext context, AccessTokenState state) {
          switch (state) {
            case AccessTokenFailed():
              showErrorBottomSheet(context, state.error);
            case GetTokenListSuccess():
              setState(() {
                tokenList = state.data;
                filteredTokenList = tokenList;
              });
              break;
            case VerifyTokenSuccess():
              showSuccessBottomSheet(context, state.message);
              break;
            default:
              log("state not implemented");
          }
        },
      ),
    );
  }
}
