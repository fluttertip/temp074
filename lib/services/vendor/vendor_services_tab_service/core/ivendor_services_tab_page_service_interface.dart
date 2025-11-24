import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';

abstract class IVendorServicesTabPageService {
  Future<List<ServiceModel>> fetchProviderServices(String providerId);
  Future<List<HardcodedServicesModel>> fetchHardcodedServicesInfo();
  Future<void> addProviderService(ServiceModel service);
  Future<void> updateProviderService(ServiceModel service);
  Future<void> deleteProviderService(String serviceId);
  Future<List<String>> searchServiceTitles({
    required String categoryId,
    required String subcategoryId,
    required String query,
  });
}
