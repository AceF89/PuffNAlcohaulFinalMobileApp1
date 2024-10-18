import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class AgentCard extends StatelessWidget {
  final String name;
  final String type;
  final VoidCallback? onTapChat;
  final String? imageUrl;

  const AgentCard({
    super.key,
    required this.name,
    required this.type,
    this.imageUrl,
    this.onTapChat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageView(
          imageUrl: imageUrl ?? 'https://picsum.photos/300/300',
          height: Sizes.s40,
          width: Sizes.s40,
          radius: BorderRadius.circular(Sizes.s200),
        ),
        SizedBoxW10(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: AppColors.primaryFontColor,
                fontWeight: FontWeight.w500,
                fontSize: Sizes.s16.sp,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                color: AppColors.secondaryFontColor,
                fontWeight: FontWeight.w500,
                fontSize: Sizes.s14.sp,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTapChat,
          child: Container(
            padding: const EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Sizes.s10),
            ),
            child: SvgPicture.asset(
              AppAssets.icMessage,
            ),
          ),
        ),
      ],
    );
  }
}
