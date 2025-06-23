import 'package:live_tracking/feature/live_tracking/data/models/direction_model.dart';
import 'package:live_tracking/feature/live_tracking/domain/repos/map_repo.dart';

class GetDirectionsUseCase {
  final MapRepo mapRepo;
  GetDirectionsUseCase(this.mapRepo);

  Future<DirectionModel> execute({
    required String origin,
    required String destination,
  })async{
    var res = await mapRepo.getDirections(
        origin: origin, destination: destination,
    );
    DirectionModel direction = DirectionModel.fomJson(res);
    return direction;
  }
}