part of 'auth_api.dart';

abstract class AuthApiService extends ClientService implements AuthApi {}

class _AuthApiImpl extends AuthApiService {
  @override
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
  }) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/User/SignUp',
      data: {
        "id": 0,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": mobile,
        // "apartment": apartment,
        "address": address,
        "address2": address2,
        "googleAddress": googleAddress,
        "cityId": cityId,
        "dob": dob.toIso8601String(),
        "email": email,
        "password": password,
        "roleId": roleId,
        "profilePicId": 0,
        "latitude": latitude,
        "longitude": longitude,
        "storeId": storeId,
        "zipCode": zipCode,
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
  Future<Result<UserDetails, String>> userLogin(
      {required String email, required String password}) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/User/Login',
      data: {
        'email': email.trim(),
        'password': password.trim(),
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
  Future<Result<String, String>> forgotPassword({required String email}) async {
    var result = await request(
      requestType: RequestType.get,
      path: '/User/ForgotPassword?email=${email.trim()}',
    );

    return result.when(
      (response) {
        return response['statusCode'] == 200
            ? Success(response['message'])
            : Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> verifyOTPChangePassword({
    String? email,
    String? code,
    required String newPassword,
  }) async {
    String endpoint = '/User/ChangePassword';
    if (email != null && code != null) {
      endpoint +=
          '?email=${email.trim()}&otp=${code.trim()}&newPassword=${newPassword.trim()}';
    } else {
      endpoint += '?newPassword=${newPassword.trim()}';
    }

    var result = await request(requestType: RequestType.get, path: endpoint);

    return result.when(
      (response) {
        return response['statusCode'] == 200
            ? Success(response['message'])
            : Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
