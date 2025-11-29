import 'package:geolocator/geolocator.dart';

Future<Position> getUserLocation() async {
  Position userLocation = await Geolocator.getCurrentPosition(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 20,
    ),
  );

  return userLocation;
}
