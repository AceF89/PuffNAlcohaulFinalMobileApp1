import 'dart:io';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/core/utils/file_utils.dart';
import 'package:alcoholdeliver/model/file_upload_response.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/dialog/upload_file_dialog.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<EditProfileProvider> editProfileProvider =
    ChangeNotifierProvider((ref) => EditProfileProvider());

class EditProfileProvider extends DefaultChangeNotifier {
  UserDetails? oldUser;
  final UserApi _api = UserApi.instance;

  File? selectedUserProfile;
  File? selectedBackDrivingLicense;
  File? selectedFrontDrivingLicense;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();

  EditProfileProvider();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    email.dispose();
    super.dispose();
  }

  String? get frontDLUrl => oldUser?.fullFrontLicenseFileUrl;

  String? get backDLUrl => oldUser?.fullBackLicenseFileUrl;

  void clear() {
    oldUser = null;
    selectedUserProfile = null;
    email.clear();
    firstName.clear();
    lastName.clear();
    phoneNumber.clear();
    selectedBackDrivingLicense = null;
    selectedFrontDrivingLicense = null;
    notify();
  }

  void setOldUserDetails(UserDetails? user) {
    if (user == null) return;

    oldUser = user;

    firstName.text = user.firstName ?? '';
    lastName.text = user.lastName ?? '';
    phoneNumber.text = user.phoneNumber ?? '';
    email.text = user.email ?? '';

    notify();
  }

  bool get isFieldChanged {
    if (selectedUserProfile != null) return true;
    if (selectedBackDrivingLicense != null) return true;
    if (selectedFrontDrivingLicense != null) return true;
    if (oldUser?.firstName?.trim() != firstName.text.trim()) return true;
    if (oldUser?.lastName?.trim() != lastName.text.trim()) return true;
    if (oldUser?.email?.trim() != email.text.trim()) return true;
    if (oldUser?.phoneNumber?.trim() != phoneNumber.text.trim()) return true;
    return false;
  }

  Future<void> onSelectImage(BuildContext context, String type) async {
    var file = await UploadFileDialog.show(context, useGallery: Platform.isIOS);
    if (file == null) return;

    if (file.size <= kMaximumFileSize) {
      if (type == 'PROFILE_PIC') selectedUserProfile = file;
      if (type == 'FRONT_DL') selectedFrontDrivingLicense = file;
      if (type == 'BACK_DL') selectedBackDrivingLicense = file;

      notify();
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar('You can upload maximum file size upto $kMaximumFileSize MB');
    }
  }

  Future<FileUploadResponse?> uploadFile(BuildContext context, File? file) async {
    if (file == null) return null;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.uploadFile(file);

      return result.when(
        (value) async {
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }

  Future<UserDetails?> updateMe(BuildContext context) async {
    if (!isFieldChanged) return null;
    if (!(formKey.currentState?.validate() ?? false)) return null;

    FileUploadResponse? profilePicId;
    FileUploadResponse? frontDLId;
    FileUploadResponse? backDLId;

    if (selectedUserProfile != null) {
      profilePicId = await uploadFile(context, selectedUserProfile);
    }
    if (selectedFrontDrivingLicense != null) {
      // ignore: use_build_context_synchronously
      frontDLId = await uploadFile(context, selectedFrontDrivingLicense);
    }
    if (selectedBackDrivingLicense != null) {
      // ignore: use_build_context_synchronously
      backDLId = await uploadFile(context, selectedBackDrivingLicense);
    }

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      num frontLicenseFileId =
          selectedFrontDrivingLicense != null ? (frontDLId?.id ?? 0) : (oldUser?.frontLicenseFileId ?? 0);
      num backLicenseFileId =
          selectedBackDrivingLicense != null ? (backDLId?.id ?? 0) : (oldUser?.backLicenseFileId ?? 0);

      var result = await _api.updateMe(
        id: oldUser?.id,
        roleId: oldUser?.roleId,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicId: profilePicId?.id ?? oldUser?.profilePicId,
        cityId: oldUser?.cityId,
        frontLicenseFileId: frontLicenseFileId,
        backLicenseFileId: backLicenseFileId,
      );

      return result.when(
        (value) async {
          notify();
          context.showSuccessSnackBar('Profile updated successfully');
          Loader.dismiss(context);
          return value;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return null;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return null;
    }
  }
}
