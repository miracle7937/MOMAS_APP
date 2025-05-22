import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  static void hideKeyboardIfVisible(BuildContext context) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }
}
