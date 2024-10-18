import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/checkout/provider/checkout_provider.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/payment_card_selector.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> with ValidationMixin {
  late CheckoutProvider provider;
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllSavedStripeCard(context);
    });
  }

  void onTapPayNow() async {
    if (provider.selectedSavedCard == null) {
      context.showFailureSnackBar('Please Select Card');
      return;
    }

    final cardTokenId = provider.selectedSavedCard?.id ?? '';

    // ignore: use_build_context_synchronously
    final response = await provider.chargeCard(context, cardTokenId);
    if (response == null) return;

    // ignore: use_build_context_synchronously
    await _cartProvider.getCart(context);

    // ignore: use_build_context_synchronously
    Navigator.of(context)
      ..pop()
      ..pop();
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, Routes.paymentSuccess, arguments: response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Payment Method'),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(checkoutProvider);
        _cartProvider = ref.read(cartProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
          child: provider.isLoadingSavedCards
              ? Loader.circularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Selection
                    SizedBoxH10(),
                    const _Header(),
                    SizedBoxH10(),
                    Expanded(
                      child: PaymentCardSelector(
                        cards: provider.savedCards,
                        selectedCard: provider.selectedSavedCard,
                        onTapCard: provider.onChangeCard,
                        onDeleteCard: provider.deleteCard,
                      ),
                    ),
                    SizedBoxH20(),
                    PrimaryButton(
                      label: 'Pay Now',
                      showShadow: true,
                      onPressed: onTapPayNow,
                    ),
                    SizedBoxH10(),
                  ],
                ),
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select Card',
          style: TextStyle(
            color: AppColors.primaryFontColor,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.s18.sp,
          ),
        ),
        PrimaryTextButton(
          label: 'Add Card',
          fontSize: Sizes.s16.sp,
          fontWeight: FontWeight.w600,
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.addNewCard);
          },
        ),
      ],
    );
  }
}
