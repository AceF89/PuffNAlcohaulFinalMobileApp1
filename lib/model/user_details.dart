import 'package:intl/intl.dart';

class UserDetails {
  final num? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final num? roleId;
  final num? storeId;
  final num? teamId;
  final num? profilePicId;
  final String? phoneNumber;
  final String? address;
  final num? lat;
  final num? long;
  final bool? isActive;
  final String? gender;
  final num? otp;
  final DateTime? lastLoginDate;
  final DateTime? addedOn;
  final num? addedBy;
  final DateTime? modifiedOn;
  final DateTime? lastSeen;
  final num? modifiedBy;
  final dynamic dob;
  final String? lastLoginDateValue;
  final bool? isProfileCompleted;
  final String? fullName;
  final String? storeName;
  final String? roleName;
  final bool? isAdmin;
  final bool? isUser;
  final bool? isCustomer;
  final bool? isDriver;
  final String? token;
  final String? fileUrl;
  final String? fullFileUrl;
  final String? updatedBy;
  final String? fullLicenseFileUrl;
  final num? age;
  final num? countryId;
  final num? stateId;
  final num? cityId;
  final num? earnedloyaltyPoint;
  final num? redeemedloyaltyPoint;
  final num? balanceloyaltyPoint;
  final String? zipCode;
  final String? rcUserId;
  final String? rcPassword;
  final String? chatToken;
  final String? rcUserName;
  final String? cityName;
  final num? frontLicenseFileId;
  final String? frontLicenseFileUrl;
  final String? fullFrontLicenseFileUrl;
  final num? backLicenseFileId;
  final String? backLicenseFileUrl;
  final String? fullBackLicenseFileUrl;
  final String? googleAddress;

  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.roleId,
    this.storeId,
    this.teamId,
    this.profilePicId,
    this.phoneNumber,
    this.address,
    this.lat,
    this.long,
    this.isActive,
    this.gender,
    this.otp,
    this.lastLoginDate,
    this.addedOn,
    this.addedBy,
    this.modifiedOn,
    this.lastSeen,
    this.modifiedBy,
    this.dob,
    this.lastLoginDateValue,
    this.isProfileCompleted,
    this.fullName,
    this.storeName,
    this.roleName,
    this.isAdmin,
    this.isUser,
    this.isCustomer,
    this.isDriver,
    this.token,
    this.fileUrl,
    this.fullFileUrl,
    this.updatedBy,
    this.age,
    this.countryId,
    this.stateId,
    this.cityId,
    this.earnedloyaltyPoint,
    this.redeemedloyaltyPoint,
    this.balanceloyaltyPoint,
    this.fullLicenseFileUrl,
    this.zipCode,
    this.rcUserId,
    this.rcPassword,
    this.chatToken,
    this.rcUserName,
    this.cityName,
    this.frontLicenseFileId,
    this.frontLicenseFileUrl,
    this.fullFrontLicenseFileUrl,
    this.backLicenseFileId,
    this.backLicenseFileUrl,
    this.fullBackLicenseFileUrl,
    this.googleAddress,
  });

  String? get joinedDate {
    if (addedOn == null) return '';
    return DateFormat('MMMM dd, yyyy').format(addedOn!);
  }

  // String? get frontDLUrl {
  //   if (fullLicenseFileUrl == null) return null;
  //   if (fullLicenseFileUrl!.isEmpty) return null;
  //   final urls = fullLicenseFileUrl!.split(',');
  //   return urls[0];
  // }

  // String? get backDLUrl {
  //   if (fullLicenseFileUrl == null) return null;
  //   if (fullLicenseFileUrl!.isEmpty) return null;
  //   final urls = fullLicenseFileUrl!.split(',');
  //   return urls.length > 1 ? urls[1] : null;
  // }

  UserDetails copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    num? roleId,
    num? storeId,
    num? teamId,
    num? profilePicId,
    String? phoneNumber,
    String? address,
    num? lat,
    num? long,
    bool? isActive,
    String? gender,
    num? otp,
    DateTime? lastLoginDate,
    DateTime? addedOn,
    num? addedBy,
    DateTime? modifiedOn,
    DateTime? lastSeen,
    num? modifiedBy,
    dynamic dob,
    String? licenseFileIds,
    num? licenseFileId,
    String? lastLoginDateValue,
    bool? isProfileCompleted,
    String? fullName,
    String? storeName,
    String? roleName,
    bool? isAdmin,
    bool? isUser,
    bool? isCustomer,
    bool? isDriver,
    String? token,
    String? fileUrl,
    String? fullFileUrl,
    String? updatedBy,
    String? fullLicenseFileUrl,
    num? age,
    num? countryId,
    num? stateId,
    num? cityId,
    num? earnedloyaltyPoint,
    num? redeemedloyaltyPoint,
    num? balanceloyaltyPoint,
    String? zipCode,
    String? rcUserId,
    String? rcPassword,
    String? chatToken,
    String? rcUserName,
    String? cityName,
    num? frontLicenseFileId,
    String? frontLicenseFileUrl,
    String? fullFrontLicenseFileUrl,
    num? backLicenseFileId,
    String? backLicenseFileUrl,
    String? fullBackLicenseFileUrl,
    String? googleAddress,
  }) {
    return UserDetails(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
      storeId: storeId ?? this.storeId,
      teamId: teamId ?? this.teamId,
      profilePicId: profilePicId ?? this.profilePicId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      isActive: isActive ?? this.isActive,
      gender: gender ?? this.gender,
      otp: otp ?? this.otp,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      addedOn: addedOn ?? this.addedOn,
      addedBy: addedBy ?? this.addedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      lastSeen: lastSeen ?? this.lastSeen,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      dob: dob ?? this.dob,
      lastLoginDateValue: lastLoginDateValue ?? this.lastLoginDateValue,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      fullName: fullName ?? this.fullName,
      storeName: storeName ?? this.storeName,
      roleName: roleName ?? this.roleName,
      isAdmin: isAdmin ?? this.isAdmin,
      isUser: isUser ?? this.isUser,
      isCustomer: isCustomer ?? this.isCustomer,
      isDriver: isDriver ?? this.isDriver,
      token: token ?? this.token,
      fileUrl: fileUrl ?? this.fileUrl,
      fullFileUrl: fullFileUrl ?? this.fullFileUrl,
      updatedBy: updatedBy ?? this.updatedBy,
      age: age ?? this.age,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      earnedloyaltyPoint: earnedloyaltyPoint ?? this.earnedloyaltyPoint,
      redeemedloyaltyPoint: redeemedloyaltyPoint ?? this.redeemedloyaltyPoint,
      balanceloyaltyPoint: balanceloyaltyPoint ?? this.balanceloyaltyPoint,
      fullLicenseFileUrl: fullLicenseFileUrl ?? this.fullLicenseFileUrl,
      zipCode: zipCode ?? this.zipCode,
      rcUserId: rcUserId ?? this.rcUserId,
      rcPassword: rcPassword ?? this.rcPassword,
      chatToken: chatToken ?? this.chatToken,
      rcUserName: rcUserName ?? this.rcUserName,
      cityName: cityName ?? this.cityName,
      frontLicenseFileId: frontLicenseFileId ?? this.frontLicenseFileId,
      frontLicenseFileUrl: frontLicenseFileUrl ?? this.frontLicenseFileUrl,
      fullFrontLicenseFileUrl: fullFrontLicenseFileUrl ?? this.fullFrontLicenseFileUrl,
      backLicenseFileId: backLicenseFileId ?? this.backLicenseFileId,
      backLicenseFileUrl: backLicenseFileUrl ?? this.backLicenseFileUrl,
      fullBackLicenseFileUrl: fullBackLicenseFileUrl ?? this.fullBackLicenseFileUrl,
      googleAddress: googleAddress ?? this.googleAddress,
    );
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      roleId: json['roleId'],
      storeId: json['storeId'],
      teamId: json['teamId'],
      profilePicId: json['profilePicId'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      isActive: json['isActive'],
      gender: json['gender'],
      otp: json['otp'],
      lastLoginDate: json['lastLoginDate'] == null ? null : DateTime.parse(json['lastLoginDate']),
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      addedBy: json['addedBy'],
      modifiedOn: json['modifiedOn'] == null ? null : DateTime.parse(json['modifiedOn']),
      lastSeen: json['lastSeen'] == null ? null : DateTime.parse(json['lastSeen']),
      modifiedBy: json['modifiedBy'],
      dob: json['dob'],
      lastLoginDateValue: json['lastLoginDateValue'],
      isProfileCompleted: json['isProfileCompleted'],
      fullName: json['fullName'],
      storeName: json['storeName'],
      roleName: json['roleName'],
      isAdmin: json['isAdmin'],
      isUser: json['isUser'],
      isCustomer: json['isCustomer'],
      isDriver: json['isDriver'],
      token: json['token'],
      fileUrl: json['fileUrl'],
      fullFileUrl: json['fullFileUrl'],
      updatedBy: json['updatedBy'],
      age: json['age'],
      countryId: json['countryId'],
      stateId: json['stateId'],
      cityId: json['cityId'],
      earnedloyaltyPoint: json['earnedloyaltyPoint'],
      redeemedloyaltyPoint: json['redeemedloyaltyPoint'],
      balanceloyaltyPoint: json['balanceloyaltyPoint'],
      fullLicenseFileUrl: json['fullLicenseFileUrl'],
      zipCode: json['zipCode'],
      rcUserId: json['rcUserId'],
      rcPassword: json['rcPassword'],
      chatToken: json['chatToken'],
      rcUserName: json['rcUserName'],
      cityName: json['cityName'],
      frontLicenseFileId: json['frontLicenseFileId'],
      frontLicenseFileUrl: json['frontLicenseFileUrl'],
      fullFrontLicenseFileUrl: json['fullFrontLicenseFileUrl'],
      backLicenseFileId: json['backLicenseFileId'],
      backLicenseFileUrl: json['backLicenseFileUrl'],
      fullBackLicenseFileUrl: json['fullBackLicenseFileUrl'],
      googleAddress: json['googleAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'roleId': roleId,
      'storeId': storeId,
      'teamId': teamId,
      'profilePicId': profilePicId,
      'phoneNumber': phoneNumber,
      'zipCode': zipCode,
      'address': address,
      'lat': lat,
      'long': long,
      'isActive': isActive,
      'gender': gender,
      'otp': otp,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'dob': dob,
      'lastLoginDateValue': lastLoginDateValue,
      'isProfileCompleted': isProfileCompleted,
      'fullName': fullName,
      'storeName': storeName,
      'roleName': roleName,
      'isAdmin': isAdmin,
      'isUser': isUser,
      'isCustomer': isCustomer,
      'isDriver': isDriver,
      'token': token,
      'fileUrl': fileUrl,
      'fullFileUrl': fullFileUrl,
      'updatedBy': updatedBy,
      'age': age,
      'countryId': countryId,
      'stateId': stateId,
      'cityId': cityId,
      'earnedloyaltyPoint': earnedloyaltyPoint,
      'redeemedloyaltyPoint': redeemedloyaltyPoint,
      'balanceloyaltyPoint': balanceloyaltyPoint,
      'fullLicenseFileUrl': fullLicenseFileUrl,
      'rcUserId': rcUserId,
      'rcPassword': rcPassword,
      'chatToken': chatToken,
      'rcUserName': rcUserName,
      'cityName': cityName,
      'frontLicenseFileId': frontLicenseFileId,
      'frontLicenseFileUrl': frontLicenseFileUrl,
      'fullFrontLicenseFileUrl': fullFrontLicenseFileUrl,
      'backLicenseFileId': backLicenseFileId,
      'backLicenseFileUrl': backLicenseFileUrl,
      'fullBackLicenseFileUrl': fullBackLicenseFileUrl,
      'googleAddress': googleAddress,
    };
  }

  Map<String, dynamic> toUpdateDrivingLJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'roleId': roleId,
      'storeId': storeId,
      'profilePicId': profilePicId,
      'phoneNumber': phoneNumber,
      'address': address,
      'lat': lat,
      'long': long,
      'isActive': isActive,
      'gender': gender,
      'otp': otp,
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'dob': dob,
      'lastLoginDateValue': lastLoginDateValue,
      'isProfileCompleted': isProfileCompleted,
      'fullName': fullName,
      'cityName': cityName,
      'frontLicenseFileId': frontLicenseFileId,
      'backLicenseFileId': backLicenseFileId,
      'googleAddress': googleAddress,
    };
  }
}
