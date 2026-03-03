import 'package:get_it/get_it.dart';
import 'core/config/env_config.dart';
import 'core/socket/socket_service.dart';
import 'core/location/location_service.dart';
import 'data/datasources/remote_datasource.dart';
import 'data/repositories/ride_repository_impl.dart';
import 'domain/repositories/i_repositories.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => EnvConfig.development);
  sl.registerLazySingleton<ISocketService>(() => SocketService(sl()));
  sl.registerLazySingleton(() => LocationService(sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<IRideRepository>(() => RideRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  // sl.registerLazySingleton(() => MatchingEngine(sl(), sl()));
}
