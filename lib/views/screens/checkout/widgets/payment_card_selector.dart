import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/model/saved_cards.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentCardSelector extends StatelessWidget {
  final List<SavedCards> cards;
  final SavedCards? selectedCard;
  final Function onTapCard;
  final Function onDeleteCard;

  const PaymentCardSelector({
    super.key,
    required this.cards,
    required this.selectedCard,
    required this.onTapCard,
    required this.onDeleteCard,
  });

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const NoDataAvailable(label: 'No Cards Available');
    }

    return ListView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      itemBuilder: (ctx, i) {
        final curCard = cards[i];
        final isSelected = selectedCard?.id == curCard.id;

        return GestureDetector(
          onTap: () {
            onTapCard.call(curCard);
          },
          child: Container(
            padding: const EdgeInsets.all(Sizes.s10),
            margin: const EdgeInsets.only(bottom: Sizes.s10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(Sizes.s10),
              border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.transparent),
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
                      curCard.brand ?? 'N/A',
                      style: TextStyle(
                        color: AppColors.primaryFontColor,
                        fontSize: Sizes.s14.sp,
                      ),
                    ),
                    SizedBoxH5(),
                    Text(
                      '**** **** **** ${curCard.last4 ?? '1234'}',
                      style: TextStyle(
                        color: AppColors.secondaryFontColor,
                        fontSize: Sizes.s12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => onDeleteCard(context, curCard),
                  child: SvgPicture.asset(
                    AppAssets.icBin,
                    height: Sizes.s18.h,
                    width: Sizes.s18.w,
                  ),
                ),
                SizedBoxW10(),
              ],
            ),
          ),
        );
      },
    );
  }
}
