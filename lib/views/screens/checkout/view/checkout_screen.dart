import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/model/add_to_card.dart';
import 'package:alcoholdeliver/model/cart.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/cart_provider.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/checkout/provider/checkout_provider.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/cart_items.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/checkout_order_info.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/free_service_banner.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/tip_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/license_card.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_date_selector.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/primary_time_selector.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with ValidationMixin {
  late CheckoutProvider provider;
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.clear();
      provider.getMe(context);
      provider.checkUserIsWithinDeliveryRadius(context);
      final data = await provider.getCart(context);
      if (data == null) return;
      _cartProvider.setupCart(data);
    });
  }

  void handleOnDelete(OrderItem item) async {
    final status = await _cartProvider.addOrRemoveCart(
      context,
      AddToCart(
        productId: item.productId ?? 0,
        quantity: 0,
        method: '',
      ),
    );

    if (status) {
      provider.removeItem(item);
      _cartProvider.removeFromCart(Product(id: item.productId));
    }
  }

  void handleOnChangeQuantity(int value, OrderItem item) {
    provider.updateQuantity(item, value);
    _cartProvider.updateQuantity(
      Product(id: item.productId),
      value,
    );
    if (value == 0) provider.removeItem(item);
  }

  void handleOnIncrement(int value, OrderItem item) async {
    _cartProvider.updateQuantity(
      Product(id: item.productId),
      value,
    );
    await _cartProvider.addOrRemoveCart(
      context,
      AddToCart(
        productId: item.productId ?? 0,
        quantity: value,
        method: 'add',
      ),
      showSnackbar: false,
    );
  }

  void handleOnDecrement(int value, OrderItem item) async {
    _cartProvider.updateQuantity(
      Product(id: item.productId),
      value,
    );
    await _cartProvider.addOrRemoveCart(
      context,
      AddToCart(
        productId: item.productId ?? 0,
        quantity: value,
        method: '',
      ),
      showSnackbar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      provider = ref.watch(checkoutProvider);
      _cartProvider = ref.watch(cartProvider);

      return Scaffold(
        appBar: BackAppBar(context, title: 'Checkout'),
        body: !provider.isDataAvailable
            ? const EmptyCart()
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ScrollableColumn.withSafeArea(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxH20(),
                    ListView.builder(
                      itemCount: provider.cartData?.orderItems?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final curProduct = provider.cartData!.orderItems![index];

                        return CartItems(
                          product: curProduct,
                          onTapDelete: () => handleOnDelete(curProduct),
                          onChangeQuantity: (int value) => handleOnChangeQuantity(value, curProduct),
                          onIncrement: (int value) => handleOnIncrement(value, curProduct),
                          onDecrement: (int value) => handleOnDecrement(value, curProduct),
                        );
                      },
                    ),
                    const BlueDivider(),
                    SizedBoxH10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.s18.sp,
                          ),
                        ),
                        Text(
                          '\$${provider.subTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.s18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxH10(),
                    if (provider.deliveryMethod == DeliveryMethod.delivery && provider.awayFromFreeService != null) ...[
                      const BlueDivider(),
                      FreeServiceBanner(label: provider.awayFromFreeService!)
                    ],
                    const BlueDivider(),
                    if (!provider.isUserWithinDeliveryRadius) ...[
                      Text(
                        'Currently delivery isn\'t available in your area, we are working hard to expand to your location. You can still place a pickup order and we will have it ready for you when you arrive.',
                        style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          color: AppColors.errorColor,
                        ),
                      ),
                    ],
                    SizedBoxH10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Delivery',
                            outlined: provider.deliveryMethod != DeliveryMethod.delivery,
                            onPressed: () {
                              if (!provider.isUserWithinDeliveryRadius) {
                                context.showFailureSnackBar('Currently delivery isn\'t available in your area.');
                                return;
                              }
                              provider.changeDeliveryMethod(DeliveryMethod.delivery);
                            },
                          ),
                        ),
                        SizedBoxW10(),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Pick-Up',
                            outlined: provider.deliveryMethod != DeliveryMethod.pickup,
                            onPressed: () {
                              provider.changeDeliveryMethod(DeliveryMethod.pickup);
                            },
                          ),
                        ),
                      ],
                    ),

                    if (provider.deliveryMethod == DeliveryMethod.delivery) ...[
                      SizedBoxH10(),
                      if (provider.subTotal < 10)
                        Text(
                          r'Minimum order of $10 is required for delivery',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: Sizes.s14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],

                    if (provider.deliveryMethod == DeliveryMethod.pickup) ...[
                      SizedBoxH10(),
                      Text(
                        'Please bring a valid driver\'s license that matches your name for pickup.',
                        style: TextStyle(
                          color: AppColors.secondaryFontColor,
                          fontSize: Sizes.s14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    SizedBoxH10(),

                    if (provider.deliveryMethod == DeliveryMethod.pickup) ...[
                      Text(
                        'Pick-Up Address',
                        style: TextStyle(
                          fontSize: Sizes.s18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        provider.cartData?.storeAddress ?? 'N/A',
                        style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                      SizedBoxH10(),
                    ],

                    Text(
                      'Tip',
                      style: TextStyle(
                        fontSize: Sizes.s18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Never required. Always appreciated!',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryFontColor,
                      ),
                    ),
                    SizedBoxH10(),
                    SizedBox(
                      height: Sizes.s50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          TipCard(
                            label: '15%',
                            isSelected: provider.selectedTip == TipPercentage.fifteen,
                            onTap: () {
                              provider.onSelectTip(TipPercentage.fifteen);
                            },
                          ),
                          TipCard(
                            label: '20%',
                            isSelected: provider.selectedTip == TipPercentage.twenty,
                            onTap: () {
                              provider.onSelectTip(TipPercentage.twenty);
                            },
                          ),
                          TipCard(
                            label: '25%',
                            isSelected: provider.selectedTip == TipPercentage.twentyFive,
                            onTap: () {
                              provider.onSelectTip(TipPercentage.twentyFive);
                            },
                          ),
                          SizedBox(
                            width: Sizes.s120,
                            child: PrimaryTextField(
                              hintText: 'Custom Tip',
                              prefixIconConstraints: const BoxConstraints(
                                maxWidth: 28,
                                minWidth: 28,
                                maxHeight: 42,
                                minHeight: 42,
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12, left: 12),
                                child: Text('\$', style: TextStyle(fontSize: Sizes.s16.sp)),
                              ),
                              controller: provider.tipController,
                              bColor: AppColors.primaryFontColor,
                              textInputAction: TextInputAction.done,
                              onTap: () => provider.onSelectTip(TipPercentage.custom),
                              hintColor: AppColors.secondaryFontColor.withOpacity(0.8),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                              onEditingComplete: () {
                                String text = provider.tipController.text;

                                if (text.isNotEmpty) {
                                  double? value = double.tryParse(text);
                                  if (value != null) {
                                    provider.tipController.text = value.toStringAsFixed(2);
                                  }
                                }

                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (value) {
                                // Allow "0" but remove leading zeros from other numbers
                                if (value != '0' && value.startsWith('0') && !value.startsWith('0.')) {
                                  provider.tipController.text = value.substring(1);
                                  provider.tipController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: provider.tipController.text.length),
                                  );
                                }

                                provider.onSelectTip(TipPercentage.custom);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBoxH10(),
                    const GreyDivider(),
                    SizedBoxH10(),
                    CheckoutOrderInfo(
                      isPickupOrder: provider.deliveryMethod == DeliveryMethod.pickup,
                      productCost: provider.subTotal,
                      subTotal: provider.subTotal,
                      driverTip: provider.driversTip,
                      serviceFee: provider.serviceFee == 0 ? 'FREE' : '\$${provider.serviceFee.toStringAsFixed(2)}',
                      taxes: provider.taxes,
                      total: provider.total,
                      totalWithLoyalty: provider.totalWithLoyalty,
                      controller: provider.loyaltyController,
                      selectedPoints: provider.loyaltyPoints,
                      onChangeValue: provider.onChangeLoyaltyPoints,
                    ),
                    SizedBoxH10(),
                    Text(
                      'Order Type',
                      style: TextStyle(
                        fontSize: Sizes.s18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBoxH5(),
                    Text(
                      provider.deliveryMethod == DeliveryMethod.delivery ? 'DELIVERY' : 'PICK-UP',
                      style: TextStyle(
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (provider.deliveryMethod == DeliveryMethod.delivery) ...[
                      SizedBoxH10(),
                      Text(
                        'Your Driving License',
                        style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBoxH5(),
                      Text(
                        'Please upload your driving license photo',
                        style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                      SizedBoxH10(),
                      Row(
                        children: [
                          LicenseCard(
                            label: 'Front Copy',
                            selectedImage: provider.frontLicense,
                            selectedImageUrl: provider.frontDLUrl,
                            onTap: () => provider.onSelectImage(context, 'FRONT'),
                            showButton: true,
                            buttonLabel: 'Upload',
                          ),
                          SizedBoxW20(),
                          LicenseCard(
                            label: 'Back Copy',
                            selectedImage: provider.backLicense,
                            selectedImageUrl: provider.backDLUrl,
                            onTap: () => provider.onSelectImage(context, 'BACK'),
                            showButton: true,
                            buttonLabel: 'Upload',
                          ),
                        ],
                      ),
                    ],

                    /// Pickup Timming
                    SizedBoxH20(),
                    PrimaryButton(
                      label: "As soon as possible",
                      outlined: provider.deliveryDateTime != DeliveryDateTime.asSoonAsPossible,
                      textColor: provider.deliveryDateTime != DeliveryDateTime.asSoonAsPossible
                          ? AppColors.secondaryFontColor
                          : AppColors.whiteFontColor,
                      outlinedColor: provider.deliveryDateTime != DeliveryDateTime.asSoonAsPossible
                          ? AppColors.primaryFontColor
                          : AppColors.primaryFontColor,
                      onPressed: () => provider.changeDeliveryDateTime(DeliveryDateTime.asSoonAsPossible),
                    ),
                    SizedBoxH10(),
                    PrimaryButton(
                      label: "Specific date and time",
                      outlined: provider.deliveryDateTime != DeliveryDateTime.dateTime,
                      textColor: provider.deliveryDateTime != DeliveryDateTime.dateTime
                          ? AppColors.secondaryFontColor
                          : AppColors.whiteFontColor,
                      outlinedColor: provider.deliveryDateTime != DeliveryDateTime.dateTime
                          ? AppColors.primaryFontColor
                          : AppColors.primaryFontColor,
                      onPressed: () {
                        provider.changeDeliveryDateTime(DeliveryDateTime.dateTime);
                      },
                    ),
                    SizedBoxH10(),

                    if (provider.deliveryDateTime == DeliveryDateTime.dateTime) ...[
                      PrimaryDateSelector(
                        firstDate: DateTime.now(),
                        selectedDate: provider.selectedDeliveryDate,
                        setSelectedDate: provider.onChangeDeliveryDate,
                        showError: provider.showDeliveryDateError,
                        label: provider.deliveryMethod == DeliveryMethod.delivery
                            ? 'Select Delivery Date'
                            : 'Select Pickup Date',
                        icon: AppAssets.icCalender,
                        dateFormate: 'MM / DD / YY',
                        disabledDays: const [DateTime.sunday],
                      ),
                      SizedBoxH20(),
                      PrimaryTimeSelector(
                        show24HoursFormat: false,
                        icon: AppAssets.icClockFilled,
                        showError: provider.showDeliveryDateError,
                        selectedTime: provider.selectedDeliveryTime,
                        minTime: const TimeOfDay(hour: 10, minute: 30),
                        maxTime: const TimeOfDay(hour: 20, minute: 30),
                        setSelectedTime: provider.onChangeDeliveryTime,
                        label: provider.deliveryMethod == DeliveryMethod.delivery
                            ? 'Select Pickup Time'
                            : 'Select Pickup Time',
                      ),
                    ],
                    SizedBoxH30(),
                  ],
                ),
              ),
        bottomNavigationBar: !provider.isDataAvailable
            ? null
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.s10.sp),
                  child: PrimaryButton(
                    showShadow: true,
                    label: "Proceed To Pay",
                    onPressed: () async {
                      if (provider.subTotal < 10) {
                        // ignore: use_build_context_synchronously
                        context.showFailureSnackBar(r'Minimum order of $10 is required for delivery');
                        return;
                      }

                      // ignore: use_build_context_synchronously
                      if (provider.loyaltyPoints >= 500) await provider.applyLoyaltyPoints(context);

                      // ignore: use_build_context_synchronously
                      final status = await provider.preCheckout(context);
                      if (!status) return;

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamed(Routes.paymentMethod);
                    },
                  ),
                ),
              ),
      );
    });
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.s20),
      child: Center(
        child: Image.asset(AppAssets.emptyCart),
      ),
    );
  }
}
