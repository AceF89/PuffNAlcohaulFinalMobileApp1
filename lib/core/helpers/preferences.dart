import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alcoholdeliver/model/user_details.dart';

class Preferences {
  Preferences._();

  static SharedPreferences? shared;

  static final Preferences _instance = Preferences._();

  final String _userProfile = 'user_profile';

  static Future<void> init() async {
    shared = await SharedPreferences.getInstance();
  }

  set userProfile(UserDetails value) {
    shared?.setString(_userProfile, jsonEncode(value.toJson()));
  }

  UserDetails? getUserProfile() {
    var userProfileString = shared?.getString(_userProfile);
    if (userProfileString == null) return null;
    return UserDetails.fromJson(jsonDecode(userProfileString));
  }

  bool get isUser {
    return _instance.getUserProfile()?.isUser ?? false;
  }

  bool get isDriver {
    return _instance.getUserProfile()?.isDriver ?? false;
  }

  bool get isLoggedIn {
    final userData = getUserProfile();
    if (userData == null) return false;
    if (userData.token == null) return false;
    if (userData.token?.isEmpty ?? true) return false;
    return true;
  }

  Future<void> logoutUser() async {
    await shared?.remove(_userProfile);
  }

  Future<void> clear() async {
    await shared?.remove(_userProfile);
  }

  static Preferences get instance => _instance;
}
