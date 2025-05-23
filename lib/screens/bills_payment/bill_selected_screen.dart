import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../reuseable/pop_button.dart';
import '../../reuseable/shadow_container.dart';
import 'airtime_screen.dart';
import 'cable_tv_screen.dart';
import 'data_screen.dart';

class BillPaymentOptionsScreen extends StatelessWidget {
  const BillPaymentOptionsScreen({super.key});

  void _onCardTap(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title selected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ShadowContainer(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 15,
                      child: Row(
                        children: [
                          PopButton().pop(context),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("Bills Payment")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: context.isTablet
                    ? EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15)
                    : const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    const Text(
                      'Reach out to us for any issues, we are always here to support you',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildPaymentOptionCard(context, 'Airtime',
                        'Buy airtime for all Networks', Icons.phone_android,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const AirtimeScreen()))),
                    const SizedBox(height: 10),
                    _buildPaymentOptionCard(context, 'Data Bundle',
                        'Buy data for all Networks', Icons.data_usage,
                        isSelected: false,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const DataScreen()))),
                    const SizedBox(height: 10),
                    _buildPaymentOptionCard(context, 'Cable',
                        'Subscribe for  your cable', Icons.tv_outlined,
                        isSelected: false,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const CableTvScreen()))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard(
      BuildContext context, String title, String description, IconData icon,
      {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
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
          leading: CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Icon(icon, color: Colors.green),
          ),
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(description,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12)),
        ),
      ),
    );
  }
}
