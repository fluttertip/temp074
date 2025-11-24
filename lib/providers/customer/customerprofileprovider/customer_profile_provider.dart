import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/customer/customer_profilepage_services/customer_profile_page_services.dart';

class CustomerProfileProvider extends BaseProvider {
  final CustomerProfilePageServices _profileService;
  UserProvider? _userProvider;

  CustomerProfileProvider({CustomerProfilePageServices? profileService})
    : _profileService = profileService ?? CustomerProfilePageServices();

  bool _isUpdating = false;
  bool _isEditing = false;
  String? _editingName;
  String? _editingAddress;
  final Map<String, bool> _bannerShown = {
    'customer_home': false,
    'customer_service_detail': false,
    'customer_profile': false,
  };

  UserModel? get user => _userProvider?.getCachedUser();
  String get uid => _userProvider?.getCachedUser()?.uid ?? '';
  bool get isUpdating => _isUpdating;
  bool get isEditing => _isEditing;
  String? get editingName => _editingName;
  String? get editingAddress => _editingAddress;

  bool get isCustomerProfileComplete {
    final currentUser = _userProvider?.getCachedUser();
    if (currentUser == null) return false;
    return currentUser.isprofilecompletecustomer;
  }

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

  void startEditing() {
    final currentUser = user;
    _isEditing = true;
    _editingName = currentUser?.name ?? '';
    _editingAddress = currentUser?.address ?? '';
  }

  void cancelEditing() {
    _isEditing = false;
    _resetEditingFields();
  }

  void updateEditingName(String name) {
    _editingName = name;
  }

  void updateEditingAddress(String address) {
    _editingAddress = address;
  }

  Future<bool> updateCustomerPersonalDetails() async {
    if (uid.isEmpty || _userProvider == null) return false;

    final newName = _editingName?.trim() ?? '';
    final newAddress = _editingAddress?.trim() ?? '';
    final isInitialProfile = !(user?.isprofilecompletecustomer ?? false);

    if (isInitialProfile) {
      if (newName.isEmpty || newAddress.isEmpty) {
        setError(
          'Both Name and Address are required to complete your profile.',
        );
        return false;
      }
    } else {
      if (newName.isEmpty && newAddress.isEmpty) {
        setError('Please update at least one field.');
        return false;
      }
    }

    _setUpdating(true);
    clearError();

    try {
      await _profileService.updateCustomerProfile(
        uid: uid,
        name: newName.isNotEmpty ? newName : null,
        address: newAddress.isNotEmpty ? newAddress : null,
        isprofilecompletecustomer: true,
      );

      await refresh();
      _isEditing = false;
      _resetEditingFields();
      return true;
    } catch (e) {
      setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  Future<bool> updateCustomerProfileImage(String imageUrl) async {
    if (_userProvider?.getCachedUser() == null) return false;

    _setUpdating(true);
    clearError();

    try {
      await _profileService.updateCustomerProfile(
        uid: _userProvider!.getCachedUser()!.uid,
        profilePhotoUrl: imageUrl,
      );
      await refresh();
      return true;
    } catch (e) {
      setError('Failed to update profile image: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  Future<bool> updateCustomerCoverImage(String imageUrl) async {
    if (_userProvider?.getCachedUser() == null) return false;

    _setUpdating(true);
    clearError();

    try {
      await _profileService.updateCustomerProfile(
        uid: _userProvider!.getCachedUser()!.uid,
        coverPhotoUrl: imageUrl,
      );
      await refresh();
      return true;
    } catch (e) {
      setError('Failed to update cover image: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
  }

  void _resetEditingFields() {
    _editingName = null;
    _editingAddress = null;
  }

  void clear() {
    _isUpdating = false;
    _isEditing = false;
    _resetEditingFields();
    clearError();
    setLoading(false);
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}