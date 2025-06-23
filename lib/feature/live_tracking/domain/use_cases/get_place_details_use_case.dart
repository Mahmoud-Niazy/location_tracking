import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/feature/live_tracking/domain/repos/map_repo.dart';

class GetPlaceDetailsUseCase {
  final MapRepo mapRepo;
  GetPlaceDetailsUseCase(this.mapRepo);

  Future<LatLng> execute(String placeId)async{
    var res = await mapRepo.getPlaceDetails(placeId);
    var location = res['geometry']['location'];
    LatLng placeLocation = LatLng(location['lat'], location['lng']);
    return placeLocation;
  }
}