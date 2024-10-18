part of 'notification_api.dart';

abstract class NotificationApiService extends ClientService implements NotificationApi {}

class _NotificationApiImpl extends NotificationApiService {
  @override
  Future<Result<Pagination<List<NotificationRes>>, String>> getAllNotification({required int page}) async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Notifications/GetAll?pageNumber=$page&pageSize=20',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<NotificationRes> notification = [];
          notification = List<NotificationRes>.from(
            response['data']['items'].map((e) => NotificationRes.fromJson(e)),
          );

          return Success(
            Pagination.fromJson({
              'totalData': response['data']['totalItems'],
              'totalPages': response['data']['totalPages'],
              'data': notification,
            }),
          );
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> markNotificationAsRead({required num id}) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/Notifications/MarkAsRead?id=$id',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
