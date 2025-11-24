import 'package:homeservice/models/user_model.dart';
import 'core/ivendor_profile_page_service_interface.dart';
import 'impl/vendor_profile_page_service_impl.dart';

class VendorProfilePageService implements IVendorProfilePageService {
  final VendorProfilePageServiceImpl _impl;

  VendorProfilePageService({VendorProfilePageServiceImpl? impl})
    : _impl = impl ?? VendorProfilePageServiceImpl();

  @override
  Future<UserModel?> getVendorProfile(String uid) =>
      _impl.getVendorProfile(uid);

  @override
  Future<void> updateVendorProfile(
    String uid, {
    String? name,
    String? aboutMe,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    String? address,
  }) => _impl.updateVendorProfile(
    uid,
    name: name,
    aboutMe: aboutMe,
    profilePhotoUrl: profilePhotoUrl,
    coverPhotoUrl: coverPhotoUrl,
    address: address,
  );

  @override
  Future<void> updateSkillsAndCertifications(
    String uid, {
    List<String>? skills,
    List<String>? certifications,
  }) => _impl.updateSkillsAndCertifications(
    uid,
    skills: skills,
    certifications: certifications,
  );

  @override
  Future<void> updateServiceAreas(String uid, List<String> serviceAreas) =>
      _impl.updateServiceAreas(uid, serviceAreas);

  @override
  Future<void> updateNotificationSettings(
    String uid,
    Map<String, bool> notificationSettings,
  ) => _impl.updateNotificationSettings(uid, notificationSettings);

  @override
  Future<void> updatePreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) => _impl.updatePreferences(uid, preferences);

  @override
  Future<void> submitKyc(String uid, List<String> documentUrls) =>
      _impl.submitKyc(uid, documentUrls);

  @override
  Future<void> submitKycDetails(String uid, Map<String, dynamic> details) =>
      _impl.submitKycDetails(uid, details);

  @override
  Future<void> updateKycStatus(String uid, String status) =>
      _impl.updateKycStatus(uid, status);
}
