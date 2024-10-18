class Store {
  final num? id;
  final String? name;
  final String? address;
  final num? cityId;
  final String? email;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? posapikey;
  final DateTime? addedOn;
  final num? addedBy;
  final DateTime? modifiedOn;
  final num? modifiedBy;
  final num? distanceValue;

  Store({
    this.id,
    this.name,
    this.address,
    this.cityId,
    this.email,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.posapikey,
    this.addedOn,
    this.addedBy,
    this.modifiedOn,
    this.modifiedBy,
    this.distanceValue,
  });

  Store copyWith({
    num? id,
    String? name,
    String? address,
    num? cityId,
    String? email,
    String? phoneNumber,
    double? latitude,
    double? longitude,
    String? posapikey,
    DateTime? addedOn,
    num? addedBy,
    DateTime? modifiedOn,
    num? modifiedBy,
    num? distanceValue,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      cityId: cityId ?? this.cityId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      posapikey: posapikey ?? this.posapikey,
      addedOn: addedOn ?? this.addedOn,
      addedBy: addedBy ?? this.addedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      distanceValue: distanceValue ?? this.distanceValue,
    );
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      cityId: json['cityId'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      posapikey: json['posapikey'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      addedBy: json['addedBy'],
      modifiedOn: json['modifiedOn'] == null ? null : DateTime.parse(json['modifiedOn']),
      modifiedBy: json['modifiedBy'],
      distanceValue: json['distanceValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'cityId': cityId,
      'email': email,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'posapikey': posapikey,
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'distanceValue': distanceValue,
    };
  }
}
