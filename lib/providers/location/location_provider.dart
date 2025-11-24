// ============================================
// 5. LOCATION PROVIDER
// ============================================
import 'package:homeservice/services/customer/cusomter_location_services/location_services.dart';
import '../base/base_provider.dart';

class LocationProvider extends BaseProvider {
  String _currentLocation = 'Loading...';
  bool _isInitialized = false;

  String get currentLocation => _currentLocation;
  bool get isInitialized => _isInitialized;

  Future<void> getCurrentLocation() async {
    if (isLoading) return;

    if (_isInitialized) {
      setLoading(true);
    }
    clearError();

    try {
      String location = await LocationService.getCurrentLocation();
      _currentLocation = location;
      _isInitialized = true;
    } catch (e) {
      setError(e.toString());
      _currentLocation = 'Kathmandu';
      _isInitialized = true;
      print('Error getting location: $e');
    } finally {
      setLoading(false);
    }
  }

  void refreshLocation() {
    _isInitialized = false;
    getCurrentLocation();
  }

  @override
  void dispose() {
    _currentLocation = 'Loading...';
    _isInitialized = false;
    super.dispose();
  }
}