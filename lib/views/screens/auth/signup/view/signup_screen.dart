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
                                InkWell(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text("Terms and conditions",style: TextStyle(fontWeight: FontWeight.w700,),),
                                        content: const SingleChildScrollView(
                                          child: Text('''Terms and Conditions for Puff N AlcoHaul Inc.
                                          
1. Introduction
Welcome to Puff N AlcoHaul Inc. ("the App" or "the Service"), a comprehensive platform dedicated to delivering a wide variety of alcoholic beverages directly to your doorstep. These Terms and Conditions ("Terms") serve as a detailed guide to your rights, responsibilities, and obligations when using our Service. By accessing, browsing, or registering on the App, you agree to comply with these Terms, which constitute a legally binding agreement between you and Puff N AlcoHaul Inc. If you disagree with any part of these Terms, you must immediately stop using the Service.

2. Eligibility
2.1 Legal Drinking Age Requirement: To access and use the Service, you must meet the legal drinking age in your jurisdiction, which is typically 21 years old in the United States. By registering or placing an order, you confirm that you meet this requirement. Puff N AlcoHaul Inc. reserves the right to verify your age at any time.
2.2 Geographical Restrictions: The Service is only available in jurisdictions where alcohol delivery is legally permitted. You are responsible for ensuring that your use of the App complies with the laws of your locality.
2.3 Prohibited Users: The Service is not available to individuals who have been previously banned by Puff N AlcoHaul Inc. or those who fail to meet the eligibility criteria.

3. Account Registration
3.1 Registration Requirements: To use the Service, users must create an account by providing accurate, complete, and current information, including a valid email address, phone number, and proof of age. Providing false or misleading information is strictly prohibited.
3.2 Account Security: Users are responsible for safeguarding their account credentials. Sharing your account with others or allowing unauthorized access is prohibited. Notify Puff N AlcoHaul Inc. immediately if you suspect unauthorized use of your account.
3.3 Account Suspension or Termination: Puff N AlcoHaul Inc. reserves the right to suspend or permanently terminate accounts for violating these Terms, engaging in fraudulent activities, or for any other reason at our discretion.

4. Ordering and Delivery
4.1 Placing an Order: Orders can only be placed through the App. Users must ensure that all details, including delivery address and product selection, are accurate. Puff N AlcoHaul Inc. reserves the right to reject or cancel orders due to stock limitations, regulatory constraints, or other reasons.
4.2 Identity Verification at Delivery: Upon delivery, users must present a valid government- issued ID that matches the name on the order. Failure to provide appropriate identification will result in the cancellation of the delivery, and a cancellation fee may be applied.
4.3 Delivery Zones and Timing: Delivery services are restricted to designated geographical areas. While we strive to deliver orders promptly, factors such as traffic, weather, or other external conditions may result in delays. Updates will be communicated through the App.
4.4 Failed Deliveries: If delivery cannot be completed due to user unavailability, refusal to provide identification, or providing incorrect information, a restocking fee may be applied.

5. Payment
5.1 Accepted Payment Methods: Payments must be made at the time of placing an order using accepted methods, including credit cards, debit cards, and approved digital wallets.
5.2 Payment Authorization: By providing payment details, users authorize Puff N AlcoHaul Inc. to process the total order amount, including applicable taxes and delivery fees.
5.3 Refunds and Returns: Refunds may be issued in cases such as incorrect deliveries, damaged goods, or order cancellations. Refund requests must be submitted within 7 days of receiving the order and are subject to approval.
5.4 Order Cancellation Policy: Orders may be canceled if the request is made before the order has been processed or dispatched. Cancellations after processing may incur fees.

6. Prohibited Activities
6.1 Resale and Commercial Use: Alcohol purchased through the App is for personal consumption only and cannot be resold or used for commercial purposes.
6.2 Fraudulent Behavior: Providing false information, using stolen payment methods, or engaging in other fraudulent activities is strictly prohibited and may result in legal action.
6.3 Interference with the App: Users must not tamper with, hack, or reverse-engineer the App’s functionality or use it for unauthorized purposes.

7. Liability and Disclaimers
7.1 Service Availability: While Puff N AlcoHaul Inc. aims to provide continuous service, there may be interruptions due to maintenance, technical issues, or other reasons. The App is provided on an "as is" basis.
7.2 No Warranties: Puff N AlcoHaul Inc. disclaims all warranties, express or implied, including fitness for a particular purpose, merchantability, and non-infringement.
7.3 Limitation of Liability: To the extent permitted by law, Puff N AlcoHaul Inc. is not liable for any damages, losses, or injuries resulting from the use of the Service, including but not limited to delivery delays, incorrect orders, or unauthorized access to user accounts.

8. Privacy
8.1 Data Collection: Puff N AlcoHaul Inc. collects personal information such as name, contact details, and order history to facilitate Service delivery. Refer to our Privacy Policy for more details on data use and protection.
8.2 Third-Party Services: The App may link to third-party platforms, such as payment processors or promotional partners. Puff N AlcoHaul Inc. is not responsible for the privacy practices or terms of these third parties.

9. Intellectual Property 
All materials, including text, graphics, logos, and other content available on the App, are the intellectual property of Puff N AlcoHaul Inc. or its licensors. Unauthorized use, reproduction, or modification is prohibited.

10. Modifications to Terms
Puff N AlcoHaul Inc. reserves the right to modify these Terms at any time. Updated Terms will be posted on the App, and continued use of the Service constitutes acceptance of the changes.

11. Governing Law and Dispute Resolution
11.1 Applicable Law: These Terms are governed by the laws of [Your State/Country], excluding its conflict of law principles.
11.2 Dispute Resolution: All disputes will be resolved through binding arbitration under the rules of [Arbitration Body], to be held in [Location]. Users waive the right to participate in class-action lawsuits.

12. Contact Us
For questions or assistance, please contact Puff N AlcoHaul Inc.:
• Email: info@alcohaulbsw.com
By using the App, you acknowledge that you have read, understood, and agreed to these comprehensive Terms and Conditions.'''),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },);
                                  },
                                  child: const Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primaryColor,
                                      color: AppColors.primaryColor,
                                    ),
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
