part of 'user_api.dart';

abstract class UserApiService extends ClientService implements UserApi {}

class _UserApiImpl extends UserApiService {
  @override
  Future<Result<UserDetails, String>> getMe() async {
    var result = await request(requestType: RequestType.post, path: '/User/Me');

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(UserDetails.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<UserDetails, String>> updateMe({
    required num? id,
    required num? roleId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    num? frontLicenseFileId,
    num? backLicenseFileId,
    num? profilePicId,
    required num? cityId,
  }) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/User/Save',
      data: {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'roleId': roleId,
        'profilePicId': profilePicId,
        'cityId': cityId,
        'frontLicenseFileId': frontLicenseFileId,
        'backLicenseFileId': backLicenseFileId,
      },
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(UserDetails.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> deleteMe() async {
    final user = preferences.getUserProfile();
    if (user == null) return Failure('Cannot find User');

    var result = await request(
      requestType: RequestType.delete,
      path: '/User/Delete?id=${user.id}',
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

  @override
  Future<Result<FileUploadResponse, String>> uploadFile(File data) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/File/Save',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(data.path),
      }),
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(FileUploadResponse.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<UserDetails, String>> saveDrivingLicence({
    required num? licenceId,
    required DrivingLicense? type,
  }) async {
    final oldProfile =
        preferences.getUserProfile()?.toUpdateDrivingLJson() ?? {};
    if (type == DrivingLicense.front)
      oldProfile['frontLicenseFileId'] = licenceId;
    if (type == DrivingLicense.back)
      oldProfile['backLicenseFileId'] = licenceId;
    oldProfile.remove('address');

    var result = await request(
      requestType: RequestType.post,
      path: '/User/Save',
      data: oldProfile,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(UserDetails.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> setPlayerId({required String id}) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/User/SetPlayerId?playerId=$id',
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

  @override
  Future<Result<String, String>> contactUs(
      {required String message, String? productName}) async {
    String url = '/User/ContactUs?ContactMessage=$message';
    if (productName != null) url += '&productName=$productName';

    var result = await request(
      requestType: RequestType.post,
      path: url,
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

  @override
  Future<Result<String, String>> addNewAddress(
      {required UserAddress address}) async {
    String url = '/User/SaveUserAddress';

    var result = await request(
      requestType: RequestType.post,
      path: url,
      data: address.toSaveJson(),
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

  @override
  Future<Result<List<UserAddress>, String>> getAllAddress(
      {bool? defaultAddress}) async {
    String url = '/User/GetUserAddress';
    if (defaultAddress == true) url += '?defaultAddress=true';

    var result = await request(
      requestType: RequestType.get,
      path: url,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<UserAddress> address = [];
          address = List<UserAddress>.from(
            response['data'].map((e) => UserAddress.fromJson(e)),
          );

          return Success(address);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> deleteSavedAddress({required num id}) async {
    String url = '/User/DeleteUserAddress?id=$id';

    var result = await request(
      requestType: RequestType.delete,
      path: url,
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
