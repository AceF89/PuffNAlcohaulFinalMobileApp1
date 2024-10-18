import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/auth/widgets/auth_header.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/places_search_list.dart';
import 'package:alcoholdeliver/views/widgets/app_background.dart';
import 'package:alcoholdeliver/views/widgets/check_box.dart';
import 'package:alcoholdeliver/views/widgets/primary_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/views/screens/auth/signup/provider/signup_provider.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with ValidationMixin {
  late SignupProvider _signupProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          _signupProvider = ref.watch(signupProvider);

          return KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return SafeArea(
                child: AppBackground(
                  child: Form(
                    key: _signupProvider.formKey,
                    child: ScrollableColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBoxH20(),
                        const AuthHeader(
                          header: 'Sign Up',
                          subHeader: 'Create an account',
                        ),
                        SizedBoxH50(),
                        PrimaryTextField(
                          hintText: '',
                          isMandatory: true,
                          labelText: 'First Name',
                          validator: nameValidation,
                          keyboardType: TextInputType.name,
                          labelColor: AppColors.secondaryFontColor,
                          controller: _signupProvider.firstNameController,
                          inputFormatters: [InputFormatters.alphabetWithSpace],
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          hintText: '',
                          isMandatory: true,
                          labelText: 'Last Name',
                          validator: nameValidation,
                          keyboardType: TextInputType.name,
                          labelColor: AppColors.secondaryFontColor,
                          controller: _signupProvider.lastNameController,
                          inputFormatters: [InputFormatters.alphabetWithSpace],
                        ),
                        SizedBoxH20(),
                        // PrimaryTextField(
                        //   labelText: 'Apartment',
                        //   labelColor: AppColors.secondaryFontColor,
                        //   hintText: '',
                        //   keyboardType: TextInputType.text,
                        //   controller: _signupProvider.apartmentController,
                        // ),
                        // SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Address 1',
                          labelColor: AppColors.secondaryFontColor,
                          hintText: '',
                          validator: addressValidation,
                          keyboardType: TextInputType.text,
                          controller: _signupProvider.address1Controller,
                          isMandatory: true,
                          onChanged: _signupProvider.onChangeSearch,
                        ),
                        PlacesSearchList(
                          isLoading: _signupProvider.isSearchLoading,
                          placesList: _signupProvider.searchedPlaces,
                          onSelectPlace: _signupProvider.onSelectSearchLocation,
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Address 2',
                          labelColor: AppColors.secondaryFontColor,
                          hintText:
                              'Apartment, suite, unit, building, floor, etc.',
                          keyboardType: TextInputType.text,
                          controller: _signupProvider.address2Controller,
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Zipcode',
                          labelColor: AppColors.secondaryFontColor,
                          hintText: '',
                          isMandatory: true,
                          readOnly: true,
                          validator: (_) => addressValidation(
                              _signupProvider.zipcodeController.text),
                          keyboardType: TextInputType.number,
                          controller: _signupProvider.zipcodeController,
                          onChanged: _signupProvider.onChangeZipcode,
                        ),
                        SizedBoxH20(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PrimaryTextField(
                                labelText: 'State',
                                hintText: 'State',
                                labelColor: AppColors.secondaryFontColor,
                                validator: (_) => stateValidation(
                                    _signupProvider.stateController.text),
                                controller: _signupProvider.stateController,
                                isMandatory: true,
                                readOnly: true,
                              ),
                            ),
                            SizedBoxW10(),
                            Expanded(
                              child: PrimaryTextField(
                                labelText: 'City',
                                hintText: 'City',
                                labelColor: AppColors.secondaryFontColor,
                                validator: (_) => cityValidation(
                                    _signupProvider.cityController.text),
                                controller: _signupProvider.cityController,
                                isMandatory: true,
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxH20(),
                        PrimaryDateSelector(
                          label: 'Date of Birth',
                          selectedDate: _signupProvider.selectedDob,
                          setSelectedDate: _signupProvider.onChangeDobDate,
                          lastDate: DateTime.now(),
                          showError: _signupProvider.showDobDateError,
                          icon: AppAssets.icCalender,
                          firstDate: DateTime(DateTime.now().year - 100),
                          isMandatory: true,
                          dateFormate: 'MM / DD / YY',
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Email Address',
                          labelColor: AppColors.secondaryFontColor,
                          hintText: '',
                          validator: emailAddressValidation,
                          keyboardType: TextInputType.emailAddress,
                          controller: _signupProvider.emailController,
                          isMandatory: true,
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Phone Number',
                          labelColor: AppColors.secondaryFontColor,
                          hintText: '',
                          validator: phoneNumberNotMandatoryValidation,
                          keyboardType: TextInputType.phone,
                          controller: _signupProvider.mobileNumberController,
                        ),
                        SizedBoxH20(),
                        PrimaryTextField(
                          labelText: 'Password',
                          labelColor: AppColors.secondaryFontColor,
                          hintText: '',
                          validator: passwordValidation,
                          controller: _signupProvider.passwordController,
                          obscureText: _signupProvider.passwordObscureText,
                          isMandatory: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _signupProvider.passwordObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.iconColor,
                            ),
                            onPressed:
                                _signupProvider.togglePasswordObscureText,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                CheckBox(
                                  isChecked: _signupProvider.agreeTermCondition,
                                  onChanged:
                                      _signupProvider.handleTermConditionToggle,
                                ),
                                const Text('I agree with'),
                                SizedBoxW05(),
                                const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryColor,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBoxH20(),
                        PrimaryButton(
                          label: 'Sign Up',
                          onPressed: () async {
                            bool isSucces =
                                await _signupProvider.signupUser(context);
                            if (!isSucces) return;

                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.mainHome, (route) => false);
                          },
                        ),
                        SizedBoxH30(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: AppColors.secondaryFontColor,
                                fontWeight: FontWeight.w400,
                                fontSize: Sizes.s16.h,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text(
                                ' Sign In',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.s16.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBoxH50(),
                        if (isKeyboardVisible) SizedBox(height: Sizes.s250.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
