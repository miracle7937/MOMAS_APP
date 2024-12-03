import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/screens/profile/request_meter_screen.dart';
import 'package:momas_pay/screens/profile/support/support_screen.dart';
import 'package:momas_pay/utils/images.dart';

import '../../bloc/setting_bloc/setting_bloc.dart';
import '../../bloc/setting_bloc/setting_state.dart';
import '../../domain/data/response/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/setting_repository.dart';
import '../../domain/service/auth_service.dart';
import '../../reuseable/error_modal.dart';
import '../../utils/alert_dialog-view.dart';
import '../../utils/shared_pref.dart';
import '../../utils/strings.dart';
import '../auth/email_code_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  late SettingsBloc settingsBloc;
  bool isDeleteAccount = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    settingsBloc = SettingsBloc(SettingRepository());
    user = await SharedPreferenceHelper.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(MoImage
                            .profilePic), // Replace with your image asset
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.firstName ?? "${user?.lastName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user?.meterNo ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Options
                OptionTile(
                  icon: Icons.lock,
                  title: 'Reset Password',
                  onTap: () {
                    if (isNotEmpty(user?.email)) {
                      AuthService(AuthRepository())
                          .checkEmail(user!.email!, "reset")
                          .then((value) {
                        if (value.status == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EmailCodeScreen(
                                        email: user?.email ?? "",
                                        passCode: PassCode.resetPassword,
                                      )));
                        } else {
                          showErrorBottomSheet(
                              context, value.message ?? "Error occurred!");
                        }
                      });
                    }
                  },
                ),
                OptionTile(
                  icon: Icons.electric_meter,
                  title: 'Request for a meter',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RequestMeterScreen())),
                ),
                OptionTile(
                    icon: Icons.support_agent,
                    title: 'Support',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SupportScreen()))),
                OptionTile(
                    icon: Icons.delete,
                    title: 'Delete account',
                    onTap: () {
                      showAlertDialog(
                        context,
                        message:
                            "Are you sure you want to delete your account?",
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => isDeleteAccount = true);

                          SettingRepository()
                              .deleteAccount(user!.email!)
                              .then((value) {
                            if (value.status == true) {
                              SharedPreferenceHelper.clearUser();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/", (route) => false);
                            }
                            setState(() => isDeleteAccount = false);
                          }).catchError((error) {
                            setState(() => isDeleteAccount = false);
                            SharedPreferenceHelper.clearUser();
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (route) => false);
                          });
                        },
                      );
                    }),
                OptionTile(
                  icon: Icons.logout,
                  title: 'Log out',
                  onTap: () {
                    SharedPreferenceHelper.clearUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (route) => false);
                  },
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, SettingsState state) {
          switch (state) {
            case SettingsStateFailed():
              showErrorBottomSheet(context, state.error);
            case SettingsSupportStateSuccess():
              showSuccessBottomSheet(context, state.message);
            default:
              log("state not implemented");
          }
        },
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const OptionTile({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(icon, color: Colors.green),
              ),
              title: Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
              onTap: onTap),
        ),
        const Divider(
          thickness: 0.2,
          color: Colors.grey,
        )
      ],
    );
  }
}
