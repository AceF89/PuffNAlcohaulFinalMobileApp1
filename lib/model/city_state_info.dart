class CityStateInfo {
  final City? state;
  final City? city;

  CityStateInfo({
    this.state,
    this.city,
  });

  CityStateInfo copyWith({
    City? state,
    City? city,
  }) {
    return CityStateInfo(
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }

  factory CityStateInfo.fromJson(Map<String, dynamic> json) {
    return CityStateInfo(
      state: json['state'] == null ? null : City.fromJson(json['state']),
      city: json['city'] == null ? null : City.fromJson(json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state?.toJson(),
      'city': city?.toJson(),
    };
  }
}

class City {
  final num? id;
  final String? name;
  final num? stateId;
  final bool? isActive;
  final num? countryId;

  City({
    this.id,
    this.name,
    this.stateId,
    this.isActive,
    this.countryId,
  });

  City copyWith({
    num? id,
    String? name,
    num? stateId,
    bool? isActive,
    num? countryId,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
      isActive: isActive ?? this.isActive,
      countryId: countryId ?? this.countryId,
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      stateId: json['stateId'],
      isActive: json['isActive'],
      countryId: json['countryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stateId': stateId,
      'isActive': isActive,
      'countryId': countryId,
    };
  }
}
