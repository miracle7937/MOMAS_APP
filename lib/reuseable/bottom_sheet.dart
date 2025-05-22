import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';
import 'package:momaspayplus/reuseable/search_bottom_sheet/payment_bottom_sheet.dart';

import '../domain/data/response/is_admin_fees_paid.dart';
import '../domain/data/response/user_model.dart';
import '../domain/repository/payment_repository.dart';
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
        return FutureBuilder<IsAdminPaidModel?>(
          future: PaymentRepository().checkAminFeeIsPayed(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child: SpinKitFadingCircle(
                color: MoColors.mainColor,
                size: 50.0,
              ));
            }

            if (snapshot.data?.status == false) {
              return const Center(
                  child: Icon(
                Icons.error,
                color: Colors.black,
              ));
            }
            //when it is false it means you haven't pay  -->(0)
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
