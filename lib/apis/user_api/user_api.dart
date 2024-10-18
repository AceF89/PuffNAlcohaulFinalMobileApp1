import 'dart:io';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/utils/enums.dart';
import 'package:alcoholdeliver/model/file_upload_response.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';
import 'package:dio/dio.dart';

part 'user_api_impl.dart';

abstract class UserApi {
  static final UserApi _instance = _UserApiImpl();

  static UserApi get instance => _instance;

  Future<Result<UserDetails, String>> getMe();

  Future<Result<UserDetails, String>> updateMe({
    required num? id,
    required num? roleId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    num? frontLicenseFileId,
    num? backLicenseFileId,
    required num? profilePicId,
    required num? cityId,
  });

  Future<Result<UserDetails, String>> saveDrivingLicence({
    required num? licenceId,
    required DrivingLicense? type,
  });

  Future<Result<FileUploadResponse, String>> uploadFile(File data);

  Future<Result<String, String>> deleteMe();

  Future<Result<String, String>> setPlayerId({required String id});

  Future<Result<String, String>> contactUs(
      {required String message, String? productName});

  Future<Result<List<UserAddress>, String>> getAllAddress({bool? defaultAddress});

  Future<Result<String, String>> addNewAddress({required UserAddress address});

  Future<Result<String, String>> deleteSavedAddress({required num id});
}
