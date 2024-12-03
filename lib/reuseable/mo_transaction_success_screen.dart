import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:momas_pay/reuseable/shadow_container.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

import '../domain/data/transaction_details.dart';
import '../screens/dashboard/root_screen.dart';
import '../utils/images.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../utils/strings.dart';

class TransactionSuccessPage extends StatefulWidget {
  final List<TransactionDetail>? details;

  const TransactionSuccessPage({super.key, this.details});

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
  late ScreenshotController screenshotController;

  @override
  void initState() {
    screenshotController = ScreenshotController();
    super.initState();
  }

  Future<void> _takeScreenshot() async {
    try {
      screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((capturedImage) async {
        if (capturedImage != null) {
          final directory = await path.getApplicationDocumentsDirectory();
          final imagePath =
              await File('${directory.path}/screenshot.png').create();
          await imagePath.writeAsBytes(capturedImage);

          await Share.shareXFiles([XFile(imagePath.path)],
              text: 'Here is your receipt!');
        }
        // ShowCapturedWidget(context, capturedImage!);
      }).catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share')),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          color: MoColors.mainColor.withOpacity(0.2),
          child: Column(
            children: [
              Expanded(
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: MoColors.mainColor.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Lottie.asset(MoImage.lottieSuccess,
                                  repeat: true)),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Payment Successful',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ReceiptWidget(details: widget.details ?? []),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: MoColors.mainColor.withOpacity(0.2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const RootScreen()),
                              (route) => false),
                          child: ShadowContainer(
                              color: MoColors.mainColor,
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 15),
                                child: Icon(Icons.home_filled,
                                    color: Colors.white),
                              )),
                        ),
                        InkWell(
                          onTap: () => _takeScreenshot(),
                          child: ShadowContainer(
                              color: MoColors.mainColor,
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 15),
                                child: Icon(Icons.share, color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    //   ),
                    //   child: const Text('LEARN HOW TO ACTIVATE TOKEN'),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text("Captured widget screenshot"),
      ),
      body: Center(child: Image.memory(capturedImage)),
    ),
  );
}

class ReceiptWidget extends StatelessWidget {
  final List<TransactionDetail> details;

  const ReceiptWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: MoColors.mainColor.withOpacity(0.01),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipPath(
          clipper: ReceiptClipper(),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Purchase Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ...details.where((detail) => isNotEmpty(detail.value)).map(
                    (detail) =>
                        buildDetailRow(detail.label ?? "", detail.value ?? "")),
                const SizedBox(height: 16.0),
                const Center(
                  child: Text(
                    'Thank you for choosing momas pay',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cutSize = 8.0;

    path.moveTo(0, cutSize);
    for (double i = cutSize; i < size.width; i += 2 * cutSize) {
      path.lineTo(i, 0);
      path.lineTo(i + cutSize, cutSize);
    }
    path.lineTo(size.width, cutSize);
    path.lineTo(size.width, size.height - cutSize);
    for (double i = size.width - cutSize; i > 0; i -= 2 * cutSize) {
      path.lineTo(i, size.height);
      path.lineTo(i - cutSize, size.height - cutSize);
    }
    path.lineTo(0, size.height - cutSize);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
