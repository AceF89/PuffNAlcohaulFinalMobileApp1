import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleDirection {
  final LatLng boundNE;
  final LatLng boundSW;
  final LatLng startLocation;
  final LatLng endLocation;
  final String polylines;
  final List<PointLatLng> decodedPolylies;

  GoogleDirection({
    required this.boundNE,
    required this.boundSW,
    required this.startLocation,
    required this.endLocation,
    required this.polylines,
    required this.decodedPolylies,
  });
}
