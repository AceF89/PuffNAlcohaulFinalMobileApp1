part of 'place_api.dart';

abstract class PlaceApiService extends ClientService implements PlaceApi {}

class _PlaceApiImpl extends PlaceApiService {
  @override
  Future<Result<List<Places>, String>> getCountries() async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Country/GetCountries',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Places> countries = [];
          countries = List<Places>.from(
            response['data']['items'].map((e) => Places.fromJson(e)),
          );

          return Success(countries);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<Places>, String>> getStates(int countryId) async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Country/GetStates?countryId=$countryId',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Places> states = [];
          states = List<Places>.from(
            response['data']['items'].map((e) => Places.fromJson(e)),
          );

          return Success(states);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<Places>, String>> getCity(int stateId) async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Country/GetCities?stateId=$stateId',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Places> cities = [];
          cities = List<Places>.from(
            response['data']['items'].map((e) => Places.fromJson(e)),
          );

          return Success(cities);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<CityStateInfo, String>> getCityStateByZipcode(String zipcode) async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Country/GetPlaceInfo?zipCode=$zipcode',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(CityStateInfo.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
