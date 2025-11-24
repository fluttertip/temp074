// ============================================
// 6. VENDOR SERVICES PROVIDER
// ============================================
import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/vendor/vendor_services_tab_service/vendor_services_tab_page_service.dart';

class VendorServicesProvider extends BaseProvider {
  final VendorServicesTabPageService _service;

  VendorServicesProvider({VendorServicesTabPageService? service})
    : _service = service ?? VendorServicesTabPageService();

  List<ServiceModel> _services = [];
  List<HardcodedServicesModel> _hardcodedServices = [];
  List<String> _categories = [];
  List<ServiceSubcategory> _subcategories = [];
  bool _isInitialized = false;

  List<ServiceModel> get services => _services;
  List<HardcodedServicesModel> get hardcodedServices => _hardcodedServices;
  List<String> get categories => _categories;
  List<ServiceSubcategory> get subcategories => _subcategories;
  bool get isInitialized => _isInitialized;

  Future<void> fetchProviderServices(String providerId) async {
    if (isLoading) return;

    setLoading(true);
    clearError();

    try {
      _services = await _service.fetchProviderServices(providerId);
      _isInitialized = true;
      print('Fetched ${_services.length} provider services');
    } catch (e) {
      setError('Failed to fetch provider services: $e');
      print('Error fetching provider services: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchHardcodedServicesInfo() async {
    if (_hardcodedServices.isNotEmpty) return;

    try {
      _hardcodedServices = await _service.fetchHardcodedServicesInfo();
      _categories =
          _hardcodedServices.map((service) => service.category).toSet().toList()
            ..sort();

      print('Fetched ${_hardcodedServices.length} hardcoded services');
      print('Categories: $_categories');
    } catch (e) {
      setError('Failed to fetch hardcoded services: $e');
      print('Error fetching hardcoded services: $e');
    }
  }

  void fetchSubcategoriesByCategory(String category) {
    try {
      final hardcodedService = _hardcodedServices.firstWhere(
        (service) => service.category == category,
      );

      _subcategories = hardcodedService.subcategories
          .where((sub) => sub.isActive)
          .toList();

      print('Fetched ${_subcategories.length} subcategories for $category');
    } catch (e) {
      _subcategories = [];
      print('No subcategories found for category: $category');
    }
  }

  Future<void> addService(ServiceModel service) async {
    try {
      await _service.addProviderService(service);
      _services.insert(0, service);
      print('Service added successfully');
    } catch (e) {
      setError('Failed to add service: $e');
      print('Error adding service: $e');
      rethrow;
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      await _service.updateProviderService(service);
      final index = _services.indexWhere((s) => s.id == service.id);
      if (index != -1) {
        _services[index] = service;
      }
      print('Service updated successfully');
    } catch (e) {
      setError('Failed to update service: $e');
      print('Error updating service: $e');
      rethrow;
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _service.deleteProviderService(serviceId);
      _services.removeWhere((service) => service.id == serviceId);
      print('Service deleted successfully');
    } catch (e) {
      setError('Failed to delete service: $e');
      print('Error deleting service: $e');
      rethrow;
    }
  }

  void clearSubcategories() {
    _subcategories.clear();
  }

  @override
  void dispose() {
    _services.clear();
    _hardcodedServices.clear();
    _categories.clear();
    _subcategories.clear();
    _isInitialized = false;
    super.dispose();
  }
}