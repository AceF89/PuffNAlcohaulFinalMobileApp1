import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/views/screens/auth/change_password/provider/change_password_provider.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with ValidationMixin {
  late ChangePasswordProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Change Password',
        backgroundColor: Colors.white,
      ),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(changePasswordProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
          child: Form(
            key: provider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBoxH20(),
                PrimaryTextField(
                  labelText: 'New Password',
                  labelColor: AppColors.secondaryFontColor,
                  hintText: 'Enter New Password',
                  validator: passwordValidation,
                  controller: provider.passwordController,
                  obscureText: provider.passwordObscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.passwordObscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.iconColor,
                    ),
                    onPressed: provider.togglePasswordObscureText,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.s12),
                    child: SvgPicture.asset(
                      AppAssets.icLock,
                      height: Sizes.s10,
                      width: Sizes.s10,
                    ),
                  ),
                ),
                SizedBoxH20(),
                PrimaryTextField(
                  labelText: 'Confirm Password',
                  labelColor: AppColors.secondaryFontColor,
                  hintText: 'Confirm Password',
                  controller: provider.confirmPasswordController,
                  validator: (value) {
                    return confirmPasswordValidation(
                      provider.passwordController.text,
                      value ?? '',
                    );
                  },
                  obscureText: provider.confirmPasswordObscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.confirmPasswordObscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.iconColor,
                    ),
                    onPressed: provider.toggleConfirmPasswordObscureText,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.s12),
                    child: SvgPicture.asset(
                      AppAssets.icLock,
                      height: Sizes.s10,
                      width: Sizes.s10,
                    ),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Change Password',
                  onPressed: () async {
                    final status = await provider.updateNewPassword(context);
                    if (!status) return;

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
                SizedBoxH30(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
