import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/views/screens/notifications/provider/notification_provider.dart';
import 'package:alcoholdeliver/views/screens/notifications/widgets/notification_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ListType { today, yesterday, older }

class NotificationScreens extends StatefulWidget {
  const NotificationScreens({super.key});

  @override
  State<NotificationScreens> createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  late NotificationProvider _provider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.getAllNotification();

      _scrollController.addListener(() {
        setState(() {
          if (!_provider.loadMoreLoading) {
            if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent)) {
              _provider.loadMoreNotification();
            }
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void handleOnTapNotification(num id) {
    _provider.markNotificationAsRead(context, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Notification',
        actions: [
          GestureDetector(
            onTap: () {
              _provider.markAllNotificationAsRead(context);
            },
            child: Container(
              padding: EdgeInsets.all(Sizes.s6.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(Sizes.s10.sp),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.icChecked,
                    height: Sizes.s20,
                    width: Sizes.s20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.whiteFontColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBoxW05(),
                  const Text(
                    'Mark as read',
                    style: TextStyle(
                      color: AppColors.whiteFontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBoxW20(),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          _provider = ref.watch(notificationProvider);

          return ScrollableColumn.withSafeArea(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: _provider.loading
                ? [Loader.circularProgressIndicator()]
                : _provider.notification.isEmpty
                    ? [const Center(child: NoDataAvailable())]
                    : [
                        NotificationCard(
                          notifications: _provider.notification,
                          type: ListType.today,
                          onTap: handleOnTapNotification,
                        ),
                        SizedBoxH10(),
                        NotificationCard(
                          notifications: _provider.notification,
                          type: ListType.yesterday,
                          onTap: handleOnTapNotification,
                        ),
                        SizedBoxH10(),
                        NotificationCard(
                          notifications: _provider.notification,
                          type: ListType.older,
                          onTap: handleOnTapNotification,
                        ),
                      ],
          );
        },
      ),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
