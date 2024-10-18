import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/services/location/location_service.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/center_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class NoLocationScreen extends StatelessWidget {
  const NoLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(context, title: 'No Location', canBack: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: Sizes.s100.sp, color: AppColors.errorColor),
            SizedBoxH20(),
            Text(
              'Location Service is Off',
              style: TextStyle(fontSize: Sizes.s24.sp, color: AppColors.errorColor),
            ),
            SizedBoxH20(),
            Text(
              'Please turn on your location services to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Sizes.s18.sp),
            ),
            SizedBoxH20(),
            PrimaryButton(
              width: Sizes.s200.sp,
              onPressed: () async => await LocationService.openLocationSettings(context),
              label: 'Enable Location',
            ),
          ],
        ),
      ),
    );
  }
}
