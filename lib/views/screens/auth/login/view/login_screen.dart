import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/views/screens/auth/widgets/auth_header.dart';
import 'package:alcoholdeliver/views/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/auth/login/provider/login_provider.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  late LoginProvider _loginProvider;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() => _isKeyboardOpen = _emailFocusNode.hasFocus);
    });
    _passwordFocusNode.addListener(() {
      setState(() => _isKeyboardOpen = _passwordFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          _loginProvider = ref.watch(loginProvider);

          return SafeArea(
            child: AppBackground(
              child: Form(
                key: _loginProvider.formKey,
                child: ScrollableColumn(
                  children: [
                    SizedBoxH20(),
                    const AuthHeader(
                      header: 'Sign In',
                      subHeader: 'Welcome Back!',
                    ),
                    SizedBoxH30(),
                    PrimaryTextField(
                      labelText: 'Email Address',
                      focusNode: _emailFocusNode,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: emailAddressValidation,
                      keyboardType: TextInputType.emailAddress,
                      controller: _loginProvider.emailController,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Password',
                      focusNode: _passwordFocusNode,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      obscureText: _loginProvider.obscureText,
                      suffixIcon: GestureDetector(
                        onTap: _loginProvider.toggleObscureText,
                        child: _loginProvider.obscureText
                            ? Padding(
                                padding: const EdgeInsets.all(Sizes.s12),
                                child: SvgPicture.asset(
                                  AppAssets.icEyeHide,
                                  height: Sizes.s10,
                                  width: Sizes.s10,
                                ),
                              )
                            : const Icon(
                                Icons.remove_red_eye_outlined,
                                color: AppColors.iconColor,
                              ),
                      ),
                      validator: passwordValidation,
                      controller: _loginProvider.passwordController,
                    ),
                    SizedBoxH20(),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(Routes.forgotPasswordScreen),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primaryFontColor,
                                fontWeight: FontWeight.w500,
                                fontSize: Sizes.s14.h,
                              ),
                            ),
                          ),
                          PrimaryButton(
                            label: 'Sign In',
                            width: Sizes.s100.w,
                            showShadow: true,
                            onPressed: () async {
                              final status = await _loginProvider.userLogin(context);
                              if (!status) return;

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacementNamed(Routes.mainHome);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBoxH50(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: AppColors.primaryFontColor,
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.s16.h,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(Routes.signupScreen),
                          child: Text(
                            ' Sign up',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.s16.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBoxH30(),
                    if (_isKeyboardOpen) SizedBox(height: Sizes.s250.h),
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
