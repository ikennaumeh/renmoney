import 'package:dio/dio.dart';
import 'package:renmoney_test/models/weather.dart';
import 'package:renmoney_test/services/network_service.dart';
import 'package:renmoney_test/services/service_locator.dart';

class WeatherService {
  final _networkService = serviceLocator.get<NetworkService>();

  final String apiKey = '0d2b1f7f94d998c38451d7f4aa31d3ee';

  Future<Weather> fetchWeatherByLocation({required double lat,required double lon}) async {
    try{
      final response = await _networkService.get(
          'weather?lat=$lat&lon=$lon&appid=$apiKey'
      );
      return Weather.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}