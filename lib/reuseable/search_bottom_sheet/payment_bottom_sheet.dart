import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momas_pay/domain/repository/payment_repository.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:momas_pay/utils/images.dart';

import '../../bloc/payment_bloc/payment_bloc.dart';
import '../../bloc/payment_bloc/payment_event.dart';
import '../../bloc/payment_bloc/payment_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentBottomSheet extends StatefulWidget {
  final String amount;
  final Function(String ref)? onPayment;

  const PaymentBottomSheet({super.key, required this.amount, this.onPayment});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late PaymentBloc paymentBloc;

  @override
  void initState() {
    super.initState();
    paymentBloc = PaymentBloc(PaymentRepository());
  }

  bool isLoading = false;

  void _onPaymentOptionTap(PaymentType type) {
    setState(() {
      isLoading = true;
    });
    paymentBloc.add(
      MakePayment(payType: type, amount: widget.amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(PaymentRepository()),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        bloc: paymentBloc,
        builder: (context, state) {
          if (state is PaymentLoading) {
            return Center(
                child: SpinKitFadingCircle(
              color: MoColors.mainColor,
              size: 40.0,
            ));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Choose preferred payment gateway',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'To pay',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Services',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NGN2,000',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Image.network(
                      'https://via.placeholder.com/50',
                      // Replace with your image URL
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPaymentOption(
                    context, 'Pay with Paystack', MoImage.payStack,
                    onTap: () =>
                        _onPaymentOptionTap(PaymentType.paystack)),
                const SizedBox(height: 10),
                _buildPaymentOption(
                    context, 'Pay with Flutterwave', MoImage.flutterWave,
                    onTap: () =>
                        _onPaymentOptionTap(PaymentType.flutterwave)),
                const SizedBox(height: 10),
                _buildPaymentOption(
                    context, 'Pay with wallet', MoImage.walletPayment,
                    additionalInfo: 'NGN ${widget.amount}.',
                    onTap: () =>
                        _onPaymentOptionTap(PaymentType.wallet)),
              ],
            ),
          );
        },
        listener: (BuildContext context, PaymentState state) {
          if (state is PaymentSuccess) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentWebView(url: state.url)),
            ).then((value) {
              if (value["status"] == "success") {
                widget.onPayment!(value["ref"]);
                Navigator.pop(context);

              }
            });
          } else if(state is  PaymentWalletSuccess){
              widget.onPayment!(state.ref);
              Navigator.pop(context);

          }

          else if (state is PaymentFailure) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            Navigator.pop(context);

          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, String iconUrl,
      {bool isSelected = false, String? additionalInfo, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Image.asset(
            iconUrl,
            width: 40,
            height: 40,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: additionalInfo != null
              ? Text(
                  additionalInfo,
                  style: const TextStyle(color: Colors.grey),
                )
              : null,
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ),
    );
  }
}

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  void initState() {
    super.initState();
    loadController();
  }

  late WebViewController controller;

  loadController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            Uri uri = Uri.parse(request.url);
            bool containsPayment = uri.toString().contains('payment');
            if (containsPayment == true) {
              String? ref = uri.queryParameters['ref'];
              String? status = uri.queryParameters['status'];
              Navigator.pop(context, {"ref": ref, "status": status});
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Payment')),
        body: WebViewWidget(controller: controller));
  }
}
