import 'package:homeservice/models/servicewithprovider_model.dart';

abstract class ICustomerAdvanceSearchService {
  Future<List<ServiceWithProviderModel>> searchServices({
    required String query,
    List<String>? selectedFilters,
    int limit = 20,
  });

  Future<List<ServiceWithProviderModel>> searchByCategory({
    required String category,
    int limit = 20,
  });

  Future<List<ServiceWithProviderModel>> searchByPriceRange({
    required double minPrice,
    required double maxPrice,
    int limit = 20,
  });

  Future<List<ServiceWithProviderModel>> searchByRating({
    required double minRating,
    int limit = 20,
  });
}
