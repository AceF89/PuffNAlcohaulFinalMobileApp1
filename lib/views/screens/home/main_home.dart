import 'dart:isolate';
import 'dart:ui';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/enums.dart';
import 'package:alcoholdeliver/services/location/background_locator_callbacks.dart';
import 'package:alcoholdeliver/services/location/background_locator_repository.dart';
import 'package:alcoholdeliver/services/location/location_service.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/accounts_screen.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/driver_account_screen.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/homepage_screen.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/my_orders_screen.dart';
import 'package:alcoholdeliver/views/screens/no_location_screen/no_location_screen.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;

late ValueNotifier<NavigationTab> bottomTabNotifier;

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  ReceivePort port = ReceivePort();
  Stream<gl.ServiceStatus>? _serviceStatusStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bottomTabNotifier = ValueNotifier(NavigationTab.home);

    if (IsolateNameServer.lookupPortByName(BackgroundLocatorRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(BackgroundLocatorRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, BackgroundLocatorRepository.isolateName);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (preferences.isDriver) {
        _serviceStatusStream = LocationService.getServiceStatusStream;
        _checkInitalLocationStatus();
        _setupLocationListner();
      } else {
        _cleanOldBGLocationListener();
      }
    });
  }

  void _cleanOldBGLocationListener() async {
    await BackgroundLocator.unRegisterLocationUpdate();
  }

  void _checkInitalLocationStatus() async {
    await LocationService.checkPermission(requestPermission: true);
    final status = await LocationService.checkServiceStatus;
    status ? _startBgLocator() : _showLocationAlert();
  }

  void _setupLocationListner() {
    _serviceStatusStream?.listen((gl.ServiceStatus status) {
      if (status == gl.ServiceStatus.disabled) {
        _showLocationAlert();
        _cleanOldBGLocationListener();
      }

      if (status == gl.ServiceStatus.enabled) {
        _hideLocationAlert();
        _startBgLocator();
      }
    });
  }

  void _showLocationAlert() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NoLocationScreen()));
  }

  void _hideLocationAlert() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  Future<void> _startBgLocator() async {
    DartPluginRegistrant.ensureInitialized();

    await LocationService.checkPermission(requestPermission: true);

    await BackgroundLocator.initialize();

    final serviceStatus = await BackgroundLocator.isServiceRunning();
    debugPrint('📍 BG Location #Running Status - ${serviceStatus.toString()}');

    final locationUpdateStatus = await BackgroundLocator.isRegisterLocationUpdate();
    debugPrint('📍 BG Location #Location Update Status - ${locationUpdateStatus.toString()}');

    if (!serviceStatus) {
      const iosSettings = IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 100,
        stopWithTerminate: true,
        showsBackgroundLocationIndicator: true,
      );

      const androidSetting = AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 10,
        distanceFilter: 0,
        client: LocationClient.android,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIconColor: Colors.grey,
          notificationIcon: '@mipmap/launcher_icon',
          notificationTapCallback: BackgroundLocatorCallabacks.notificationCallback,
        ),
      );

      await BackgroundLocator.registerLocationUpdate(
        BackgroundLocatorCallabacks.callback,
        autoStop: true,
        initDataCallback: {'countInit': 1},
        initCallback: BackgroundLocatorCallabacks.initCallback,
        disposeCallback: BackgroundLocatorCallabacks.disposeCallback,
        iosSettings: iosSettings,
        androidSettings: androidSetting,
      );
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(BackgroundLocatorRepository.isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NavigationTab>(
      valueListenable: bottomTabNotifier,
      builder: (context, currentTab, _) {
        return Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: PrimaryBottomNavBar(currentTab: currentTab),
          body: _buildCurrentChild(currentTab),
        );
      },
    );
  }

  Widget _buildCurrentChild(NavigationTab currentTab) {
    Widget currentChild = const SizedBox.shrink();
    switch (currentTab) {
      case NavigationTab.home:
        currentChild = const HomepageScreen();
        break;
      case NavigationTab.myOrders:
        currentChild = const MyOrdersScreen();
        break;
      case NavigationTab.accounts:
        if (preferences.isDriver) {
          currentChild = const DriverAccountScreen();
        } else {
          currentChild = const AccountsScreen();
        }
        break;
      default:
    }
    return currentChild;
  }
}
