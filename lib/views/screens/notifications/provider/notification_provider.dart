import 'package:alcoholdeliver/apis/notification_api/notification_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/notification.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<NotificationProvider> notificationProvider =
    ChangeNotifierProvider.autoDispose((ref) => NotificationProvider());

class NotificationProvider extends DefaultChangeNotifier {
  final NotificationApi _api = NotificationApi.instance;

  int _pageNumber = 1;
  num _totalResult = 0;
  List<NotificationRes> notification = [];
  bool loadMoreLoading = false;

  NotificationProvider();

  set setLoadMoreLoading(bool value) {
    loadMoreLoading = value;
    notify();
  }

  void setNotificationAsRead(num id) {
    final index = notification.indexWhere((e) => e.id == id);
    if (index == -1) return;

    notification[index] = notification[index].copyWith(isRead: true);
    notify();
  }

  void setAllNotificationAsRead() {
    final updatedNotification = notification.map((e) => e.copyWith(isRead: true)).toList();
    notification = updatedNotification;
    notify();
  }

  Future<void> loadMoreNotification() async {
    if (_totalResult != notification.length) {
      var result = await getAllNotification(
        isLoadMore: true,
      );
      if (result.isNotEmpty) {
        notification.addAll(result);
        notify();
      }
    }
  }

  Future<List<NotificationRes>> getAllNotification({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        _pageNumber++;
        setLoadMoreLoading = true;
      } else {
        loading = true;
      }

      var result = await _api.getAllNotification(page: _pageNumber);

      return result.when(
        (value) async {
          _totalResult = value.totalData;
          if (!isLoadMore) notification = value.data ?? [];
          return value.data ?? [];
        },
        (error) {
          notification = [];
          return [];
        },
      );
    } finally {
      isLoadMore ? setLoadMoreLoading = false : loading = false;
    }
  }

  Future<void> markAllNotificationAsRead(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.markNotificationAsRead(id: 0);

      return result.when(
        (value) async {
          setAllNotificationAsRead();
          Loader.dismiss(context);
          context.showSuccessSnackBar('All Notifications Mark as Read Successfully');
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> markNotificationAsRead(BuildContext context, num id) async {
    if (await ConnectivityService.isConnected) {
      setNotificationAsRead(id);

      var result = await _api.markNotificationAsRead(id: id);

      return result.when(
        (value) {},
        (error) => context.showFailureSnackBar(error),
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
