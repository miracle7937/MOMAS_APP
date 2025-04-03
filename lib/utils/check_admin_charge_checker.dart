import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_event.dart';
import 'package:momaspayplus/utils/colors.dart';
import '../bloc/payment_bloc/payment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/payment_bloc/payment_state.dart';
import '../domain/data/response/bank_details.dart';
import '../domain/repository/payment_repository.dart';

class AdminChargeUI extends StatefulWidget {
  @override
  _AdminChargeUIState createState() => _AdminChargeUIState();
}

class _AdminChargeUIState extends State<AdminChargeUI> {
  late PaymentBloc paymentBloc;

  @override
  void initState() {
    super.initState();
    paymentBloc = PaymentBloc(PaymentRepository())..add(GenerateAccount());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(PaymentRepository()),
      child: BlocBuilder<PaymentBloc, PaymentState>(
        bloc: paymentBloc,
        builder: (context, state) {
          return Dialog(
            backgroundColor: MoColors.mainColorII.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildPaymentReminder(), // Added reminder
                  const SizedBox(height: 16),
                  if (state is PaymentLoading) _buildLoadingIndicator(),
                  if (state is PaymentFailure) _buildErrorText(state.error),
                  if (state is MomasGenerateBank)
                    _buildAccountDetails(state.bankDetail),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.redAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Monthly Admin Fee (Compulsory)',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPaymentReminder() {
    return const Text(
      'You haven’t paid for this month. Please make your payment to continue using our services.',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.redAccent,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SpinKitFadingCircle(
        color: MoColors.mainColor,
        size: 50.0,
      ),
    );
  }

  Widget _buildErrorText(String error) {
    return Center(
      child: Text(
        'Error loading account details: $error',
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAccountDetails(BankDetail accountDetails) {
    return Column(
      children: [
        _infoTile('Bank Name', accountDetails.bank ?? ""),
        _copyableTile('Account Number', accountDetails.accountNo ?? ""),
        _infoTile('Amount', "NGN${accountDetails.amount}"),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.white,
          ),
          label: const Text(
            "Done",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: MoColors.mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value,
              style: TextStyle(
                  color: MoColors.mainColorII, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _copyableTile(String label, String value) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$label copied!')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(value,
                    style: TextStyle(
                        color: MoColors.mainColorII,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 6),
                Icon(
                  Icons.copy,
                  size: 18,
                  color: MoColors.mainColorII,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
