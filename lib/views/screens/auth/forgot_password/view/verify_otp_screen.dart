import 'package:alcoholdeliver/views/screens/auth/widgets/auth_header.dart';
import 'package:alcoholdeliver/views/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/auth/forgot_password/provider/forgot_password_provider.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with ValidationMixin {
  late ForgotPasswordProvider _forgotPasswordProvider;

  String codeExpireMessage = 'Code is expired in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          _forgotPasswordProvider = ref.watch(forgotPasswordProvider);

          return SafeArea(
            child: AppBackground(
              child: Form(
                key: _forgotPasswordProvider.verifyOtpFormKey,
                child: ScrollableColumn.withSafeArea(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxH20(),
                    const AuthHeader(
                      header: 'OTP Verification',
                      subHeader:
                          'Please enter 4 digit OTP that you received on your registered email address',
                    ),
                    SizedBoxH20(),
                    PinCodeTextField(
                      length: 4,
                      animationType: AnimationType.fade,
                      autoDisposeControllers: false,
                      errorTextSpace: Sizes.s32.h,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        borderRadius: BorderRadius.circular(Sizes.s10.sp),
                        activeFillColor: Colors.white,
                        inactiveColor: AppColors.borderColor,
                      ),
                      validator: otpValidation,
                      animationDuration: const Duration(milliseconds: 300),
                      controller: _forgotPasswordProvider.otpController,
                      keyboardType: TextInputType.number,
                      onCompleted: (_) {},
                      appContext: context,
                      onChanged: (_) {},
                    ),
                    SizedBoxH10(),
                    PrimaryButton(
                        label: 'Verify OTP',
                        showShadow: true,
                        onPressed: () async {
                          final status =
                              await _forgotPasswordProvider.verifyOtp(context);
                          if (!status) return;

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamed(
                            Routes.forgotPasswordNewPassword,
                          );
                        }),
                    SizedBoxH50(),
                    SizedBoxH50(),
                    PrimaryTextButton(
                      label: 'Resend OTP',
                      onPressed: () {},
                    ),
                    SizedBoxH50(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
