import 'package:homeservice/services/customer/cusomter_location_services/location_services.dart';
import '../base/base_provider.dart';

class LocationProvider extends BaseProvider {
  String _currentLocation = 'Loading...';
  bool _isInitialized = false;
  bool _hasPermission = false;
  double? _latitude;
  double? _longitude;
  bool _locationServiceEnabled = false;

  String get currentLocation => _currentLocation;
  bool get isInitialized => _isInitialized;
  bool get hasPermission => _hasPermission;
  bool get locationServiceEnabled => _locationServiceEnabled;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  /// Get current location with coordinates
  Future<void> getCurrentLocation() async {
    // Don't reload if already initialized successfully
    if (_isInitialized && _hasPermission) {
      print('⏭️ [LocationProvider] Already initialized with permission');
      return;
    }

    setLoading(true);
    clearError();

    try {
      print('🔄 [LocationProvider] Getting current location...');
      
      // Check if location service is enabled (FIXED: Added static call)
      _locationServiceEnabled = await LocationService.isLocationServiceEnabled();
      
      if (!_locationServiceEnabled) {
        setError('Location services are disabled. Please enable location services.');
        _currentLocation = 'Location services disabled';
        _hasPermission = false;
        _isInitialized = true;
        notifyListeners();
        setLoading(false);
        return;
      }

      // Get location data with coordinates (FIXED: Added static call)
      final locationData = await LocationService.getCurrentLocationData();
      
      _currentLocation = locationData.address;
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;
      _hasPermission = true;
      _locationServiceEnabled = true;
      
      print('✅ [LocationProvider] Location: $_currentLocation');
      print('✅ [LocationProvider] Coordinates: $_latitude, $_longitude');
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('❌ [LocationProvider] Error: $e');
      
      String errorMessage = e.toString();
      if (errorMessage.contains('disabled')) {
        setError('Location services are disabled');
        _currentLocation = 'Location services disabled';
        _locationServiceEnabled = false;
      } else if (errorMessage.contains('denied')) {
        setError('Location permission denied');
        _currentLocation = 'Permission denied';
        _locationServiceEnabled = true;
      } else {
        setError('Could not get location: $errorMessage');
        _currentLocation = 'Location unavailable';
      }
      
      _hasPermission = false;
      _isInitialized = true;
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  /// Refresh location (force reload)
  Future<void> refreshLocation() async {
    _isInitialized = false;
    _hasPermission = false;
    clearError();
    await getCurrentLocation();
  }

  /// Request location permission (FIXED: Added static call)
  Future<bool> requestPermission() async {
    try {
      final permission = await LocationService.requestPermission();
      _hasPermission = permission.toString().contains('whileInUse') || 
                       permission.toString().contains('always');
      notifyListeners();
      return _hasPermission;
    } catch (e) {
      print('❌ [LocationProvider] Permission error: $e');
      return false;
    }
  }

  /// Open location settings (FIXED: Added static call)
  Future<void> openLocationSettings() async {
    try {
      await LocationService.openLocationSettings();
    } catch (e) {
      print('❌ [LocationProvider] Could not open settings: $e');
    }
  }

  /// Set manual location (when user enters address manually)
  void setManualLocation(String location, {double? lat, double? lng}) {
    _currentLocation = location;
    _latitude = lat;
    _longitude = lng;
    _hasPermission = false; // Manual location, not GPS
    _isInitialized = true;
    clearError();
    notifyListeners();
  }

  /// Check if location data is valid for booking
  bool isLocationValid() {
    return _currentLocation.isNotEmpty && 
           _currentLocation != 'Loading...' &&
           _currentLocation != 'Location services disabled' &&
           _currentLocation != 'Permission denied' &&
           _currentLocation != 'Location unavailable';
  }

  @override
  void dispose() {
    _currentLocation = 'Loading...';
    _isInitialized = false;
    _hasPermission = false;
    _locationServiceEnabled = false;
    _latitude = null;
    _longitude = null;
    super.dispose();
  }
}