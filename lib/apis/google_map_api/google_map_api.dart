import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/model/distance_matrix_res.dart';
import 'package:alcoholdeliver/model/google/g_address_component.dart';
import 'package:alcoholdeliver/model/google/g_place_details.dart';
import 'package:alcoholdeliver/model/google/g_places.dart';
import 'package:alcoholdeliver/model/google/google_direction.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'google_map_api_impl.dart';

abstract class GoogleMapApi {
  static final GoogleMapApi _instance = _GoogleMapApiImpl();

  static GoogleMapApi get instance => _instance;

  Future<Result<GoogleDirection, String>> getDirection({required LatLng? origin, required LatLng? destination});

  Future<Result<DistanceMatrixRes, String>> getEstimatedTime({required LatLng? origin, required LatLng? destination});

  Future<Result<List<GPlaces>, String>> autocompletePlaces({required String input});

  Future<Result<GPlaceDetails?, String>> getPlacesDetailsByPlaceId({required String placeId});

  Future<Result<List<GAddressComponent>, String>> getPlacesDetailsByLatLng({required LatLng? position});
}
