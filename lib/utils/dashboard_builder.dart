import 'package:flutter/material.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/service/service_screen.dart';

import '../domain/data/response/feature.dart';
import '../domain/data/response/user_model.dart';
import '../screens/arrears/arrears_page.dart';
import '../screens/bills_payment/bill_selected_screen.dart';
import '../screens/generate_token/access_token_screen.dart';
import '../screens/generate_token/access_token_verification.dart';
import '../screens/metrics/metrics_screen.dart';
import '../screens/momos_payment/momas_payment_screen.dart';
import '../screens/reprint_token/reprint_token_screen.dart';
import '../screens/profile/support/support_screen.dart';
import 'images.dart';

class DashboardBuilder {
  static List<GridItemModel> builder(
      Feature future, BuildContext context, User user) {
    List<GridItemModel> value = [];
    if (future.momasMeter == 1) {
      value.add(
        GridItemModel(
            image: MoImage.momasPayment,
            title: "Make Payment",
            subtitle: "Buy more unit for your momas meter",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MomasPaymentScreen(
                            momasPaymentType: MomasPaymentType.self,
                          )));
            }),
      );
    }
    if (future.otherMeter == 1) {
      value.add(
        GridItemModel(
            image: MoImage.meterPayment,
            title: "Pay Other Meter",
            subtitle: "Buy  unit for other meters",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MomasPaymentScreen(
                            momasPaymentType: MomasPaymentType.others,
                          )));
            }),
      );
    }
    if (future.printToken == 1) {
      value.add(
        GridItemModel(
            image: MoImage.reprintToken,
            title: "Reprint Token",
            subtitle: "Reprint your purchased token",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ReprintTokenScreen()));
            }),
      );
    }
    if (future.accessToken == 1) {
      value.add(
        GridItemModel(
            image: MoImage.accessToken,
            title: "Access Token",
            subtitle: user.userRole == UserRole.estateStaff
                ? "Verify estate token"
                : "Generate and manage security token",
            onTap: () {
              print(user.userRole);
              if ((user.userRole == UserRole.estateStaff)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AccessTokenVerification()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AccessTokenScreen()));
              }
            }),
      );
    }
    if (future.services == 1) {
      value.add(
        GridItemModel(
            image: MoImage.services,
            title: "Services",
            subtitle: "Request for any services in your estate",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const ServiceScreen()));
            }),
      );
    }
    if (future.billPayment == 1) {
      value.add(
        GridItemModel(
            image: MoImage.billPayment,
            title: "Bill Payment",
            subtitle: "Manage and add beneficiary to your account",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const BillPaymentOptionsScreen()));
            }),
      );
    }
    if (future.support == 1) {
      value.add(
        GridItemModel(
            image: MoImage.support,
            title: "Support",
            subtitle: "Contact our 24/7 support",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const SupportScreen()));
            }),
      );
    }
    // if (future.topUp == 1) {
    //   value.add(
    //     GridItemModel(
    //         image: MoImage.topUpWallet,
    //         title: "Top up wallet",
    //         subtitle: "Fund your wallet easily",
    //         onTap: null),
    //   );
    // }
    if (future.analysis == 1) {
      value.add(
        GridItemModel(
            image: MoImage.analytics,
            title: "Analytics",
            subtitle: "Buy Airtime and Data for all Network",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MetricsScreen()));
            }),
      );
    }

    value.add(
      GridItemModel(
          image: MoImage.analytics,
          title: "Arrears",
          subtitle: "Buy for unpaid utilities",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => CustomerArrearsPage()));
          }),
    );
    return value;
  }
}

class GridItemModel {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  GridItemModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
