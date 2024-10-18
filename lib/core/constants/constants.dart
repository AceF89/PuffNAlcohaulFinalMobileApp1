import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/helpers/preferences.dart';
import 'package:uuid/uuid.dart';

const String kAppName = 'Puff N AlcoHaul';

final Preferences preferences = Preferences.instance;

final randomId = const Uuid().v4;

const int kMaximumFileSize = 5;

GlobalKey<NavigatorState> kNavigatorKey = GlobalKey<NavigatorState>();

const String kNoInternet = 'No Internet Connection. Please check your Mobile data or Wifi.';

const String kDownloadPath = '/storage/emulated/0/Download';

String kNoImage =
    'https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?s=612x612&w=0&k=20&c=PM_optEhHBTZkuJQLlCjLz-v3zzxp-1mpNQZsdjrbns=';

class EnvValues {
  EnvValues._();

  static const String gMapKey = 'AIzaSyBIOX3kKyGqxsUldDWQQzRWROiel5RAuG4';
  static const String rcSocketUrl = 'wss://alcohol-chat.npit.pro/websocket';
  static const String oneSignalKey = '0786cb33-a26b-47e4-b6ea-aca66e3006c6';
}

class PaddingValues {
  PaddingValues._();

  static const double padding = 20;

  static const double paddingSmall = 10;

  static const double paddingMedium = 15;
}

class BorderRadiusValues {
  BorderRadiusValues._();

  static const double radius = 20;

  static const double radiusMedium = 15;

  static const double radiusSmall = 10;

  static const double extraRadiusSmall = 8;

  static const double dialogBorderRadius = 12;
}
