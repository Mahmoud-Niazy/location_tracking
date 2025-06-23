import 'package:get_it/get_it.dart';
import 'package:live_tracking/feature/live_tracking/data/repos/map_repo_imp.dart';
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


    /// CUBIT

  }
}