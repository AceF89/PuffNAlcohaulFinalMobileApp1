import 'package:alcoholdeliver/model/city_state_info.dart';
import 'package:alcoholdeliver/model/places.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'place_api_impl.dart';

abstract class PlaceApi {
  static final PlaceApi _instance = _PlaceApiImpl();

  static PlaceApi get instance => _instance;

  Future<Result<List<Places>, String>> getCountries();

  Future<Result<List<Places>, String>> getStates(int countryId);

  Future<Result<List<Places>, String>> getCity(int stateId);

  Future<Result<CityStateInfo, String>> getCityStateByZipcode(String zipcode);
}
