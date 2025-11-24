import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';
import 'core/ivendor_services_tab_page_service_interface.dart';
import 'impl/vendor_services_tab_page_service_impl.dart';

class VendorServicesTabPageService implements IVendorServicesTabPageService {
  final VendorServicesTabPageServiceImpl _impl;

  VendorServicesTabPageService({VendorServicesTabPageServiceImpl? impl})
    : _impl = impl ?? VendorServicesTabPageServiceImpl();

  @override
  Future<List<ServiceModel>> fetchProviderServices(String providerId) =>
      _impl.fetchProviderServices(providerId);

  @override
  Future<List<HardcodedServicesModel>> fetchHardcodedServicesInfo() =>
      _impl.fetchHardcodedServicesInfo();

  @override
  Future<void> addProviderService(ServiceModel service) =>
      _impl.addProviderService(service);

  @override
  Future<void> updateProviderService(ServiceModel service) =>
      _impl.updateProviderService(service);

  @override
  Future<void> deleteProviderService(String serviceId) =>
      _impl.deleteProviderService(serviceId);
  @override
  Future<List<String>> searchServiceTitles({
    required String categoryId,
    required String subcategoryId,
    required String query,
  }) => _impl.searchServiceTitles(
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    query: query,
  );

  Future<List<HardcodedServicesModel>> getHardcodedServices() =>
      fetchHardcodedServicesInfo();
}
