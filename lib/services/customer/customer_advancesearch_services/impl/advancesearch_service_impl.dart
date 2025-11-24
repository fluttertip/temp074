import 'package:homeservice/models/servicewithprovider_model.dart';
import '../core/icustomer_advancesearch_service_interface.dart';
import '../firebase_source/advancesearch_firestore_source.dart';

class AdvanceSearchServiceImpl implements ICustomerAdvanceSearchService {
  final AdvanceSearchFirestoreSource _source;

  AdvanceSearchServiceImpl({AdvanceSearchFirestoreSource? source})
    : _source = source ?? AdvanceSearchFirestoreSource();

  @override
  Future<List<ServiceWithProviderModel>> searchServices({
    required String query,
    List<String>? selectedFilters,
    int limit = 20,
  }) => _source.searchServices(
    query: query,
    selectedFilters: selectedFilters,
    limit: limit,
  );

  @override
  Future<List<ServiceWithProviderModel>> searchByCategory({
    required String category,
    int limit = 20,
  }) => _source.searchServices(
    query: '',
    selectedFilters: [category],
    limit: limit,
  );

  @override
  Future<List<ServiceWithProviderModel>> searchByPriceRange({
    required double minPrice,
    required double maxPrice,
    int limit = 20,
  }) {
    String priceFilter;
    if (maxPrice <= 500) {
      priceFilter = 'Under Rs. 500';
    } else if (maxPrice <= 1000) {
      priceFilter = 'Rs. 500 - Rs. 1000';
    } else if (maxPrice <= 2000) {
      priceFilter = 'Rs. 1000 - Rs. 2000';
    } else {
      priceFilter = 'Above Rs. 2000';
    }

    return _source.searchServices(
      query: '',
      selectedFilters: [priceFilter],
      limit: limit,
    );
  }

  @override
  Future<List<ServiceWithProviderModel>> searchByRating({
    required double minRating,
    int limit = 20,
  }) {
    String ratingFilter;
    if (minRating >= 4.5) {
      ratingFilter = '4.5+ Stars';
    } else if (minRating >= 4.0) {
      ratingFilter = '4.0+ Stars';
    } else if (minRating >= 3.5) {
      ratingFilter = '3.5+ Stars';
    } else {
      ratingFilter = '3.0+ Stars';
    }

    return _source.searchServices(
      query: '',
      selectedFilters: [ratingFilter],
      limit: limit,
    );
  }
}
