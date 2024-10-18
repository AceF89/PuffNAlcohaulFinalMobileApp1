import 'package:alcoholdeliver/apis/auth_api/auth_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';

final AutoDisposeChangeNotifierProvider<LoginProvider> loginProvider =
    ChangeNotifierProvider.autoDispose((ref) => LoginProvider());

class LoginProvider extends DefaultChangeNotifier {
  bool obscureText = true;
  final AuthApi _api = AuthApi.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginProvider();

  void toggleObscureText() {
    obscureText = !obscureText;
    notify();
  }

  Future<bool> userLogin(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.userLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          preferences.userProfile = value;
          context.showSuccessSnackBar('Login successful');
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
