import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<AccountsProvider> accountsProvider = ChangeNotifierProvider((ref) => AccountsProvider());

class AccountsProvider extends DefaultChangeNotifier {
  UserDetails? user;
  final UserApi _api = UserApi.instance;

  AccountsProvider();

  void updateLocalUser(UserDetails n) {
    final oldUser = preferences.getUserProfile();
    final updatedProfile = n.copyWith(token: oldUser?.token);
    preferences.userProfile = updatedProfile;
    user = updatedProfile;
    notify();
  }

  Future<void> getMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.getMe();

      return result.when(
        (value) async {
          updateLocalUser(value);
          Loader.dismiss(context);
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<bool> deleteMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.deleteMe();

      return result.when(
        (value) async {
          preferences.logoutUser();
          preferences.clear();
          Loader.dismiss(context);
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
