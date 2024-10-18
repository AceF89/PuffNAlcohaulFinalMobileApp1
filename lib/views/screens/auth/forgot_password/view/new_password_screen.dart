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

class NewPassowrdScreen extends StatefulWidget {
  const NewPassowrdScreen({super.key});

  @override
  State<NewPassowrdScreen> createState() => _NewPassowrdScreenState();
}

class _NewPassowrdScreenState extends State<NewPassowrdScreen>
    with ValidationMixin {
  late ForgotPasswordProvider _forgotPasswordProvider;
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode.addListener(() {
      setState(() => _isKeyboardOpen = _newPasswordFocusNode.hasFocus);
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(() => _isKeyboardOpen = _confirmPasswordFocusNode.hasFocus);
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
                key: _forgotPasswordProvider.newPasswordFormKey,
                child: ScrollableColumn.withSafeArea(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxH20(),
                    const AuthHeader(
                      header: 'Create New Password',
                      subHeader:
                          'Your new password must be different from previously used password',
                    ),
                    SizedBoxH30(),
                    PrimaryTextField(
                      labelText: 'New Password',
                      focusNode: _newPasswordFocusNode,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: passwordValidation,
                      controller: _forgotPasswordProvider.passwordController,
                      obscureText: _forgotPasswordProvider.passwordObscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _forgotPasswordProvider.passwordObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.iconColor,
                        ),
                        onPressed:
                            _forgotPasswordProvider.togglePasswordObscureText,
                      ),
                    ),
                    SizedBoxH30(),
                    PrimaryTextField(
                      labelText: 'Confirm Password',
                      focusNode: _confirmPasswordFocusNode,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      controller:
                          _forgotPasswordProvider.confirmPasswordController,
                      validator: (value) {
                        return confirmPasswordValidation(
                            _forgotPasswordProvider.passwordController.text,
                            value ?? '');
                      },
                      obscureText:
                          _forgotPasswordProvider.confirmPasswordObscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _forgotPasswordProvider.confirmPasswordObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.iconColor,
                        ),
                        onPressed: _forgotPasswordProvider
                            .toggleConfirmPasswordObscureText,
                      ),
                    ),
                    SizedBoxH20(),
                    PrimaryButton(
                      label: 'Reset Password',
                      showShadow: true,
                      onPressed: () async {
                        final status = await _forgotPasswordProvider
                            .updateNewPassword(context);
                        if (!status) return;

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.loginScreen,
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    SizedBoxH20(),
                    if (_isKeyboardOpen) SizedBox(height: Sizes.s250.h),
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
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.loginScreen,
              (Route<dynamic> route) => false,
            ),
          ),
        ),
      ),
    );
  }
}
