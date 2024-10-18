import 'dart:convert';
import 'dart:io';
import 'package:alcoholdeliver/firebase_options.dart';
import 'package:alcoholdeliver/services/bugsee_service.dart';
import 'package:bugsee_flutter/bugsee.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/preferences.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/core/utils/theme_utils.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FlutterError.onError = (errorDetails) => FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  createNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // OneSignal.Debug.setLogLevel(
  //     OSLogLevel.verbose); //Remove this method to stop OneSignal Debugging
  // OneSignal.initialize("0786cb33-a26b-47e4-b6ea-aca66e3006c6");
  // OneSignal.Notifications.requestPermission(true);

  tz.initializeTimeZones();

  HttpOverrides.global = Bugsee.defaultHttpOverrides;

  await BugseeService.launchBugsee((bool isBugseeLaunched) async {
    runApp(const ProviderScope(child: AlcoholDelivery()));
  });

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

createNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      'Message main title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

  String title = '';
  String body = '';
  dynamic data = message.data;

  title = '${message.notification?.title}';
  body = '${message.notification?.body}';

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.max, priority: Priority.high);
  NotificationDetails platformChannelSpecifics = const NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: json.encode(data));
}

String deviceId = "";

Future<void> initPlatformState() async {
  OneSignal.initialize(EnvValues.oneSignalKey);

  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  await OneSignal.Notifications.requestPermission(true);
  var playerID = OneSignal.User.pushSubscription.id;
  print("playerID ${playerID}");
  OneSignal.User.pushSubscription.addObserver((state) {
    print("pushSubscription.optedIn ${OneSignal.User.pushSubscription.optedIn}");
    print("pushSubscription.id ${OneSignal.User.pushSubscription.id}");
    print("pushSubscription.token ${OneSignal.User.pushSubscription.token}");
    print("current.jsonRepresentation ${state.current.jsonRepresentation()}");
  });
  OneSignal.Notifications.addPermissionObserver((state) {});
  OneSignal.Notifications.addClickListener((event) {
    print(
        'NOTIFICATION CLICK LISTENER CALLED WITH EVENT: ${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}');
    notificationClickAction(event.notification.jsonRepresentation().replaceAll("\\n", "\n"));
  });
  OneSignal.InAppMessages.addClickListener((event) {
    print(
        'NOTIFICATION CLICK LISTENER CALLED WITH EVENT: ${event.message.jsonRepresentation().replaceAll("\\n", "\n")}');

    notificationClickAction(event.message.jsonRepresentation().replaceAll("\\n", "\n"));
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    // getUserStore(NavigationService.context).getAllNotifications();
  });
}

void notificationClickAction(String data) {
  try {
    Map<String, dynamic> notificationData = jsonDecode(data);
  } catch (e, stack) {
    debugPrint("Error: $e");
    debugPrint("Stack: $stack");
  }
}

class AlcoholDelivery extends StatefulWidget {
  const AlcoholDelivery({super.key});

  @override
  State<AlcoholDelivery> createState() => _AlcoholDeliveryState();
}

class _AlcoholDeliveryState extends State<AlcoholDelivery> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initPlatformState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      navigatorKey: kNavigatorKey,
      theme: ThemeUtils.theme,
      initialRoute: Routes.splashScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.9)),
          child: ScrollConfiguration(
            behavior: const _ScrollBehaviorModified(),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  ScreenUtil.init(
                    constraints,
                    designSize: Size(constraints.maxWidth, constraints.maxHeight),
                    context: context,
                  );
                  return child ?? const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScrollBehaviorModified extends ScrollBehavior {
  const _ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
