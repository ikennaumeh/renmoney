import 'package:geolocator/geolocator.dart';

class LocationService{

  // Getter for open location setting
  Future<bool> get openLocationSettings async =>
      Geolocator.openLocationSettings();

  // Getter for open app settings
  Future<bool> get openAppSettings async => Geolocator.openAppSettings();

  // Getter for request location permission
  Future<bool> get requestLocationPermission async =>
      await _requestLocationPermission;

  Future<Position> get getUserLocation async => await _getLocation();

  /// Determine the current position of the device.
  Future<bool> get _requestLocationPermission async {
    late bool serviceEnabled;
    late LocationPermission permission;

    /// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationServiceDisabledException();
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        throw const PermissionDeniedException("Permission denied");
      }
    }

    return true;
  }

  Future<Position> _getLocation() async {
    try {
      ///Requests for the location permission
      final result = await _requestLocationPermission;

      if (result) {
        // If its true then get the current location and move to the choose
        // location screen
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 20),
        );
      } else {
        throw const PermissionDeniedException("Permission denied");
      }
    } catch (e) {
      rethrow;
    }
  }

}