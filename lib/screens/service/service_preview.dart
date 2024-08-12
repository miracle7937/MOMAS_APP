import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/domain/data/response/service_response.dart';
import 'package:momas_pay/screens/service/rating_widget.dart';
import 'package:momas_pay/utils/colors.dart';

import '../../bloc/service_bloc/service_bloc.dart';
import '../../bloc/service_bloc/service_event.dart';
import '../../bloc/service_bloc/service_state.dart';
import '../../domain/data/response/comment_response.dart';
import '../../domain/repository/service_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/pop_button.dart';
import '../../reuseable/shadow_container.dart';
import '../../utils/service_launcher.dart';
import '../../utils/time_util.dart';

class ServicePreviewScreen extends StatefulWidget {
  final SearchData data;
  final String estate;

  const ServicePreviewScreen(
      {super.key, required this.data, required this.estate});

  @override
  State<ServicePreviewScreen> createState() => _ServicePreviewScreenState();
}

class _ServicePreviewScreenState extends State<ServicePreviewScreen> {
  late ServiceBloc serviceBloc;
  CommentResponse? response;

  @override
  void initState() {
    super.initState();
    serviceBloc = ServiceBloc(ServiceRepository())
      ..add(GetCommentEvent(widget.data.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<ServiceBloc, ServiceState>(
            bloc: serviceBloc,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 15),
                  _buildContactCard(widget.data),
                  const SizedBox(height: 16),
                  const Text('Comments',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  state is ServiceStateLoading
                      ? Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(
                              color: MoColors.mainColor,
                              size: 50.0,
                            )
                          ],
                        ))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: response?.comment?.length ?? 0,
                              itemBuilder: (_, index) {
                                var comment = response!.comment![index];
                                return _buildCommentCard(
                                    comment.userName ?? "",
                                    comment.comment ?? "",
                                    TimeUtil().ago(
                                      comment.createdAt ?? "",
                                    ),
                                    comment.count ?? 0);
                              })),
                ],
              );
            },
            listener: (BuildContext context, ServiceState state) {
              switch (state) {
                case ServiceGetChatStateSuccess():
                  response = state.response;
                case ServiceStateFailed():
                  showErrorBottomSheet(context, state.error);
                case ServiceSaveChatStateSuccess():
                  showSuccessBottomSheet(context, state.message);
                default:
                  log("state not implemented");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(SearchData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: MoColors.mainColor.withOpacity(0.2),
              radius: 25,
              child: const Icon(Icons.work, size: 25),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(data.professionalName ?? "",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: List.generate(
                        int.parse(data.rating ?? '0'),
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 13,
                        ),
                      ),
                    )
                  ],
                ),
                Text(data.serviceTitle ?? ""),
                Text(widget.estate),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => RatingModal(
                          onSubmit: (rating, comment) {
                            serviceBloc.add(ServicePostCommentEvent(
                              comment,
                              rating.toString(),
                              data.id.toString()

                            ));
                            log('Rating: $rating');
                            log('Comment: $comment');
                          },
                        ),
                      );
                    },
                    child: const Icon(Icons.chat, color: Colors.green)),
                const SizedBox(height: 8),
                InkWell(
                    onTap: () => ServiceLauncher.makePhoneCall(
                        data.professionalPhone ?? ""),
                    child: const Icon(Icons.phone, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(
      String name, String comment, String minutesAgo, int rating) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: MoColors.mainColor.withOpacity(0.2),
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 8),
                  Text(comment),
                  const SizedBox(height: 8),
                  Text('$minutesAgo',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
