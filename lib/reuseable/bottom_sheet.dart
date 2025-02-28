import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/bloc/payment_bloc/payment_bloc.dart';
import 'package:momas_pay/reuseable/search_bottom_sheet/payment_bottom_sheet.dart';

import '../domain/data/response/user_model.dart';
import '../utils/check_admin_charge_checker.dart';
import '../utils/colors.dart';
import '../utils/shared_pref.dart';

class MoBottomSheet {
  Future payment(BuildContext context,
      {required String amount,
      required ServiceType serviceType,
      Function(String ref)? onPayment}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<User?>(
          future: SharedPreferenceHelper.getUser(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child: SpinKitFadingCircle(
                color: MoColors.mainColor,
                size: 50.0,
              ));
            }
            if (snapshot.data?.monthlyAdminFee == false) {
              return AdminChargeUI();
            }
            return PaymentBottomSheet(
              amount: amount,
              onPayment: onPayment,
              service: serviceType,
            );
          },
        );
      },
    );
  }
}
