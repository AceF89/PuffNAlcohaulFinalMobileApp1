class UserAddress {
  final num? id;
  final String? name;
  final num? userId;
  final String? address;
  final String? address2;
  final num? cityId;
  final String? zipcode;
  final String? apartment;
  final String? phoneNumber;
  final DateTime? addedOn;
  final num? addedBy;
  final num? latitude;
  final num? longitude;
  final num? stateId;
  final num? countryId;
  final DateTime? modifiedOn;
  final num? modifiedBy;
  final String? countryName;
  final String? stateName;
  final String? cityName;
  final bool? isDefault;
  final String? googleAddress;

  UserAddress({
    this.id,
    this.name,
    this.userId,
    this.address,
    this.address2,
    this.stateId,
    this.countryId,
    this.cityId,
    this.zipcode,
    this.apartment,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.addedOn,
    this.addedBy,
    this.modifiedOn,
    this.modifiedBy,
    this.countryName,
    this.stateName,
    this.cityName,
    this.isDefault,
    this.googleAddress,
  });

  UserAddress copyWith({
    num? id,
    String? name,
    num? userId,
    String? address,
    String? address2,
    num? cityId,
    num? stateId,
    num? countryId,
    num? latitude,
    num? longitude,
    String? zipcode,
    String? apartment,
    String? phoneNumber,
    DateTime? addedOn,
    num? addedBy,
    DateTime? modifiedOn,
    num? modifiedBy,
    String? countryName,
    String? stateName,
    String? cityName,
    bool? isDefault,
    String? googleAddress,
  }) {
    return UserAddress(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      cityId: cityId ?? this.cityId,
      stateId: stateId ?? this.stateId,
      countryId: countryId ?? this.countryId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zipcode: zipcode ?? this.zipcode,
      apartment: apartment ?? this.apartment,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addedOn: addedOn ?? this.addedOn,
      addedBy: addedBy ?? this.addedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      countryName: countryName ?? this.countryName,
      stateName: stateName ?? this.stateName,
      cityName: cityName ?? this.cityName,
      isDefault: isDefault ?? this.isDefault,
      googleAddress: googleAddress ?? this.googleAddress,
    );
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      address: json['address'],
      address2: json['address2'],
      countryId: json['countryId'],
      stateId: json['stateId'],
      cityId: json['cityId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      zipcode: json['zipcode'],
      apartment: json['apartment'],
      phoneNumber: json['phoneNumber'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      addedBy: json['addedBy'],
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn']),
      modifiedBy: json['modifiedBy'],
      countryName: json['countryName'],
      stateName: json['stateName'],
      cityName: json['cityName'],
      isDefault: json['isDefault'],
      googleAddress: json['googleAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'address': address,
      'address2': address2,
      'cityId': cityId,
      'countryId': countryId,
      'stateId': stateId,
      'zipcode': zipcode,
      'apartment': apartment,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'countryName': countryName,
      'stateName': stateName,
      'cityName': cityName,
      'isDefault': isDefault,
      'googleAddress': googleAddress,
    };
  }

  Map<String, dynamic> toSaveJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'address': address,
      'address2': address2,
      'apartment': apartment,
      'cityId': cityId,
      'zipcode': zipcode,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
      'googleAddress': googleAddress,
    };
  }
}
