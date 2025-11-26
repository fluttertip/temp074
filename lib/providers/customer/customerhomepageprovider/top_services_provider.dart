

// ============================================
// FIXED TOP SERVICE PROVIDER
// ============================================
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/providers/mixins/pagination_mixin.dart';
import 'package:homeservice/services/customer/customer_homepage_services/customer_homepage_service.dart';

class TopServiceProvider extends BaseProvider with PaginationMixin {
  final CustomerHomeService _homeService = CustomerHomeService();

  List<ServiceWithProviderModel> _topProviderServicesWithProvider = [];
  DocumentSnapshot? _lastDocument;
  bool _isInitialized = false;

  List<ServiceWithProviderModel> get topProviderServicesWithProvider =>
      _topProviderServicesWithProvider;
  bool get isInitialized => _isInitialized;

  Future<void> loadTopServicesWithProvider({bool forceRefresh = false}) async {
    // FIX: Removed the problematic `if (isLoading) return;` guard
    
    // Only skip if already initialized and not forcing refresh
    if (_isInitialized && !forceRefresh) {
      print('⏭️ [TopService] Already initialized, skipping');
      return;
    }

    setLoading(true);
    clearError();
    resetPagination();
    _lastDocument = null;

    try {
      print('🔄 [TopService] Loading top services...');
      final result = await _homeService.fetchTopProviderServicesWithProvider();
      _topProviderServicesWithProvider = result;
      _isInitialized = true;
      print('✅ [TopService] Loaded ${_topProviderServicesWithProvider.length} services');

      if (result.isNotEmpty) {
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to load top provider services.');
      _isInitialized = true;
      print('❌ [TopService] Error: $e');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMoreTopServices() async {
    if (!hasMoreData || isLoadingMore) return;

    setLoadingMore(true);

    try {
      final result = await _homeService.fetchTopProviderServicesWithProvider(
        lastDocument: _lastDocument,
      );

      if (result.isNotEmpty) {
        _topProviderServicesWithProvider.addAll(result);
        _lastDocument = result.last.lastDocument;
        updatePagination(result.length);
      } else {
        setNoMoreData();
      }
      notifyListeners();
    } catch (e) {
      setError('Failed to load more top provider services.');
      notifyListeners();
    } finally {
      setLoadingMore(false);
    }
  }

  Future<void> refreshTopServices() async {
    _isInitialized = false;
    await loadTopServicesWithProvider(forceRefresh: true);
  }

  void clearTopServices() {
    _topProviderServicesWithProvider.clear();
    _lastDocument = null;
    _isInitialized = false;
    resetPagination();
    clearError();
  }

  @override
  void dispose() {
    clearTopServices();
    super.dispose();
  }
}