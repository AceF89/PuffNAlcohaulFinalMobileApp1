import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/views/screens/checkout/provider/checkout_provider.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/check_box.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> with ValidationMixin {
  late CheckoutProvider provider;

  void onTapAddCard() async {
    final formKey = provider.paymentMethodFormKey;
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!provider.isAcceptedTerm) {
      context.showFailureSnackBar('Please accept Terms & Conditions');
      return;
    }

    final cardToken = await provider.getTokenFromStripeCard(context);
    final cardTokenId = cardToken?.id ?? '';

    // ignore: use_build_context_synchronously
    await provider.saveCardTokenToStripe(context, cardTokenId);

    // ignore: use_build_context_synchronously
    await provider.getAllSavedStripeCard(context);

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Add Card'),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(checkoutProvider);

        return Form(
          key: provider.paymentMethodFormKey,
          child: ScrollableColumn.withSafeArea(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxH10(),
              PrimaryTextField(
                labelText: 'Card Holder Name',
                labelColor: AppColors.secondaryFontColor,
                hintText: '',
                keyboardType: TextInputType.text,
                validator: cardHolderNameValidation,
                controller: provider.cardHolderName,
              ),
              SizedBoxH20(),
              PrimaryTextField(
                labelText: 'Card Number',
                labelColor: AppColors.secondaryFontColor,
                hintText: '',
                validator: cardNumberValidation,
                keyboardType: TextInputType.number,
                controller: provider.cardNumber,
              ),
              SizedBoxH20(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PrimaryTextField(
                      labelText: 'Valid until',
                      validator: validUntilValidation,
                      labelColor: AppColors.secondaryFontColor,
                      hintText: 'MM/YY',
                      keyboardType: TextInputType.number,
                      controller: provider.validUntil,
                      onChanged: provider.onChangeValidUntil,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                    ),
                  ),
                  SizedBoxW10(),
                  Expanded(
                    child: PrimaryTextField(
                      labelText: 'Security Code',
                      labelColor: AppColors.secondaryFontColor,
                      hintText: '',
                      validator: securityCodeValidation,
                      keyboardType: TextInputType.number,
                      controller: provider.securityCode,
                    ),
                  ),
                ],
              ),
              SizedBoxH20(),
              PrimaryTextField(
                labelText: 'Email Address',
                labelColor: AppColors.secondaryFontColor,
                hintText: '',
                validator: emailAddressValidation,
                keyboardType: TextInputType.text,
                controller: provider.emailAddress,
              ),
              SizedBoxH10(),
              CheckBox(
                label: 'Accept the  Terms & Conditions',
                isChecked: provider.isAcceptedTerm,
                onChanged: provider.toggleTermandCondition,
              ),
              // SizedBoxH10(),
              // CheckBox(
              //   label: 'Use as default payment method',
              //   isChecked: provider.isAcceptedDefaultPayment,
              //   onChanged: provider.toggleDefaultPayment,
              // ),
              SizedBoxH20(),
              PrimaryButton(
                label: 'Add Card',
                showShadow: true,
                onPressed: onTapAddCard,
              ),
            ],
          ),
        );
      }),
    );
  }
}
