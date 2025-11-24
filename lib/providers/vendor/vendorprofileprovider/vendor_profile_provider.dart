import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/vendor/vendor_profile_page_service/vendor_profile_page_service.dart';

class VendorProfileProvider extends BaseProvider {
  final VendorProfilePageService _service;
  UserProvider? _userProvider;

  VendorProfileProvider({VendorProfilePageService? service})
    : _service = service ?? VendorProfilePageService();

  final Map<String, bool> _bannerShown = {
    'vendor_profile': false,
    'vendor_dashboard': false,
    'vendor_services': false,
  };

  UserModel? get user => _userProvider?.getCachedUser();
  String get uid => _userProvider?.getCachedUser()?.uid ?? '';
  bool get isVendorProfileComplete => user?.isprofilecompletevendor ?? false;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  bool isBannerShown(String screen) {
    return _bannerShown[screen] ?? false;
  }

  void markBannerShown(String screen) {
    _bannerShown[screen] = true;
  }

  Future<void> refresh() async {
    // Implement if needed
  }

  Future<void> updateVendorPersonalDetails({
    String? name,
    String? aboutMe,
    String? address,
  }) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateVendorProfile(
        uid,
        name: name,
        aboutMe: aboutMe,
        address: address,
      );
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateVendorProfileImage({String? profilePhotoUrl}) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateVendorProfile(uid, profilePhotoUrl: profilePhotoUrl);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateVendorCoverImage({String? coverPhotoUrl}) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateVendorProfile(uid, coverPhotoUrl: coverPhotoUrl);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateSkillsAndCertifications({
    List<String>? skills,
    List<String>? certifications,
  }) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateSkillsAndCertifications(
        uid,
        skills: skills,
        certifications: certifications,
      );
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateServiceAreas(List<String> serviceAreas) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateServiceAreas(uid, serviceAreas);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateNotificationSettings(
    Map<String, bool> notificationSettings,
  ) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updateNotificationSettings(uid, notificationSettings);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.updatePreferences(uid, preferences);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> submitKycDetails(Map<String, dynamic> details) async {
    if (uid.isEmpty) return;
    setLoading(true);
    clearError();
    
    try {
      await _service.submitKycDetails(uid, details);
      await refresh();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}