import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';

import '../utils/network_enum.dart';

class NetworkSelector extends StatelessWidget {
  final Network? selectedNetwork;
  final Function(Network) onSelectNetwork;



  final Map<Network, String> networkImages = {
    Network.mtn: MoImage.mtn,
    Network.n9Mobile: MoImage.n9mobile,
    Network.airtel: MoImage.airtel,
    Network.glo: MoImage.glo,
  };

  NetworkSelector({
     this.selectedNetwork,
    required this.onSelectNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: Network.values.map((network) {
        return GestureDetector(
          onTap: () => onSelectNetwork(network),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selectedNetwork == network
                  ? MoColors.mainColor
                  : Colors.grey,
              width:   selectedNetwork == network
                  ? 4: 2,
              
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                networkImages[network]!,
                width: 40,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}


class CableTvSelector extends StatelessWidget {
  final CableEnum? selectedNetwork;
  final Function(CableEnum) onSelectNetwork;

  final Map<CableEnum, String> networkImages = {
    CableEnum.dstv: MoImage.dstv,
    CableEnum.gotv: MoImage.gotv,
    CableEnum.showmax: MoImage.showMax,
    CableEnum.startimes: MoImage.startimes,
  };

  CableTvSelector({super.key,
    this.selectedNetwork,
    required this.onSelectNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: CableEnum.values.map((network) {
        return GestureDetector(
          onTap: () => onSelectNetwork(network),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selectedNetwork == network
                    ? MoColors.mainColor
                    : Colors.grey,
                  width:   selectedNetwork == network
                      ? 4: 2,

                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                networkImages[network]!,
                width: 40,
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}