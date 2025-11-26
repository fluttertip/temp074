import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location with coordinates and address
  static Future<LocationData> getCurrentLocationData() async {
    try {
      print('🔄 [LocationService] Getting current location...');

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ [LocationService] Location services are disabled');
        throw Exception('Location services are disabled. Please enable location services.');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ [LocationService] Location permissions denied');
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ [LocationService] Location permissions permanently denied');
        throw Exception('Location permissions are permanently denied. Please enable them in settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('✅ [LocationService] Position: ${position.latitude}, ${position.longitude}');

      // Get address from coordinates
      String address = 'Kathmandu, Nepal'; // Default
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address = _formatAddress(place);
          print('✅ [LocationService] Address: $address');
        }
      } catch (e) {
        print('⚠️ [LocationService] Could not get address: $e');
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      print('❌ [LocationService] Error: $e');
      rethrow;
    }
  }

  /// Get current location (legacy method - returns only address string)
  static Future<String> getCurrentLocation() async {
    try {
      final locationData = await getCurrentLocationData();
      return locationData.address;
    } catch (e) {
      print('❌ [LocationService] Error getting location: $e');
      return 'Kathmandu, Nepal'; // Fallback
    }
  }

  /// Format placemark to readable address
  static String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'Unknown Location';
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Get distance between two points in meters
  static double getDistanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}