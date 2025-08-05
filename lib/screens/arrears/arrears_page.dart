import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/arrears_bloc/arrears_bloc.dart';
import '../../bloc/payment_bloc/payment_bloc.dart';
import '../../domain/data/response/arrears_items.dart';
import '../../domain/repository/bill_repository.dart';
import '../../reuseable/bottom_sheet.dart';
import '../../reuseable/error_modal.dart';
import '../../utils/amount_formatter.dart';
import '../../utils/colors.dart';

class CustomerArrearsPage extends StatefulWidget {
  const CustomerArrearsPage({super.key});

  @override
  State<CustomerArrearsPage> createState() => _CustomerArrearsPageState();
}

class _CustomerArrearsPageState extends State<CustomerArrearsPage> {
  late CustomerArrearsBloc bloc;
  @override
  void initState() {
    bloc = CustomerArrearsBloc(repository: BillRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerArrearsBloc(repository: BillRepository())..add(GetArrears()),
      child: BlocListener<CustomerArrearsBloc, CustomerArrearsState>(
        listener: (context, state) {
          if (state is ArrearPaymentSuccess) {
            showSuccessBottomSheet(context, "Payment of arrears is successful");
            //reload the screen again
            context.read<CustomerArrearsBloc>().add(GetArrears());
          } else if (state is ArrearPaymentFailure) {
            showErrorBottomSheet(context, "Payment failed");
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            title: const Text('Customer Arrears Summary'),
            centerTitle: true,
            backgroundColor: MoColors.mainColor,
            foregroundColor: Colors.white,
          ),
          body: BlocBuilder<CustomerArrearsBloc, CustomerArrearsState>(
            builder: (context, state) {
              if (state is ArrearsLoading || state is ArrearPaymentLoading) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: MoColors.mainColor,
                    size: 50.0,
                  ),
                );
              } else if (state is ArrearsFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is ArrearsSuccess) {
                final items = state.arrears;
                final unpaidItems = items
                    .where((item) => item.status == 0)
                    .toList(); // unpaid only
                final total = unpaidItems.fold(
                    0.0, (sum, item) => sum + item.amount); // unpaid total only

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isPaid = item.status == 1;

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? const Color(0xFFE7F9EF)
                                  : Colors.white, // light green for paid
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.type
                                          .replaceAll("_", " ")
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isPaid
                                            ? Colors.green
                                            : const Color(0xFF0A4DA2),
                                      ),
                                    ),
                                    Text(
                                      AmountFormatter.formatNaira(item.amount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "Start: ${item.createdAt.toLocal().toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Due: ${item.nextDueDate.toLocal().toString().split(' ')[0]}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (!isPaid)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        payment(context, item.amount.toString(),
                                            item.id, true);
                                      },
                                      icon: const Icon(Icons.payment, size: 18),
                                      label: const Text("Pay Now"),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        backgroundColor:
                                            const Color(0xFF1BA94C),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle,
                                            size: 18, color: Colors.green),
                                        SizedBox(width: 6),
                                        Text("Paid",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (unpaidItems.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount Due:",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  AmountFormatter.formatNaira(total),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                payment(context, total.toString(), 0, false);
                              },
                              icon: const Icon(Icons.credit_card),
                              label: const Text("Pay All"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MoColors.mainColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void payment(
      BuildContext context, String amount, int arrearsId, bool single) {
    MoBottomSheet().payment(context,
        amount: amount,
        showMonthlyFee: false,
        serviceType: ServiceType.arrears, onPayment: (String ref) {
      if (single) {
        context
            .read<CustomerArrearsBloc>()
            .add(PaySingleArrear(id: arrearsId, paymentRef: ref));
      } else {
        context.read<CustomerArrearsBloc>().add(PayAllArrears(ref));
      }
    });
  }

  Map<String, List<ArrearItem>> groupArrearsByCycle(List<ArrearItem> items) {
    final Map<String, List<ArrearItem>> grouped = {};

    for (final item in items) {
      final dueDate = item.nextDueDate;
      final key = "${_monthName(dueDate.month)} ${dueDate.year}";
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
