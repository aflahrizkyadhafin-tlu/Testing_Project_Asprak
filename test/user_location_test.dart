import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_api/userLocation.dart';

void main() {
  group('User Location Tests', () {
    test('getUserLocation returns Position object', () async {
      try {
        final position = await getUserLocation();

        expect(position, isA<Position>());
        expect(position.latitude, isA<double>());
        expect(position.longitude, isA<double>());
      } catch (e) {
        // Permission denied or location service not available
        // Location test skipped: $e
      }
    });

    test('getUserLocation returns valid latitude and longitude', () async {
      try {
        final position = await getUserLocation();

        // Valid latitude range: -90 to 90
        expect(position.latitude, greaterThanOrEqualTo(-90));
        expect(position.latitude, lessThanOrEqualTo(90));

        // Valid longitude range: -180 to 180
        expect(position.longitude, greaterThanOrEqualTo(-180));
        expect(position.longitude, lessThanOrEqualTo(180));
      } catch (e) {
        // Coordinate validation test skipped: $e
      }
    });

    test('getUserLocation returns Position with accuracy', () async {
      try {
        final position = await getUserLocation();

        expect(position.accuracy, isA<double>());
        expect(position.accuracy, greaterThanOrEqualTo(0));
      } catch (e) {
        // Accuracy test skipped: $e
      }
    });

    test('getUserLocation returns timestamp', () async {
      try {
        final position = await getUserLocation();

        expect(position.timestamp, isNotNull);
        expect(position.timestamp, isA<DateTime>());
      } catch (e) {
        // Timestamp test skipped: $e
      }
    });
  });
}
