import 'package:alcoholdeliver/apis/auth_api/auth_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<ChangePasswordProvider> changePasswordProvider =
    ChangeNotifierProvider((ref) => ChangePasswordProvider());

class ChangePasswordProvider extends DefaultChangeNotifier {
  final AuthApi _api = AuthApi.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ChangePasswordProvider();

  void reset() {
    passwordObscureText = true;
    confirmPasswordObscureText = true;
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void togglePasswordObscureText() {
    passwordObscureText = !passwordObscureText;
    notify();
  }

  void toggleConfirmPasswordObscureText() {
    confirmPasswordObscureText = !confirmPasswordObscureText;
    notify();
  }

  Future<bool> updateNewPassword(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.verifyOTPChangePassword(
        email: null,
        code: null,
        newPassword: passwordController.text,
      );

      return result.when(
        (value) async {
          Loader.dismiss(context);
          context.showSuccessSnackBar('Password Changed Successfully');
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
