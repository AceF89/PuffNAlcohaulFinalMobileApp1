part of 'google_map_api.dart';

abstract class GoogleMapApiService extends ClientService implements GoogleMapApi {}

class _GoogleMapApiImpl extends GoogleMapApiService {
  @override
  Future<Result<GoogleDirection, String>> getDirection({required LatLng? origin, required LatLng? destination}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

    var result = await getRequest(
        url:
            '$baseUrl?origin=${origin?.latitude},${origin?.longitude}&destination=${destination?.latitude},${destination?.longitude}&key=${EnvValues.gMapKey}');

    return result.when(
      (data) {
        if (data["status"] == "ZERO_RESULTS") return Failure('Couldn\'t find waypoints');

        final Map<String, dynamic> northEastBound = data['routes'][0]['bounds']['northeast'];
        final Map<String, dynamic> southWestBound = data['routes'][0]['bounds']['southwest'];
        final Map<String, dynamic> startLocation = data['routes'][0]['legs'][0]['start_location'];
        final Map<String, dynamic> endLocation = data['routes'][0]['legs'][0]['end_location'];

        GoogleDirection direction = GoogleDirection(
          boundNE: LatLng(northEastBound['lat'], northEastBound['lng']),
          boundSW: LatLng(southWestBound['lat'], southWestBound['lng']),
          startLocation: LatLng(startLocation['lat'] as double, startLocation['lng'] as double),
          endLocation: LatLng(endLocation['lat'] as double, endLocation['lng'] as double),
          polylines: data['routes'][0]['overview_polyline']['points'],
          decodedPolylies: PolylinePoints().decodePolyline(data['routes'][0]['overview_polyline']['points']),
        );

        return Success(direction);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<GPlaces>, String>> autocompletePlaces({required String input}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    baseUrl += '?input=$input&key=${EnvValues.gMapKey}&sessiontoken=${randomId()}';

    var result = await urlRequest(
      requestType: RequestType.get,
      url: baseUrl,
    );

    return result.when(
      (data) {
        if (data['status'] == 'OK') {
          List<GPlaces> places = [];
          places = List<GPlaces>.from(
            data['predictions'].map((e) => GPlaces.fromJson(e)),
          );

          return Success(places);
        }

        return Failure('Unknow Places');
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<GPlaceDetails?, String>> getPlacesDetailsByPlaceId({required String placeId}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    baseUrl += '?place_id=$placeId&key=${EnvValues.gMapKey}';

    var result = await urlRequest(
      requestType: RequestType.get,
      url: baseUrl,
    );

    return result.when(
      (data) {
        if (data['status'] == 'OK') {
          final rawInfo = data['result'];
          return Success(GPlaceDetails.fromJson(rawInfo));
        }

        return Failure('Unknow Places');
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<DistanceMatrixRes, String>> getEstimatedTime(
      {required LatLng? origin, required LatLng? destination}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/distancematrix/json';
    baseUrl +=
        '?origins=${origin?.latitude},${origin?.longitude}&destinations=${destination?.latitude},${destination?.longitude}&key=${EnvValues.gMapKey}';

    var result = await urlRequest(
      requestType: RequestType.get,
      url: baseUrl,
    );

    return result.when(
      (data) {
        if (data['status'] == 'OK') {
          return Success(DistanceMatrixRes.fromJson(data));
        }

        return Failure('Unknow Distance');
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<GAddressComponent>, String>> getPlacesDetailsByLatLng({required LatLng? position}) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    baseUrl += '?latlng=${position?.latitude},${position?.longitude}&key=${EnvValues.gMapKey}';

    var result = await urlRequest(
      requestType: RequestType.get,
      url: baseUrl,
    );

    return result.when(
      (data) {
        if (data['status'] == 'OK') {
          List<GAddressComponent> address = [];
          address = List<GAddressComponent>.from(
            data['results'].map((e) => GAddressComponent.fromJson(e)),
          );

          return Success(address);
        }

        return Failure('Unknow Place');
      },
      (error) => Failure(error),
    );
  }
}
