import 'package:intl/intl.dart';

class NumberUtils {
  NumberUtils._();

  static final NumberFormat _numberFormat = NumberFormat('#,##,###');

  static String compact(dynamic number) {
    return NumberFormat.compact().format(number);
  }

  static String format(dynamic number, {String? currency}) {
    var formatted = _numberFormat.format(number);
    if (currency != null) {
      return '$currency$formatted';
    }
    return formatted;
  }
}
