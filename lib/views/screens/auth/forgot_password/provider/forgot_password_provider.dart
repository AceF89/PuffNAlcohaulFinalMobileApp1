import 'package:alcoholdeliver/apis/auth_api/auth_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';

final ChangeNotifierProvider<ForgotPasswordProvider> forgotPasswordProvider =
    ChangeNotifierProvider((ref) => ForgotPasswordProvider());

class ForgotPasswordProvider extends DefaultChangeNotifier {
  final AuthApi _api = AuthApi.instance;
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> verifyOtpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();

  bool passwordObscureText = true;
  bool confirmPasswordObscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ForgotPasswordProvider();

  void reset() {
    passwordObscureText = true;
    confirmPasswordObscureText = true;
    emailController.clear();
    otpController.clear();
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

  Future<bool> forgotPassword(BuildContext context,
      {bool validateForm = true}) async {
    if (validateForm) {
      if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) {
        return false;
      }
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.forgotPassword(
        email: emailController.text,
      );

      return result.when(
        (value) async {
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

  // Future<bool> verifyOtp(BuildContext context) async {
  //   if (!(verifyOtpFormKey.currentState?.validate() ?? false)) {
  //     verifyOTP(context);
  //   }
  //
  //   return true;
  // }
  Future<bool> verifyOTP(BuildContext context) async {
    // if (verifyOtpFormKey.currentState!.validate()) {
    //   return false;
    // }
    if(otpController.text.isEmpty) {
      context.showFailureSnackBar('OTP is required');
      return false;
    }
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.verifyOTP(
        email: emailController.text,
        code: otpController.text,
      );

      return result.when(
            (value) async {
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


  Future<bool> updateNewPassword(BuildContext context) async {
    if (!(newPasswordFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.verifyOTPChangePassword(
        email: emailController.text,
        code: otpController.text,
        newPassword: passwordController.text,
      );

      return result.when(
        (value) async {
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
