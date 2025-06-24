import 'package:get_it/get_it.dart';
import 'package:live_tracking/feature/live_tracking/data/repos/map_repo_imp.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_directions_use_case.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_place_details_use_case.dart';
import 'package:live_tracking/feature/live_tracking/domain/use_cases/get_predictions_use_case.dart';
import 'package:live_tracking/feature/live_tracking/presentation/manager/map_cubit/map_cubit.dart';
import '../../feature/live_tracking/domain/repos/map_repo.dart';
import '../api_services/api_services.dart';

final serviceLocator = GetIt.instance;

class ServiceLocator {
  static void init(){

    ///API SERVICE
    serviceLocator.registerLazySingleton<ApiServices>(
          () => ApiServices(),
    );


    /// REPOS
    serviceLocator.registerLazySingleton<MapRepo>(
          () => MapRepoImp(serviceLocator()),
    );


    /// USE CASES
    serviceLocator.registerLazySingleton<GetPredictionsUseCase>(
          () => GetPredictionsUseCase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetPlaceDetailsUseCase>(
          () => GetPlaceDetailsUseCase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetDirectionsUseCase>(
          () => GetDirectionsUseCase(serviceLocator()),
    );

    /// CUBIT
    serviceLocator.registerLazySingleton<MapCubit>(
          () => MapCubit(serviceLocator(),serviceLocator(),serviceLocator()),
    );

  }
}