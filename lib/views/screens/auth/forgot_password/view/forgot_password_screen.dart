import 'package:alcoholdeliver/views/screens/auth/widgets/auth_header.dart';
import 'package:alcoholdeliver/views/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/auth/forgot_password/provider/forgot_password_provider.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with ValidationMixin {
  late ForgotPasswordProvider _forgotPasswordProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forgotPasswordProvider.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          _forgotPasswordProvider = ref.watch(forgotPasswordProvider);

          return SafeArea(
            child: AppBackground(
              child: Form(
                key: _forgotPasswordProvider.forgotPasswordFormKey,
                child: ScrollableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxH20(),
                    const AuthHeader(
                      header: 'Forgot Password?',
                      subHeader:
                          'Please enter your registered email address to receive 4 digit OTP',
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Email Address',
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: emailAddressValidation,
                      keyboardType: TextInputType.emailAddress,
                      controller: _forgotPasswordProvider.emailController,
                    ),
                    SizedBoxH20(),
                    PrimaryButton(
                      label: 'Send Code',
                      showShadow: true,
                      onPressed: () async {
                        final status = await _forgotPasswordProvider
                            .forgotPassword(context);
                        if (!status) return;

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushReplacementNamed(
                            Routes.forgotPasswordVerifyScreen);
                      },
                    ),
                    SizedBoxH20(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.s20.sp),
          child: PrimaryButton.outlined(
            label: 'Back To Sign In',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
