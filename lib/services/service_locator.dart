import 'package:get_it/get_it.dart';
import 'package:renmoney_test/services/location_service.dart';
import 'package:renmoney_test/services/weather_service.dart';

import 'network_service.dart';

GetIt get serviceLocator => GetIt.instance;

Future<void> setupLocator({
  String? environment,
}) async {

// Register dependencies
  serviceLocator.registerLazySingleton(() => WeatherService());
  serviceLocator.registerLazySingleton(() => NetworkService());
  serviceLocator.registerLazySingleton(() => LocationService());
}