import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/saved_cards.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardTile extends StatelessWidget {
  final SavedCards card;
  final Function(SavedCards) onDeleteCard;

  const CardTile({super.key, required this.card, required this.onDeleteCard});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.s10),
      margin: const EdgeInsets.only(bottom: Sizes.s10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Sizes.s10),
      ),
      child: Row(
        children: [
          ImageView(
            imageUrl: 'https://cdn-icons-png.flaticon.com/512/217/217425.png',
            height: Sizes.s40.h,
            width: Sizes.s40.w,
          ),
          SizedBoxW10(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.brand ?? 'N/A',
                style: TextStyle(
                  color: AppColors.primaryFontColor,
                  fontSize: Sizes.s14.sp,
                ),
              ),
              SizedBoxH5(),
              Text(
                '**** **** **** ${card.last4 ?? '1234'}',
                style: TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontSize: Sizes.s12.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => onDeleteCard(card),
            child: SvgPicture.asset(
              AppAssets.icBin,
              height: Sizes.s18.h,
              width: Sizes.s18.w,
            ),
          ),
          SizedBoxW10(),
        ],
      ),
    );
  }
}
