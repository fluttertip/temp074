import 'package:homeservice/models/user_model.dart';

abstract class IVendorProfilePageService {
  Future<UserModel?> getVendorProfile(String uid);

  Future<void> updateVendorProfile(
    String uid, {
    String? name,
    String? aboutMe,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    String? address,
  });

  Future<void> updateSkillsAndCertifications(
    String uid, {
    List<String>? skills,
    List<String>? certifications,
  });

  Future<void> updateServiceAreas(String uid, List<String> serviceAreas);

  Future<void> updateNotificationSettings(
    String uid,
    Map<String, bool> notificationSettings,
  );

  Future<void> updatePreferences(String uid, Map<String, dynamic> preferences);

  Future<void> submitKyc(String uid, List<String> documentUrls);

  Future<void> submitKycDetails(String uid, Map<String, dynamic> details);

  Future<void> updateKycStatus(String uid, String status);
}
