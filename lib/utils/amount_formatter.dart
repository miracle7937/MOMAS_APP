import 'package:intl/intl.dart';

class AmountFormatter {
  static String format(double amount, {String locale = 'en_NG'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: '');
    return formatter.format(amount);
  }

  static String formatNaira(double amount, {String locale = 'en_NG'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: 'NGN');
    return formatter.format(amount);
  }
}
