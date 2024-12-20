import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/homepage_provider.dart';
import 'package:alcoholdeliver/views/screens/homepage/widgets/icon_containers.dart';
import 'package:alcoholdeliver/views/screens/my_address/dialog/delete_address_dialog.dart';
import 'package:alcoholdeliver/views/screens/my_address/provider/my_address_provider.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/address_card.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/center_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  late MyAddressProvider _provider;
  late HomepageProvider _homePageProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getAllAddress();
    });
  }

  Future<void> onTapDeleteMeHandler(BuildContext context, num id) async {
    if (_provider.address.length <= 1) {
      context.showFailureSnackBar(
          'Address List should have at least 2 addresses to delete old address');
      return;
    }

    if (!_provider.hasDefaultAddress) {
      context.showFailureSnackBar(
          'Address List should have at 1 default address to delete old address');
      return;
    }

    final status = await DeleteAddressDialog.show(context);
    if (status == null || status == false) return;

    // ignore: use_build_context_synchronously
    _provider.deleteSavedAddress(context, id);
  }

  Future<void> onTapAddressHandler(
      BuildContext context, UserAddress address) async {
    await _provider.setDefaultAddress(context, address);
    _homePageProvider.getDefaultAddress();
  }

  Future<void> onTapEditAddressHandler(
      BuildContext context, UserAddress address) async {
    Navigator.of(context)
        .pushNamed(Routes.editAddressDetails, arguments: address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(context, title: 'My Addresses'),
      backgroundColor: AppColors.secondarybackgroundColor,
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(myAddressProvider);
        _homePageProvider = ref.read(homepageProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
          child: Column(
            children: [
              const _AddAddressButton(),
              SizedBoxH10(),
              const _SaveAddressDivider(),
              SizedBoxH10(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _provider.address.length,
                  itemBuilder: (ctx, i) {
                    final address = _provider.address[i];
                    return AddressCard(
                      address: address,
                      onTap: () => onTapAddressHandler(context, address),
                      onTapEdit: () =>
                          onTapEditAddressHandler(context, address),
                      onTapDelete: () =>
                          onTapDeleteMeHandler(context, address.id ?? 0),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}

class _AddAddressButton extends StatelessWidget {
  const _AddAddressButton();

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: () =>
          Navigator.of(context).pushNamed(Routes.confirmDeliveryAddress),
      child: Row(
        children: [
          const IconContainer(
            icon: AppAssets.icAdd2,
            height: Sizes.s35,
            width: Sizes.s35,
          ),
          SizedBoxW10(),
          Text(
            'Add address',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: Sizes.s16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            AppAssets.icForwardArrow,
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
          SizedBoxW10(),
        ],
      ),
    );
  }
}

class _SaveAddressDivider extends StatelessWidget {
  const _SaveAddressDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: Sizes.s1,
            color: AppColors.quinaryFontColor,
          ),
        ),
        SizedBoxW10(),
        Text(
          'SAVED ADDRESSES',
          style: TextStyle(
            color: AppColors.quinaryFontColor,
            fontSize: Sizes.s16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBoxW10(),
        Expanded(
          child: Container(
            height: Sizes.s1,
            color: AppColors.quinaryFontColor,
          ),
        ),
      ],
    );
  }
}
