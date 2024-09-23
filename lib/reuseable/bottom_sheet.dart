import 'package:flutter/material.dart';
import 'package:momas_pay/reuseable/search_bottom_sheet/payment_bottom_sheet.dart';

class MoBottomSheet {
  Future payment(BuildContext context, { required String amount, Function(String ref)? onPayment, String? service}) {
   return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return  PaymentBottomSheet(amount: amount, onPayment: onPayment, service: service,);
      },
    );
  }
}
