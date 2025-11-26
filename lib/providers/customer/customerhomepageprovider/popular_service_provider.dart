


// ============================================
// FIXED POPULAR SERVICE PROVIDER
// ============================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/providers/mixins/pagination_mixin.dart';
import 'package:homeservice/services/customer/customer_homepage_services/customer_homepage_service.dart';

class PopularServiceProvider extends BaseProvider with PaginationMixin {
  final CustomerHomeService _homeService = CustomerHomeService();

  List<ServiceWithProviderModel> _popularServicesWithProvider = [];
  DocumentSnapshot? _lastDocument;
  bool _isInitialized = false;

  List<ServiceWithProviderModel> get popularServicesWithProvider =>
      _popularServicesWithProvider;
  bool get isInitialized => _isInitialized;

  Future<void> loadPopularServicesWithProvider({
    bool forceRefresh = false,
  }) async {
    // FIX: Removed the problematic `if (isLoading) return;` guard
    
    // Only skip if already initialized and not forcing refresh
    if (_isInitialized && !forceRefresh) {
      print('⏭️ [PopularService] Already initialized, skipping');
      return;
    }

    setLoading(true);
    clearError();
    resetPagination();
    _lastDocument = null;

    try {
      print('🔄 [PopularService] Loading popular services...');
      final result = await _homeService.fetchPopularServicesWithProvider();
      _popularServicesWithProvider = result;
      _isInitialized = true;
      print('✅ [PopularService] Loaded ${_popularServicesWithProvider.length} services');

      if (result.isNotEmpty) {
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to load popular services.');
      _isInitialized = true;
      print('❌ [PopularService] Error: $e');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMorePopularServices() async {
    if (!hasMoreData || isLoadingMore) return;

    setLoadingMore(true);

    try {
      final result = await _homeService.fetchPopularServicesWithProvider(
        lastDocument: _lastDocument,
      );

      if (result.isNotEmpty) {
        _popularServicesWithProvider.addAll(result);
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to load more popular services.');
      notifyListeners();
    } finally {
      setLoadingMore(false);
    }
  }

  Future<void> refreshPopularServices() async {
    _isInitialized = false;
    await loadPopularServicesWithProvider(forceRefresh: true);
  }

  void clearData() {
    _popularServicesWithProvider.clear();
    _lastDocument = null;
    _isInitialized = false;
    resetPagination();
    clearError();
  }

  @override
  void dispose() {
    clearData();
    super.dispose();
  }
}