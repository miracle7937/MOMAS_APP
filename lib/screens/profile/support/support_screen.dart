import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../bloc/setting_bloc/setting_bloc.dart';
import '../../../bloc/setting_bloc/setting_event.dart';
import '../../../bloc/setting_bloc/setting_state.dart';
import '../../../domain/data/response/setting_response.dart';
import '../../../domain/repository/setting_repository.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/pop_button.dart';
import '../../../reuseable/shadow_container.dart';
import '../../../utils/colors.dart';
import '../../../utils/launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  late SettingsBloc settingsBloc;
  SupportData? supportData;


  @override
  void initState() {
    super.initState();
    settingsBloc = SettingsBloc(SettingRepository())..add(SupportSettingEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SettingsBloc, SettingsState>(
            bloc: settingsBloc,
            builder: (context, state) {


              if (state is SettingsStateLoading) {
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


            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 13,),
                Center(
                  child: ShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width -15,
                        child: Row(
                          children: [
                            PopButton().pop(context),
                            const SizedBox(width: 20,),
                            const Text("Support")
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                const Text(
                  'Reach out to us for any issues, we are always here to support you',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.payment,
                  title: 'Payment Issues',
                  subtitle: 'Connect to us on all payment issues',
                  onTap: () {
                    Launcher()
                        .launchInBrowser(
                        Uri.parse(
                            supportData?.paymentSupport ?? ""));
                  },
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.electric_meter,
                  title: 'Meter Issues',
                  subtitle: 'Connect to us on all meter issues',
                  onTap: () {
                    Launcher()
                        .launchInBrowser(
                        Uri.parse(
                            supportData?.meterSupport ?? ""));
                  },
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.help_outline,
                  title: 'Other Issues',
                  subtitle: 'Connect to us on all other issues',
                  onTap: () {
                    Launcher()
                        .launchInBrowser(
                        Uri.parse(
                            supportData?.generalSupport ?? ""));
                  },
                ),
              ],
            );
          }, listener: (BuildContext context, SettingsState state) {
          switch (state) {
            case SettingsStateFailed():
              showErrorBottomSheet(context, state.error);
            case SettingsSupportStateLoading():
              supportData = state.response.data;
            default:
              log("state not implemented");
          }
        },
        ),
      ),
    );
  }
}

class SupportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  SupportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Icon(icon, color: Colors.green),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}