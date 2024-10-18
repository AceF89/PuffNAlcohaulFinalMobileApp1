import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'auth_api_impl.dart';

abstract class AuthApi {
  static final AuthApi _instance = _AuthApiImpl();

  static AuthApi get instance => _instance;

  Future<Result<UserDetails, String>> userSignup({
    required String firstName,
    required String lastName,
    required String mobile,
    required String address,
    String? apartment,
    required String address2,
    required String googleAddress,
    required num cityId,
    required DateTime dob,
    required String email,
    required String password,
    required String zipCode,
    required num roleId,
    required num latitude,
    required num longitude,
    required num storeId,
  });

  Future<Result<UserDetails, String>> userLogin({
    required String email,
    required String password,
  });

  Future<Result<String, String>> forgotPassword({required String email});

  Future<Result<String, String>> verifyOTPChangePassword({
    String? email,
    String? code,
    required String newPassword,
  });
}
