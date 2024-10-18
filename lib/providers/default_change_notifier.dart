import 'package:flutter/material.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool _loading = false;

  set loading(bool value) {
    _loading = value;
    notify();
  }

  void notify() {
    try {
      if (ChangeNotifier.debugAssertNotDisposed(this)) notifyListeners();
    } catch (e) {
      debugPrint('DefaultChangeNotifier is disposed');
    }
  }

  bool get loading => _loading;
}
