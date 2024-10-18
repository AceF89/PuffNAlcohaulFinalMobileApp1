import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';

const double _kPadding = 20.0;

const double _kBorderRadius = 10.0;

const double _kLoaderSize = 45.0;

class Loader {
  Loader._();

  static Widget circularProgressIndicator({double size = _kLoaderSize, double strokeWidth = 4.0}) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }

  static void show(BuildContext context, {String? message}) {
    Navigator.push(context, _LoaderDialog(message));
  }

  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

class _LoaderDialog extends PopupRoute {
  final String? message;

  _LoaderDialog(this.message);

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.1);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => 'Loader Dialog';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget child = const SizedBox.shrink();

    if (message != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _loader(),
          const SizedBox(height: _kPadding),
          Text(message ?? ''),
        ],
      );
    } else {
      child = _loader();
    }

    return PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: barrierColor,
            ),
            Container(
              padding: const EdgeInsets.all(_kPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_kBorderRadius),
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loader() {
    return SizedBox(
      height: _kLoaderSize,
      width: _kLoaderSize,
      child: CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
