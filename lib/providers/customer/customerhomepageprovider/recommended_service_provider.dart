
// ============================================
// FIXED RECOMMENDED SERVICE PROVIDER
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
    // FIX: Removed the problematic `if (isLoading) return;` guard
    
    // Only skip if already initialized and not forcing refresh
    if (_isInitialized && !forceRefresh) {
      print('⏭️ [RecommendedService] Already initialized, skipping');
      return;
    }

    setLoading(true);
    clearError();
    resetPagination();
    _lastDocument = null;

    try {
      print('🔄 [RecommendedService] Loading recommended services...');
      final result = await _homeService.fetchRecommendedServicesWithProvider();
      _recommendedServicesWithProvider = result;
      _isInitialized = true;
      print('✅ [RecommendedService] Loaded ${_recommendedServicesWithProvider.length} services');

      if (result.isNotEmpty) {
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to load recommended services.');
      _isInitialized = true;
      print('❌ [RecommendedService] Error: $e');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreRecommendedServices() async {
    if (!hasMoreData || isLoadingMore) return;

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
      notifyListeners();
    } catch (e) {
      setError('Failed to load more recommended services.');
      notifyListeners();
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