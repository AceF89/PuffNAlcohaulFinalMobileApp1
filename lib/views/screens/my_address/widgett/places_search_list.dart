import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/google/g_places.dart';
import 'package:alcoholdeliver/views/screens/my_address/widgett/rounded_container.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlacesSearchList extends StatelessWidget {
  final bool isLoading;
  final List<GPlaces> placesList;
  final Function(GPlaces) onSelectPlace;

  const PlacesSearchList({
    super.key,
    required this.isLoading,
    required this.placesList,
    required this.onSelectPlace,
  });

  @override
  Widget build(BuildContext context) {
    if (placesList.isEmpty) return const SizedBox();

    return RoundedContainer(
      height: Sizes.s200.sp,
      width: double.infinity,
      child: isLoading
          ? Loader.circularProgressIndicator()
          : ListView.builder(
              itemCount: placesList.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                final place = placesList[i];

                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    onSelectPlace(place);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: Sizes.s14.sp),
                    child: Row(
                      children: [
                        SvgPicture.asset(AppAssets.icLocation),
                        SizedBoxW10(),
                        Expanded(
                          child: Text(
                            place.description ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: Sizes.s16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
