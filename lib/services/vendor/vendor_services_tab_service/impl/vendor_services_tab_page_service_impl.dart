import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';
import '../core/ivendor_services_tab_page_service_interface.dart';
import '../firebase_source/vendor_services_tab_page_firestore_source.dart';

class VendorServicesTabPageServiceImpl
    implements IVendorServicesTabPageService {
  final VendorServicesTabPageFirestoreSource _source;

  VendorServicesTabPageServiceImpl({
    VendorServicesTabPageFirestoreSource? source,
  }) : _source = source ?? VendorServicesTabPageFirestoreSource();

  @override
  Future<List<ServiceModel>> fetchProviderServices(String providerId) =>
      _source.fetchProviderServices(providerId);

  @override
  Future<List<HardcodedServicesModel>> fetchHardcodedServicesInfo() =>
      _source.fetchHardcodedServicesInfo();

  @override
  Future<void> addProviderService(ServiceModel service) =>
      _source.addProviderService(service);

  @override
  Future<void> updateProviderService(ServiceModel service) =>
      _source.updateProviderService(service);

  @override
  Future<void> deleteProviderService(String serviceId) =>
      _source.deleteProviderService(serviceId);

  @override
  Future<List<String>> searchServiceTitles({
    required String categoryId,
    required String subcategoryId,
    required String query,
  }) => _source.searchServiceTitles(
    categoryId: categoryId,
    subcategoryId: subcategoryId,
    query: query,
  );
}
