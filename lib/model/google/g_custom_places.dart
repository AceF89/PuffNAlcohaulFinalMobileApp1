import 'package:google_maps_flutter/google_maps_flutter.dart';

class GCustomPlaces {
  final String? address;
  final String? placeId;
  final LatLng? position;

  GCustomPlaces({
    this.address,
    this.placeId,
    this.position,
  });

  GCustomPlaces copyWith({
    String? address,
    String? placeId,
    LatLng? position,
  }) {
    return GCustomPlaces(
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      position: position ?? this.position,
    );
  }

  factory GCustomPlaces.fromJson(Map<String, dynamic> json) {
    return GCustomPlaces(
      address: json['address'],
      placeId: json['place_id'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'place_id': placeId,
      'position': position,
    };
  }
}
