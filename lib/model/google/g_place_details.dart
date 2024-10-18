import 'package:google_maps_flutter/google_maps_flutter.dart';

class GPlaceDetails {
  final List<AddressComponent>? addressComponents;
  final String? adrAddress;
  final String? formattedAddress;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final String? placeId;
  final PlusCode? plusCode;
  final String? reference;
  final List<String>? types;
  final String? url;
  final int? utcOffset;
  final String? vicinity;

  GPlaceDetails({
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.placeId,
    this.plusCode,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
    this.vicinity,
  });

  LatLng get latLng => LatLng(geometry?.location?.lat ?? 0, geometry?.location?.lng ?? 0);

  String? get postalCode {
    if (addressComponents == null) return null;
    if (addressComponents!.isEmpty) return null;
    return addressComponents?.firstWhere((component) => (component.types?.contains('postal_code') ?? false)).longName;
  }

  String? get city {
    if (addressComponents == null) return null;
    if (addressComponents!.isEmpty) return null;
    return addressComponents?.firstWhere((component) => (component.types?.contains('locality') ?? false)).longName;
  }

  String? get country {
    if (addressComponents == null) return null;
    if (addressComponents!.isEmpty) return null;
    return addressComponents?.firstWhere((component) => (component.types?.contains('country') ?? false)).longName;
  }

  GPlaceDetails copyWith({
    List<AddressComponent>? addressComponents,
    String? adrAddress,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    String? placeId,
    PlusCode? plusCode,
    String? reference,
    List<String>? types,
    String? url,
    int? utcOffset,
    String? vicinity,
  }) {
    return GPlaceDetails(
      addressComponents: addressComponents ?? this.addressComponents,
      adrAddress: adrAddress ?? this.adrAddress,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      reference: reference ?? this.reference,
      types: types ?? this.types,
      url: url ?? this.url,
      utcOffset: utcOffset ?? this.utcOffset,
      vicinity: vicinity ?? this.vicinity,
    );
  }

  factory GPlaceDetails.fromJson(Map<String, dynamic> json) {
    return GPlaceDetails(
      addressComponents: json['address_components'] == null
          ? []
          : List<AddressComponent>.from(json['address_components']!.map((x) => AddressComponent.fromJson(x))),
      adrAddress: json['adr_address'],
      formattedAddress: json['formatted_address'],
      geometry: json['geometry'] == null ? null : Geometry.fromJson(json['geometry']),
      icon: json['icon'],
      iconBackgroundColor: json['icon_background_color'],
      iconMaskBaseUri: json['icon_mask_base_uri'],
      name: json['name'],
      placeId: json['place_id'],
      plusCode: json['plus_code'] == null ? null : PlusCode.fromJson(json['plus_code']),
      reference: json['reference'],
      types: json['types'] == null ? [] : List<String>.from(json['types']!.map((x) => x)),
      url: json['url'],
      utcOffset: json['utc_offset'],
      vicinity: json['vicinity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_components':
          addressComponents == null ? [] : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
      'adr_address': adrAddress,
      'formatted_address': formattedAddress,
      'geometry': geometry?.toJson(),
      'icon': icon,
      'icon_background_color': iconBackgroundColor,
      'icon_mask_base_uri': iconMaskBaseUri,
      'name': name,
      'place_id': placeId,
      'plus_code': plusCode?.toJson(),
      'reference': reference,
      'types': types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      'url': url,
      'utc_offset': utcOffset,
      'vicinity': vicinity,
    };
  }
}

class AddressComponent {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  AddressComponent copyWith({
    String? longName,
    String? shortName,
    List<String>? types,
  }) {
    return AddressComponent(
      longName: longName ?? this.longName,
      shortName: shortName ?? this.shortName,
      types: types ?? this.types,
    );
  }

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: json['types'] == null ? [] : List<String>.from(json['types']!.map((x) => x)),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'long_name': longName,
      'short_name': shortName,
      'types': types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
  }
}

class Geometry {
  final Location? location;
  final Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) {
    return Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );
  }

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json['location'] == null ? null : Location.fromJson(json['location']),
      viewport: json['viewport'] == null ? null : Viewport.fromJson(json['viewport']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'viewport': viewport?.toJson(),
    };
  }
}

class Location {
  final double? lat;
  final double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) {
    return Location(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Viewport {
  final Location? northeast;
  final Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport copyWith({
    Location? northeast,
    Location? southwest,
  }) {
    return Viewport(
      northeast: northeast ?? this.northeast,
      southwest: southwest ?? this.southwest,
    );
  }

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: json['northeast'] == null ? null : Location.fromJson(json['northeast']),
      southwest: json['southwest'] == null ? null : Location.fromJson(json['southwest']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast?.toJson(),
      'southwest': southwest?.toJson(),
    };
  }
}

class PlusCode {
  final String? compoundCode;
  final String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  PlusCode copyWith({
    String? compoundCode,
    String? globalCode,
  }) {
    return PlusCode(
      compoundCode: compoundCode ?? this.compoundCode,
      globalCode: globalCode ?? this.globalCode,
    );
  }

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'],
      globalCode: json['global_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compound_code': compoundCode,
      'global_code': globalCode,
    };
  }
}
