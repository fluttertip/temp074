// ============================================
// 3. RECOMMENDED SERVICE PROVIDER
// ============================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/providers/mixins/pagination_mixin.dart';
import 'package:homeservice/services/customer/customer_homepage_services/customer_homepage_service.dart';

class RecommendedServiceProvider extends BaseProvider with PaginationMixin {
  final CustomerHomeService _homeService = CustomerHomeService();

  List<ServiceWithProviderModel> _recommendedServicesWithProvider = [];
  DocumentSnapshot? _lastDocument;
  bool _isInitialized = false;

  List<ServiceWithProviderModel> get recommendedServicesWithProvider =>
      _recommendedServicesWithProvider;
  bool get isInitialized => _isInitialized;

  Future<void> loadRecommendedServicesWithProvider({
    bool forceRefresh = false,
  }) async {
    if (isLoading) return;

    if (_isInitialized || forceRefresh) {
      setLoading(true);
    }
    clearError();
    resetPagination();
    _lastDocument = null;

    try {
      final result = await _homeService.fetchRecommendedServicesWithProvider();
      _recommendedServicesWithProvider = result;
      _isInitialized = true;
      print(
        'Loaded ${_recommendedServicesWithProvider.length} recommended services',
      );

      if (result.isNotEmpty) {
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
    } catch (e) {
      setError('Failed to load recommended services.');
      _isInitialized = true;
      print('Error loading recommended services: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreRecommendedServices() async {
    if (!hasMoreData || isLoadingMore || isLoading) return;

    setLoadingMore(true);

    try {
      final result = await _homeService.fetchRecommendedServicesWithProvider(
        lastDocument: _lastDocument,
      );

      if (result.isNotEmpty) {
        _recommendedServicesWithProvider.addAll(result);
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
    } catch (e) {
      setError('Failed to load more recommended services.');
    } finally {
      setLoadingMore(false);
    }
  }

  Future<void> refreshRecommendedServices() async {
    _isInitialized = false;
    await loadRecommendedServicesWithProvider(forceRefresh: true);
  }

  void clearRecommendedServices() {
    _recommendedServicesWithProvider.clear();
    _lastDocument = null;
    _isInitialized = false;
    resetPagination();
  }

  @override
  void dispose() {
    clearRecommendedServices();
    super.dispose();
  }
}