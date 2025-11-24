import 'package:homeservice/models/user_model.dart';
import 'core/icustomer_profile_service_interface.dart';
import 'impl/customer_profile_service_impl.dart';

class CustomerProfilePageServices implements ICustomerProfileService {
  final CustomerProfileServiceImpl _profileService;

  CustomerProfilePageServices({CustomerProfileServiceImpl? profileService})
    : _profileService = profileService ?? CustomerProfileServiceImpl();

  @override
  Future<UserModel?> getCustomerProfile(String uid) async {
    try {
      return await _profileService.getCustomerProfile(uid);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<void> updateCustomerProfile({
    required String uid,
    String? name,
    String? address,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    bool? isprofilecompletecustomer,
  }) async {
    try {
      return await _profileService.updateCustomerProfile(
        uid: uid,
        name: name,
        address: address,
        profilePhotoUrl: profilePhotoUrl,
        coverPhotoUrl: coverPhotoUrl,
        isprofilecompletecustomer: isprofilecompletecustomer,
      );
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
