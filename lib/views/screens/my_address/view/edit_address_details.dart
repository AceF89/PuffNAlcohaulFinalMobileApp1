import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/views/screens/my_address/provider/edit_address_provider.dart';
import 'package:alcoholdeliver/views/screens/my_address/provider/my_address_provider.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/places_search_list.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/center_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditAddressDetails extends StatefulWidget {
  final UserAddress address;

  const EditAddressDetails({super.key, required this.address});

  @override
  State<EditAddressDetails> createState() => _EditAddressDetailsState();
}

class _EditAddressDetailsState extends State<EditAddressDetails>
    with ValidationMixin {
  late EditAddressProvider _provider;
  late MyAddressProvider _myAddressProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setSetupOldAddress(widget.address, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(context, title: 'Enter address details'),
      backgroundColor: AppColors.secondarybackgroundColor,
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(editAddressProvider);
        _myAddressProvider = ref.read(myAddressProvider);

        return Form(
          key: _provider.formKey,
          child: ScrollableColumn.withSafeArea(
            children: [
              RoundedContainer(
                child: Column(
                  children: [
                    // PrimaryTextField(
                    //   hintText: '',
                    //   isMandatory: true,
                    //   labelText: 'Client\'s name',
                    //   keyboardType: TextInputType.text,
                    //   labelColor: AppColors.secondaryFontColor,
                    //   controller: _provider.clientNameController,
                    //   validator: (_) => clientNameValidation(_provider.clientNameController.text),
                    // ),
                    // SizedBoxH20(),
                    PrimaryTextField(
                      isMandatory: true,
                      hintText: '',
                      labelText: 'Address 1',
                      validator: addressValidation,
                      keyboardType: TextInputType.text,
                      onChanged: _provider.onChangeSearch,
                      controller: _provider.addressController,
                      labelColor: AppColors.secondaryFontColor,
                    ),
                    PlacesSearchList(
                      isLoading: _provider.isSearchLoading,
                      placesList: _provider.searchedPlaces,
                      onSelectPlace: _provider.onSelectSearchLocation,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'Address 2',
                      keyboardType: TextInputType.text,
                      hintText: 'Apartment, suite, unit, building, floor, etc.',
                      controller: _provider.address2Controller,
                      labelColor: AppColors.secondaryFontColor,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      isMandatory: false,
                      hintText: '',
                      labelText: 'Phone Number',
                      validator: phoneNumberNotMandatoryValidation,
                      keyboardType: TextInputType.number,
                      controller: _provider.phoneNumberController,
                      labelColor: AppColors.secondaryFontColor,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      hintText: '',
                      labelText: 'Zip Code',
                      isMandatory: true,
                      keyboardType: TextInputType.text,
                      controller: _provider.zipcodeController,
                      labelColor: AppColors.secondaryFontColor,
                      readOnly: true,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'State',
                      hintText: 'State',
                      labelColor: AppColors.secondaryFontColor,
                      validator: (_) =>
                          stateValidation(_provider.stateController.text),
                      controller: _provider.stateController,
                      isMandatory: true,
                      readOnly: true,
                    ),
                    SizedBoxH20(),
                    PrimaryTextField(
                      labelText: 'City',
                      hintText: 'City',
                      labelColor: AppColors.secondaryFontColor,
                      validator: (_) =>
                          cityValidation(_provider.cityController.text),
                      controller: _provider.cityController,
                      isMandatory: true,
                      readOnly: true,
                    ),
                    SizedBoxH20(),
                    PrimaryButton(
                      label: 'Save Address',
                      onPressed: () async {
                        final status = await _provider.saveAddress(context);
                        if (!status) return;

                        _myAddressProvider.getAllAddress();

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
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
