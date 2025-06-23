import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_tracking/core/api_services/api_services.dart';
import 'package:live_tracking/feature/live_tracking/domain/repos/map_repo.dart';
import 'package:uuid/uuid.dart';

class MapRepoImp extends MapRepo {
  final ApiServices apiServices ;
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  MapRepoImp(this.apiServices);

  @override
  Future<List<Map<String, dynamic>>> getPredictions(String place) async{
    String sessionToken = Uuid().v4();
    var res = await apiServices.getData(
      path: 'place/autocomplete/json',
      query: {
        "input" : place,
        "components" : "country:eg",
        "type" : "address",
        "sessiontoken" : sessionToken,
        "key" : apiKey,
      },
    );
    return res['predictions'].cast<Map<String,dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async{
    var res = await apiServices.getData(
        path: 'place/details/json',
        query: {
          "place_id" : placeId,
          "key" : apiKey,
        },
    );
    return res['result'];
  }

  @override
  Future<Map<String, dynamic>> getDirections({
    required String origin,
    required String destination,
  }) async{
    var res = await apiServices.getData(
        path: 'directions/json',
        query: {
          "destination" : destination,
          "origin" : origin
        },
    );
    return res['routes'][0];
  }


}
