import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/accounts/dialogs/logout_dialog.dart';
import 'package:alcoholdeliver/views/screens/accounts/provider/driver_account_provider.dart';
import 'package:alcoholdeliver/views/screens/accounts/widgets/accounts_background.dart';
import 'package:alcoholdeliver/views/widgets/license_card.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverAccountScreen extends StatefulWidget {
  const DriverAccountScreen({super.key});

  @override
  State<DriverAccountScreen> createState() => _DriverAccountScreenState();
}

class _DriverAccountScreenState extends State<DriverAccountScreen> with ValidationMixin {
  late DriverAccountProvider _provider;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.clear();
      _provider.getMe(context);
      _emailFocusNode.addListener(() {
        setState(() => _isKeyboardOpen = _emailFocusNode.hasFocus);
      });
      _phoneNumberFocusNode.addListener(() {
        setState(() => _isKeyboardOpen = _phoneNumberFocusNode.hasFocus);
      });
    });
  }

  void handleLogout() async {
    final status = await LogoutDialog.show(context);
    if (status == null || status == false) return;

    preferences.logoutUser();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.loginScreen,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          _provider = ref.watch(driverAccountProvider);

          return SafeArea(
            child: AccountsBackground(
              onTapImage: () => _provider.onSelectImage(context, 'PROFILE_PIC'),
              selectedImage: _provider.selectedUserProfile,
              imageUrl: _provider.oldUser?.fullFileUrl ?? '',
              child: Form(
                key: _provider.formKey,
                child: ScrollableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxH10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryTextButton(
                          label: 'Log Out',
                          onPressed: handleLogout,
                        ),
                        SizedBoxW10(),
                      ],
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'First Name',
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: (_) => nameValidation(_provider.firstName.text),
                      keyboardType: TextInputType.name,
                      controller: _provider.firstName,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Last Name',
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: (_) => nameValidation(_provider.lastName.text),
                      keyboardType: TextInputType.name,
                      controller: _provider.lastName,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Phone Number',
                      focusNode: _phoneNumberFocusNode,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: (_) => phoneNumberValidation(_provider.phoneNumber.text),
                      keyboardType: TextInputType.phone,
                      controller: _provider.phoneNumber,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Email',
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      focusNode: _emailFocusNode,
                      validator: (_) => emailAddressValidation(_provider.email.text),
                      keyboardType: TextInputType.emailAddress,
                      controller: _provider.email,
                    ),
                    SizedBoxH20(),
                    Text(
                      'Driving License',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.secondaryFontColor,
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBoxH5(),
                    Row(
                      children: [
                        LicenseCard(
                          label: 'Front Copy',
                          selectedImageUrl: _provider.frontDLUrl,
                          selectedImage: _provider.selectedFrontDrivingLicense,
                          onTap: () => _provider.onSelectImage(context, 'FRONT_DL'),
                          showButton: true,
                          buttonLabel: 'Upload',
                        ),
                        SizedBoxW20(),
                        LicenseCard(
                          label: 'Back Copy',
                          selectedImageUrl: _provider.backDLUrl,
                          selectedImage: _provider.selectedBackDrivingLicense,
                          onTap: () => _provider.onSelectImage(context, 'BACK_DL'),
                          showButton: true,
                          buttonLabel: 'Upload',
                        ),
                      ],
                    ),
                    SizedBoxH20(),
                    PrimaryButton(
                      showShadow: true,
                      label: 'Save Changes',
                      onPressed: () async {
                        final updatedUser = await _provider.updateMe(context);
                        if (updatedUser == null) return;
                      },
                    ),
                    SizedBoxH50(),
                    SizedBoxH50(),
                    SizedBoxH50(),
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
