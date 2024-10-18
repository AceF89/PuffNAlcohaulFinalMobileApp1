import 'dart:io';
import 'package:bugsee_flutter/bugsee.dart';

class BugseeService {
  BugseeService();

  static String getApplicationToken() {
    return Platform.isAndroid
        ? '1b4e3d4a-bccc-41b3-a2cf-cfe3900d8a85'
        : (Platform.isIOS ? '33958f30-e7ae-4fc2-bfc9-658cbf558785' : '');
  }

  static BugseeLaunchOptions? createLaunchOptions() {
    if (Platform.isAndroid) {
      final options = AndroidLaunchOptions();
      options.videoEnabled = true;
      options.wifiOnlyUpload = true;
      options.viewHierarchyEnabled = false;

      return options;
    }

    if (Platform.isIOS) {
      final options = IOSLaunchOptions();
      options.videoEnabled = true;
      options.wifiOnlyUpload = true;
      options.viewHierarchyEnabled = false;

      return options;
    }

    return null;
  }

  static Future<void> launchBugsee(void Function(bool isBugseeLaunched) appRunner) async {
    final options = createLaunchOptions();

    await Bugsee.launch(getApplicationToken(), appRunCallback: appRunner, launchOptions: options);
  }
}
