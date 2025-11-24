import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/customer/customer_homepage_services/customer_homepage_service.dart';

class BannerImageProvider extends BaseProvider {
  final CustomerHomeService _homeService = CustomerHomeService();

  List<String> _bannerImages = [];
  bool _isInitialized = false;
  DateTime? _lastFetchTime;

  List<String> get bannerImages => _bannerImages;
  bool get isInitialized => _isInitialized;

  static const List<String> _fallbackImages = [
    'https://ftb.com.kh/uploads/2024/05/Mobile_Banner_Promotion_EN.jpg',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&h=400&fit=crop',
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=800&h=400&fit=crop',
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=400&fit=crop',
  ];

  Future<void> loadBannerImages({bool forceRefresh = false}) async {
    if (isLoading) return;

    // Check if we need to refresh based on time
    final shouldRefresh = forceRefresh || 
        _lastFetchTime == null ||
        DateTime.now().difference(_lastFetchTime!) > const Duration(minutes: 30);

    if (!shouldRefresh && _bannerImages.isNotEmpty) {
      return;
    }

    if (_isInitialized && !forceRefresh) {
      setLoading(true);
    }
    
    clearError();

    try {
      final result = await _homeService.fetchBannerImages();
      
      if (result.isNotEmpty) {
        _bannerImages = result;
        _lastFetchTime = DateTime.now();
      } else {
        _bannerImages = List.from(_fallbackImages);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      setError('Failed to load banner images.');
      if (_bannerImages.isEmpty) {
        _bannerImages = List.from(_fallbackImages);
      }
      print('BannerImageProvider Error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() async {
    _isInitialized = false;
    await loadBannerImages(forceRefresh: true);
  }

  @override
  void dispose() {
    _bannerImages.clear();
    _isInitialized = false;
    super.dispose();
  }
}