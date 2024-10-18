import 'package:alcoholdeliver/model/notification.dart';
import 'package:alcoholdeliver/model/pagination_response.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'notification_api_impl.dart';

abstract class NotificationApi {
  static final NotificationApi _instance = _NotificationApiImpl();

  static NotificationApi get instance => _instance;

  Future<Result<Pagination<List<NotificationRes>>, String>> getAllNotification({required int page});

  Future<Result<String, String>> markNotificationAsRead({required num id});
}
