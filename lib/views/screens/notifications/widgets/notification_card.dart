import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/notification.dart';
import 'package:alcoholdeliver/views/screens/notifications/view/notification_screens.dart';
import 'package:alcoholdeliver/views/widgets/image_view.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final ListType type;
  final Function onTap;
  final List<NotificationRes> notifications;

  const NotificationCard({
    super.key,
    required this.notifications,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String label = '';
    List<NotificationRes> filteredNotifications = [];
    if (type == ListType.today) {
      label = 'TODAY';
      filteredNotifications = notifications.where((e) => e.isToday).toList();
    } else if (type == ListType.yesterday) {
      label = 'YESTERDAY';
      filteredNotifications = notifications.where((e) => e.isYesterday).toList();
    } else if (type == ListType.older) {
      label = 'OLDER';
      filteredNotifications = notifications.where((e) => e.isOlder).toList();
    }

    if (filteredNotifications.isEmpty) return const SizedBox();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.secondaryFontColor,
                  fontWeight: FontWeight.w500,
                  fontSize: Sizes.s18.sp,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: filteredNotifications.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            final curNotification = filteredNotifications[index];

            return GestureDetector(
              onTap: () {
                if (curNotification.isRead ?? true) return;
                onTap.call(curNotification.id);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: Sizes.s6),
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.s10,
                  horizontal: PaddingValues.padding.h,
                ),
                color:
                    !(curNotification.isRead ?? true) ? AppColors.primaryColor.withOpacity(0.07) : Colors.transparent,
                child: Row(
                  children: [
                    ImageView(
                      imageUrl: curNotification.fileFullUrl,
                      height: Sizes.s80,
                      width: Sizes.s80,
                      radius: BorderRadius.circular(Sizes.s10.sp),
                    ),
                    SizedBoxW10(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            curNotification.title ?? 'N/A',
                            style: TextStyle(
                              fontSize: Sizes.s14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            curNotification.content ?? 'N/A',
                            style: TextStyle(
                              fontSize: Sizes.s12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBoxH10(),
                          Text(
                            curNotification.formatTimePassed,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
