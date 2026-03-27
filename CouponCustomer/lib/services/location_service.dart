import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Result of a city detection attempt.
class CityDetectionResult {
  /// The city name detected by reverse-geocoding (e.g. "Surat").
  final String? cityName;

  /// Whether permission was denied by the user.
  final bool permissionDenied;

  /// Whether GPS/location services are disabled on the device.
  final bool serviceDisabled;

  const CityDetectionResult({
    this.cityName,
    this.permissionDenied = false,
    this.serviceDisabled = false,
  });

  bool get hasCity => cityName != null && cityName!.isNotEmpty;
}

/// Stateless service that detects the device's current city using GPS + reverse
/// geocoding. No state is stored here — call [detectCity] and consume the result
/// in the presentation layer.
class LocationService {
  const LocationService._();

  /// Requests location permission (if not already granted) and fetches the
  /// device's current GPS coordinates.
  /// Returns null if permission is denied or service is disabled.
  static Future<Position?> getUserLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Requests location permission (if not already granted), fetches the device
  /// position, and reverse-geocodes it to obtain a city name.
  ///
  /// Returns a [CityDetectionResult] describing what happened.
  static Future<CityDetectionResult> detectCity() async {
    // 1. Check if location services are enabled at all
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const CityDetectionResult(serviceDisabled: true);
    }

    // 2. Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const CityDetectionResult(permissionDenied: true);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return const CityDetectionResult(permissionDenied: true);
    }

    // 3. Get position (low accuracy is sufficient for city-level detection and
    //    is faster + less battery intensive)
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );

    // 4. Reverse geocode → extract city
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      // Administrative area (state-level) is sometimes "Gujarat"; locality is
      // the actual city like "Surat". Prefer locality, fall back to subAdminArea.
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      final city = placemark?.locality?.isNotEmpty == true
          ? placemark!.locality!
          : placemark?.subAdministrativeArea;

      return CityDetectionResult(cityName: city);
    } catch (_) {
      // Geocoding failed (e.g. offline) — return no city but no error either
      return const CityDetectionResult();
    }
  }

  /// Tries to fuzzy-match a detected [deviceCityName] against a list of city
  /// names. Returns the matched city name (as it appears in the API list) or
  /// null if no match is found.
  ///
  /// Matching is case-insensitive and checks if either string contains the
  /// other — covers "Surat" ↔ "surat", "Ahmedabad" ↔ "ahmedabad city", etc.
  static String? matchCity(
    String deviceCityName,
    Iterable<String> apiCityNames,
  ) {
    final needle = deviceCityName.toLowerCase().trim();
    for (final name in apiCityNames) {
      final hay = name.toLowerCase().trim();
      if (hay == needle || hay.contains(needle) || needle.contains(hay)) {
        return name; // Return original casing from API
      }
    }
    return null;
  }
}
