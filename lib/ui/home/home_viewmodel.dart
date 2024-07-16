import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:renmoney_test/models/city.dart';
import 'package:renmoney_test/models/weather.dart';
import 'package:renmoney_test/services/location_service.dart';
import 'package:renmoney_test/services/service_locator.dart';
import 'package:renmoney_test/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier{
  final _logger = Logger("HomeViewModel");
  final _weatherService = serviceLocator.get<WeatherService>();
  final _locationService = serviceLocator.get<LocationService>();

  HomeViewModel() {
    loadCities();
  }

  List<City> _cities = [];
  List<City> _selectedCities = [];
  List<Weather> _weatherData = [];
  Weather? _currentWeatherLocation;

  bool fetchWeatherState = false;
  String? fetchWeatherError;

  List<City> get cities => _cities;
  List<City> get selectedCities => _selectedCities;
  List<Weather> get weatherData => _weatherData;
  Weather? get currentWeatherLocation => _currentWeatherLocation;

  Future<void> loadCities() async {
    final String response = await rootBundle.loadString('assets/ng.json');
    final data = await json.decode(response) as List;
    _cities = data.take(15).map((cityJson) => City.fromJson(cityJson)).toList();
    await loadSelectedCities();
  }

  Future<void> loadSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCities = prefs.getStringList('cities') ?? [];
    _selectedCities = _cities.where((city) => savedCities.contains(city.name)).toList();
    await fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    fetchWeatherState = true;
    notifyListeners();
    try{
      _weatherData = [];
      for (City city in _selectedCities) {
        Weather weather = await _weatherService.fetchWeatherByLocation(lat: city.latitude, lon: city.longitude);
        _weatherData.add(weather);
      }
      notifyListeners();
    } on DioException catch (e){
      _logger.severe(e.message);
    } catch (e) {
      _logger.severe(e.toString());
    } finally {
      fetchWeatherState = false;
      notifyListeners();
    }
  }

  Future<void> addCity(City city) async {
    if (!_selectedCities.contains(city)) {
      _selectedCities.add(city);
      await saveSelectedCities();
      fetchWeatherData();
    }
  }

  Future<void> removeCity(City city) async {
    _selectedCities.remove(city);
    await saveSelectedCities();
    fetchWeatherData();
  }

  Future<void> saveSelectedCities() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cities', _selectedCities.map((city) => city.name).toList());
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    try{
      Position position = await _locationService.getUserLocation;
      _currentWeatherLocation = await _weatherService.fetchWeatherByLocation(lat: position.latitude,lon: position.longitude);
      notifyListeners();
    } on DioException catch (e){
      _logger.severe(e.message);
      fetchWeatherError = e.message;
    } catch (e) {
      await _handleLocationPermissionException(e);
    }
  }

  Future<void> _handleLocationPermissionException(dynamic e) async {
    if (e is LocationServiceDisabledException) {
      await _locationService.openLocationSettings;
    } else if (e is PermissionDeniedException) {
      await _locationService.openAppSettings;
    }
  }
}