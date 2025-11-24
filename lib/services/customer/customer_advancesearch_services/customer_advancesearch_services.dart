import 'package:homeservice/models/servicewithprovider_model.dart';
import 'core/icustomer_advancesearch_service_interface.dart';
import 'impl/advancesearch_service_impl.dart';

class CustomerAdvanceSearchServices implements ICustomerAdvanceSearchService {
  final AdvanceSearchServiceImpl _searchService;

  CustomerAdvanceSearchServices({AdvanceSearchServiceImpl? searchService})
    : _searchService = searchService ?? AdvanceSearchServiceImpl();

  @override
  Future<List<ServiceWithProviderModel>> searchServices({
    required String query,
    List<String>? selectedFilters,
    int limit = 20,
  }) async {
    try {
      return await _searchService.searchServices(
        query: query,
        selectedFilters: selectedFilters,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> searchByCategory({
    required String category,
    int limit = 20,
  }) async {
    try {
      return await _searchService.searchByCategory(
        category: category,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to search by category: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> searchByPriceRange({
    required double minPrice,
    required double maxPrice,
    int limit = 20,
  }) async {
    try {
      return await _searchService.searchByPriceRange(
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to search by price range: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> searchByRating({
    required double minRating,
    int limit = 20,
  }) async {
    try {
      return await _searchService.searchByRating(
        minRating: minRating,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to search by rating: $e');
    }
  }
}
