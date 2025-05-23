import 'package:flutter/cupertino.dart';

extension DeviceTypeExtension on BuildContext {
  bool get isTablet {
    final double shortestSide = MediaQuery.of(this).size.shortestSide;
    return shortestSide >= 600;
  }

  bool get isMobile {
    return !isTablet;
  }
}
