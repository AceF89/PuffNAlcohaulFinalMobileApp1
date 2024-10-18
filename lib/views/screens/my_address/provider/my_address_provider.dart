import 'dart:async';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<MyAddressProvider> myAddressProvider =
    ChangeNotifierProvider.autoDispose((ref) => MyAddressProvider());

class MyAddressProvider extends DefaultChangeNotifier {
  final UserApi _userApi = UserApi.instance;
  List<UserAddress> address = [];

  MyAddressProvider();

  void updateLocalUser(UserDetails n) {
    final oldUser = preferences.getUserProfile();
    final updatedProfile = n.copyWith(token: oldUser?.token);
    preferences.userProfile = updatedProfile;
    notify();
  }

  bool get hasDefaultAddress =>
      address.any((value) => value.isDefault ?? false);

  void _updateDefaultAddress(num? id) async {
    if (id == null) return;

    List<UserAddress> updatedAddress = address.map((e) {
      if (e.id == id) {
        return e.copyWith(isDefault: true);
      } else {
        return e.copyWith(isDefault: false);
      }
    }).toList();

    address.clear();
    address.addAll(updatedAddress);

    notify();
  }

  Future<void> getMe() async {
    if (await ConnectivityService.isConnected) {
      var result = await _userApi.getMe();

      return result.when(
        (value) async {
          updateLocalUser(value);
        },
        (error) {},
      );
    }
  }

  Future<void> getAllAddress() async {
    final context = kNavigatorKey.currentState?.context;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      if (context != null) Loader.show(context);

      var result = await _userApi.getAllAddress();

      return result.when(
        (value) async {
          address = value;
          notify();
          if (context != null) Loader.dismiss(context);
        },
        (error) {
          if (context != null) Loader.dismiss(context);
          if (context != null) context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      if (context != null) context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<bool> deleteSavedAddress(BuildContext context, num id) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.deleteSavedAddress(id: id);

      return result.when(
        (value) async {
          address.removeWhere((e) => e.id == id);
          Loader.dismiss(context);
          notify();
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<bool> setDefaultAddress(
      BuildContext context, UserAddress address) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.addNewAddress(
          address: address.copyWith(isDefault: true));

      getMe();

      return result.when(
        (value) async {
          Loader.dismiss(context);
          _updateDefaultAddress(address.id);
          context.showSuccessSnackBar('Default address changed');
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }
}
