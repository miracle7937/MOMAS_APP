import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/service_bloc/service_state.dart';
import 'package:momaspayplus/domain/repository/service_repository.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/screens/service/service_preview.dart';

import '../../bloc/service_bloc/service_bloc.dart';
import '../../bloc/service_bloc/service_event.dart';
import '../../domain/data/response/service_data_response.dart';
import '../../domain/data/response/service_response.dart';
import '../../domain/data/response/user_model.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/pop_button.dart';
import '../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../reuseable/shadow_container.dart';
import '../../utils/service_launcher.dart';
import '../../utils/shared_pref.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ServiceBloc serviceBloc;
  Estate? selectedEstate;
  Service? selectedService;
  ServiceDataResponse? serviceDataResponse;
  ServiceSearchResponse? serviceSearchResponse;
  String? estateId;

  @override
  void initState() {
    super.initState();
    serviceBloc = ServiceBloc(ServiceRepository())
      ..add(const ServicePropertiesEvent());
    getUserEstate();
  }

  getUserEstate() async {
    User? user = await SharedPreferenceHelper.getUser();
    estateId = user?.estateId;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: BlocConsumer<ServiceBloc, ServiceState>(
            bloc: serviceBloc,
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: ShadowContainer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width - 15,
                                child: Row(
                                  children: [
                                    PopButton().pop(context),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text("Service")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // EPDropdownButton<Estate>(
                        //   itemsListTitle: "Choose Estate",
                        //   iconSize: 22,
                        //   value: selectedEstate,
                        //   hint: const Text(""),
                        //   isExpanded: true,
                        //   underline: const Divider(),
                        //   searchMatcher: (item, text) {
                        //     return item.title!
                        //         .toLowerCase()
                        //         .contains(text.toLowerCase());
                        //   },
                        //   onChanged: (v) {
                        //     setState(() {
                        //       selectedEstate = v;
                        //     });
                        //   },
                        //   items: (serviceDataResponse?.data?.estate ?? [])
                        //       .map(
                        //         (e) => DropdownMenuItem(
                        //           value: e,
                        //           child: Row(
                        //             children: [
                        //               Text(e.title.toString(),
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .labelMedium!
                        //                       .copyWith(
                        //                           fontWeight: FontWeight.w400,
                        //                           color: Colors.black)),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //       .toList(),
                        // ),
                        EPDropdownButton<Service>(
                          itemsListTitle: "Choose Services",
                          iconSize: 22,
                          value: selectedService,
                          hint: const Text(""),
                          isExpanded: true,
                          underline: const Divider(),
                          searchMatcher: (item, text) {
                            return item.serviceTitle!
                                .toLowerCase()
                                .contains(text.toLowerCase());
                          },
                          onChanged: (v) {
                            setState(() {
                              selectedService = v;
                            });
                          },
                          items: (serviceDataResponse?.data?.service ?? [])
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Text(e.serviceTitle.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: MoButton(
                            isLoading: state is ServiceStateLoading,
                            title: "Search",
                            onTap: () {
                              serviceBloc.add(ServiceSearchEvent(
                                  estateId.toString(),
                                  selectedService!.id.toString()));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  serviceSearchResponse?.data?.isNotEmpty == true
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (serviceSearchResponse?.data?.isNotEmpty ==
                                  true) {
                                var searchData =
                                    serviceSearchResponse!.data![index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ServicePreviewScreen(
                                                  data: searchData,
                                                  estate:
                                                      selectedEstate?.title ??
                                                          "",
                                                )));
                                  },
                                  child: CustomListItem(
                                    name: searchData.professionalName ?? "",
                                    profession: searchData.serviceTitle ?? "",
                                    rating: int.parse(searchData.rating ?? "0"),
                                    phoneNumber:
                                        searchData.professionalPhone ?? "",
                                  ),
                                );
                              }
                              return const EmptyList();
                            },
                            childCount:
                                serviceSearchResponse?.data?.length ?? 0,
                          ),
                        )
                      : const SliverToBoxAdapter(child: EmptyList()),
                ],
              );
            },
            listener: (BuildContext context, ServiceState state) {
              switch (state) {
                case ServiceSearchStateSuccess():
                  serviceSearchResponse = state.dataResponse;
                case ServiceStateFailed():
                  showErrorBottomSheet(context, state.error);
                case ServiceStateSuccess():
                  serviceDataResponse = state.dataResponse;

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

class CustomListItem extends StatelessWidget {
  final String name;
  final String profession;
  final String phoneNumber;
  final int rating;

  const CustomListItem({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.work, color: Colors.green),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: List.generate(
                        rating,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  profession,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          InkWell(
              onTap: () => ServiceLauncher.makePhoneCall(phoneNumber),
              child: const Icon(Icons.phone, color: Colors.green)),
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_sharp,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 5),
            Text(
              'No professional available',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
