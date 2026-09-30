import 'package:geolocator/geolocator.dart';

enum LocationFailure { serviceDisabled, denied, deniedForever }

class LocationException implements Exception {
  final LocationFailure failure;
  final String message;

  const LocationException(this.failure, this.message);

  @override
  String toString() => message;
}

class LocationService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        LocationFailure.serviceDisabled,
        'Location service is turned off. Please enable GPS.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException(
          LocationFailure.denied,
          'Location permission was denied.',
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        LocationFailure.deniedForever,
        'Location permission is permanently denied. Please enable it from settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}