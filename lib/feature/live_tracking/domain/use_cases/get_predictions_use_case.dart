import 'package:live_tracking/feature/live_tracking/domain/repos/map_repo.dart';

import '../../data/models/prediction_model.dart';

class GetPredictionsUseCase {
  final MapRepo mapRepo;
  GetPredictionsUseCase(this.mapRepo);

  Future<List<PredictionModel>> execute(String place)async{
    var res = await mapRepo.getPredictions(place);
    List<PredictionModel> predictions = [];
    for(var prediction in res){
      predictions.add(PredictionModel.fromJson(prediction));
    }
    return predictions;
  }
}