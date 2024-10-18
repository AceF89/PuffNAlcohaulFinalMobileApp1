import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  void showSuccessSnackBar(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void showFailureSnackBar(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

extension ShimmerExtensions on Widget {
  Widget toShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.18),
      child: this,
    );
  }
}

extension MapWithIndex<T> on List<T> {
  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    List<R> result = [];

    for (int i = 0; i < length; i++) {
      R item = callback(this[i], i);
      result.add(item);
    }
    return result;
  }

  Iterable<R> mapWithIndexIterable<R>(R Function(T, int i) callback) {
    return asMap().keys.toList().map((index) => callback(this[index], index));
  }
}

extension StringFormat on String {
  String get currency {
    final indianRupeesFormat = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 2,
      symbol: '₹ ',
    );
    return indianRupeesFormat.format(double.parse(this));
  }
}

extension DateExtension on DateTime {
  String get toSimple {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

extension IterablesExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test,
      {required Null Function() orElse}) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension MapExtensions on Map<String, dynamic> {
  Map<String, dynamic> removeNull() {
    removeWhere((_, value) => value == null);
    return this;
  }
}
