import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:momas_pay/reuseable/mo_button.dart';

import '../utils/images.dart';

void showErrorBottomSheet(BuildContext context, String errorMessage) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: 100,
                child: Lottie.asset(MoImage.error,
                    repeat: false, fit: BoxFit.fill)),
            const SizedBox(height: 16),
            const Text(
              'An Error Occurred!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            MoButton(
              onTap: () {
                Navigator.of(ctx).pop();
              },
              title: 'Dismiss',
            ),
          ],
        ),
      ),
    ),
  );
}

Future showSuccessBottomSheet(BuildContext context, String successMessage,
    {VoidCallback? onTap}) {
  return showModalBottomSheet(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Lottie.asset(MoImage.lottieSuccess,
                    repeat: false, fit: BoxFit.fill)),
            const SizedBox(height: 16),
            const Text(
              'Success!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              successMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            MoButton(
              onTap: onTap ??
                  () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
              title: 'Dismiss',
            ),
          ],
        ),
      ),
    ),
  );
}
