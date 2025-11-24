
// ============================================
// 1. LOCAL EXPERT PROVIDER
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
    if (isLoading) return;

    if (_isInitialized || forceRefresh) {
      setLoading(true);
    }
    clearError();

    try {
      final result = await _homeService.fetchLocalExperts(location);
      _localExperts = result;
      _isInitialized = true;
      print('Loaded ${_localExperts.length} local experts for $location');
    } catch (e) {
      setError('Failed to load local experts.');
      _isInitialized = true;
      print('Error loading local experts: $e');
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