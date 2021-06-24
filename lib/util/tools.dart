import 'package:intl/intl.dart';

class Tools {
  static String currency (int amount) {
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }
}