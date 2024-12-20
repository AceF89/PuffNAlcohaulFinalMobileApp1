import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/checkout/provider/checkout_provider.dart';
import 'package:alcoholdeliver/views/screens/checkout/widgets/checkout_order_info.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/license_card.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_date_selector.dart';
import 'package:alcoholdeliver/views/widgets/primary_time_selector.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutOtionsScreen extends StatefulWidget {
  const CheckoutOtionsScreen({super.key});

  @override
  State<CheckoutOtionsScreen> createState() => _CheckoutOtionsScreenState();
}

class _CheckoutOtionsScreenState extends State<CheckoutOtionsScreen> {
  late CheckoutProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Return To Cart'),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(checkoutProvider);

        return ScrollableColumn.withSafeArea(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxH20(),
            // const CheckoutOptionsOrderInfo(),
            CheckoutOrderInfo(
              isPickupOrder: provider.deliveryMethod == DeliveryMethod.pickup,
              productCost: provider.subTotal,
              subTotal: provider.subTotal,
              driverTip: provider.driversTip,
              serviceFee: provider.serviceFee == 0 ? 'FREE' : '\$${provider.serviceFee}',
              taxes: provider.taxes,
              total: provider.total,
              controller: provider.loyaltyController,
              selectedPoints: provider.loyaltyPoints,
              totalWithLoyalty: provider.totalWithLoyalty,
              onChangeValue: provider.onChangeLoyaltyPoints,
            ),
            SizedBoxH10(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Delivery',
                    outlined: provider.deliveryMethod != DeliveryMethod.delivery,
                    onPressed: () {
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
                  'Minimum order of \$10 is required for delivery',
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

            SizedBoxH20(),
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
                'Please upload your Driver’s License. Order CAN ONLY be handed to person on the LICENSE',
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
                    onTap: () => provider.onSelectImage(context, 'FRONT'),
                  ),
                  SizedBoxW20(),
                  LicenseCard(
                    label: 'Back Copy',
                    selectedImage: provider.backLicense,
                    onTap: () => provider.onSelectImage(context, 'BACK'),
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
              onPressed: () {
                provider.changeDeliveryDateTime(DeliveryDateTime.asSoonAsPossible);
              },
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
                label: 'Select Delivery Date',
                icon: AppAssets.icCalender,
              ),
              SizedBoxH20(),
              PrimaryTimeSelector(
                label: 'Select Delivery Time',
                selectedTime: provider.selectedDeliveryTime,
                setSelectedTime: provider.onChangeDeliveryTime,
                showError: provider.showDeliveryDateError,
                icon: AppAssets.icClockFilled,
              ),
            ],
            SizedBoxH30(),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.s10.sp),
          child: PrimaryButton(
            showShadow: true,
            label: "Continue to Pay",
            onPressed: () async {
              final status = await provider.preCheckout(context);
              if (!status) return;

              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamed(Routes.paymentMethod);
            },
          ),
        ),
      ),
    );
  }
}
