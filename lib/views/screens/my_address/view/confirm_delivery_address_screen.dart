import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/google/g_custom_places.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/my_address/provider/confirm_delivery_provider.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/places_search_list.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/center_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmDeliveryAdddressScreen extends StatelessWidget {
  const ConfirmDeliveryAdddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(context, title: 'Confirm Delivery Location'),
      backgroundColor: AppColors.secondarybackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
        child: Column(
          children: [
            const _SearchTextField(),
            SizedBoxH10(),
            const MapSelection(),
            SizedBoxH10(),
          ],
        ),
      ),
    );
  }
}

class MapSelection extends StatefulWidget {
  const MapSelection({super.key});

  @override
  State<MapSelection> createState() => _MapSelectionState();
}

class _MapSelectionState extends State<MapSelection> {
  late ConfirmDeliveryProvider provider;

  @override
  void dispose() {
    provider.clean();

    /// Do Not dispose provide, It will dispose default provide as well!
    // provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        provider = ref.watch(confirmDeliveryProvider);

        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s8),
                    child: GoogleMap(
                      compassEnabled: true,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: provider.onMapCreated,
                      markers: provider.markers,
                      onTap: (LatLng? position) {
                        provider.handleOnTapMap(position);
                        FocusScope.of(context).unfocus();
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(32.829518, -96.944218),
                        zoom: 10,
                      ),
                    ),
                  ),

                  /// Top Page Contents
                  PlacesSearchList(
                    isLoading: provider.isSearchLoading,
                    placesList: provider.searchedPlaces,
                    onSelectPlace: provider.onSelectSearchLocation,
                  ),

                  /// Bottom Page Contents
                  if (!isKeyboardVisible)
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Show Map Loading
                          if (provider.loading) ...[
                            Expanded(
                              child: Container(
                                color: Colors.black.withOpacity(0.4),
                                child: Loader.circularProgressIndicator(),
                              ),
                            ),
                          ],

                          /// Show User Current Location Button
                          if (!provider.loading) ...[
                            _UseCurrentLocation(
                                () => provider.getCurrentPosition(context)),
                            SizedBoxH10(),
                          ],

                          /// Show Current marker Address Details
                          if (!provider.loading && !provider.isMarkerEmpty) ...[
                            _BuildCurrentAddressView(
                              address: provider.currentAddress,
                              onTapButton: () async {
                                if (provider.isMarkerEmpty) {
                                  context.showFailureSnackBar(
                                      'Please select Location');
                                  return;
                                }
                                provider.cleanAddresDetailsPage();
                                await provider
                                    .onSelectSearchLocationAddressDetails(
                                        provider.selectedPlaces!);
                                Navigator.of(context)
                                    .pushNamed(Routes.addressDetails);
                              },
                            ),
                            SizedBoxH10(),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BuildCurrentAddressView extends StatelessWidget {
  final GCustomPlaces? address;
  final VoidCallback onTapButton;

  const _BuildCurrentAddressView(
      {required this.address, required this.onTapButton});

  // String? get _buildStreet {
  //   if (address == null) return null;
  //   return address?.name ?? 'N/A';
  // }

  // String? get _buildAddress {
  //   if (address == null) return null;
  //   return '${address?.name}, ${address?.street}, ${address?.locality}';
  // }

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.s10, horizontal: Sizes.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppAssets.icMarkerBlue,
                height: Sizes.s18,
                width: Sizes.s18,
              ),
              SizedBoxW10(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (address == null)
                      Text(
                        'Couldn\'t get address, Pleasefill details manually',
                        style: TextStyle(
                          fontSize: Sizes.s16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (address != null) ...[
                      SizedBoxH5(),
                      Text(
                        address?.address ?? 'N/A',
                        style: TextStyle(
                          fontSize: Sizes.s14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryFontColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBoxH10(),
          PrimaryButton(
            label: 'Add more address details',
            fontSize: Sizes.s16.sp,
            height: Sizes.s40,
            onPressed: onTapButton,
          )
        ],
      ),
    );
  }
}

class _UseCurrentLocation extends StatelessWidget {
  final VoidCallback onTap;

  const _UseCurrentLocation(this.onTap);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      onTap: onTap,
      borderWidth: 1,
      borderColor: AppColors.primaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppAssets.icMyLocation,
          ),
          SizedBoxW10(),
          const Text(
            'Use current location',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final provider = ref.watch(confirmDeliveryProvider);

      return TextField(
        onChanged: provider.onChangeSearch,
        controller: provider.searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search for area, street name...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.s8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: Sizes.s15,
            horizontal: Sizes.s10,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryColor,
          ),
        ),
      );
    });
  }
}
