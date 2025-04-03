import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/screens/dashboard/search_screen/search_screen.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:momas_pay/utils/images.dart';

import '../../domain/data/response/user_model.dart';
import '../../utils/shared_pref.dart';
import '../generate_token/access_token_verification.dart';
import '../profile/profile_screen.dart';
import 'main_dashboard/main_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildTabViews() {
    return [
      const MainScreen(),
      const SearchScreen(),
      const ProfileScreen(),
    ];
  }

  Row _rowBuildTap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCustomTab(0, MoImage.home),
        _buildCustomTab(1, MoImage.history),
        _buildCustomTab(2, MoImage.settingsIcon),
      ],
    );
  }

  List<Widget> _estateStaffTabView() {
    return [
      const AccessTokenVerification(),
      const ProfileScreen(),
    ];
  }

  Row _rowEstateStaff() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCustomTab(0, MoImage.home),
        _buildCustomTab(1, MoImage.settingsIcon),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<User?>(
          future: SharedPreferenceHelper.getUser(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 30.0,
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                    child: (snapshot.data?.userRole == UserRole.estateStaff)
                        ? _estateStaffTabView()[_selectedIndex]
                        : _buildTabViews()[_selectedIndex]),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: (snapshot.data?.userRole == UserRole.estateStaff)
                        ? _rowEstateStaff()
                        : _rowBuildTap()),
              ],
            );
          }),
    );
  }

  Widget _buildCustomTab(int index, String image) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                image,
                fit: BoxFit.fill,
                color: isSelected ? MoColors.mainColor : null,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: isSelected ? MoColors.mainColor : Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          ),
          Platform.isIOS == true
              ? const SizedBox(
                  height: 20,
                )
              : Container()
        ],
      ),
    );
  }
}
