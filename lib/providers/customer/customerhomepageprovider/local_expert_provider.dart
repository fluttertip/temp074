
// ============================================
// FIXED LOCAL EXPERT PROVIDER
// ============================================
import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/customer/customer_homepage_services/customer_homepage_service.dart';

class LocalExpertProvider extends BaseProvider {
  final CustomerHomeService _homeService = CustomerHomeService();

  List<UserModel> _localExperts = [];
  bool _isInitialized = false;

  List<UserModel> get localExperts => _localExperts;
  bool get isInitialized => _isInitialized;

  Future<void> loadLocalExperts(
    String location, {
    bool forceRefresh = false,
  }) async {
    // FIX: Removed the problematic `if (isLoading) return;` guard
    
    // Only skip if already initialized and not forcing refresh
    if (_isInitialized && !forceRefresh) {
      print('⏭️ [LocalExpert] Already initialized, skipping');
      return;
    }

    setLoading(true);
    clearError();

    try {
      print('🔄 [LocalExpert] Loading experts for $location...');
      final result = await _homeService.fetchLocalExperts(location);
      _localExperts = result;
      _isInitialized = true;
      print('✅ [LocalExpert] Loaded ${_localExperts.length} experts');
      notifyListeners();
    } catch (e) {
      setError('Failed to load local experts.');
      _isInitialized = true;
      print('❌ [LocalExpert] Error: $e');
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _localExperts.clear();
    _isInitialized = false;
    super.dispose();
  }
}
