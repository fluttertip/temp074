import 'package:homeservice/models/user_model.dart';
import '../core/ivendor_profile_page_service_interface.dart';
import '../firebase_source/vendor_profile_firestore_source.dart';

class VendorProfilePageServiceImpl implements IVendorProfilePageService {
  final VendorProfileFirestoreSource _firestoreSource;

  VendorProfilePageServiceImpl({VendorProfileFirestoreSource? firestoreSource})
    : _firestoreSource = firestoreSource ?? VendorProfileFirestoreSource();

  @override
  Future<UserModel?> getVendorProfile(String uid) async {
    final snap = await _firestoreSource.getProfile(uid);
    if (!snap.exists) return null;
    return UserModel.fromFirestore(snap.data() as Map<String, dynamic>, uid);
  }

  @override
  Future<void> updateVendorProfile(
    String uid, {
    String? name,
    String? aboutMe,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    String? address,
  }) async {
    final update = <String, dynamic>{
      if (name != null) 'name': name,
      if (aboutMe != null) 'aboutMe': aboutMe,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      if (coverPhotoUrl != null) 'coverPhotoUrl': coverPhotoUrl,
      if (address != null) 'address': address,
      'updatedAt': DateTime.now(),
    };
    await _firestoreSource.updateProfile(uid, update);
  }

  @override
  Future<void> updateSkillsAndCertifications(
    String uid, {
    List<String>? skills,
    List<String>? certifications,
  }) async {
    final update = <String, dynamic>{
      if (skills != null) 'skills': skills,
      if (certifications != null) 'certifications': certifications,
      'updatedAt': DateTime.now(),
    };
    await _firestoreSource.updateProfile(uid, update);
  }

  @override
  Future<void> updateServiceAreas(String uid, List<String> serviceAreas) async {
    await _firestoreSource.updateProfile(uid, {
      'serviceAreas': serviceAreas,
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> updateNotificationSettings(
    String uid,
    Map<String, bool> notificationSettings,
  ) async {
    await _firestoreSource.updateProfile(uid, {
      'notificationSettings': notificationSettings,
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> updatePreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) async {
    await _firestoreSource.updateProfile(uid, {
      'preferences': preferences,
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> submitKyc(String uid, List<String> documentUrls) async {
    await _firestoreSource.updateProfile(uid, {
      'kycDocumentUrls': documentUrls,
      'kycStatus': 'pending',
      'kycSubmittedAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> submitKycDetails(
    String uid,
    Map<String, dynamic> details,
  ) async {
    await _firestoreSource.updateProfile(uid, {
      'kyc': details,
      'kycStatus': 'pending',
      'kycSubmittedAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> updateKycStatus(String uid, String status) async {
    await _firestoreSource.updateProfile(uid, {
      'kycStatus': status,
      'kycApprovedAt': status == 'approved' ? DateTime.now() : null,
      'updatedAt': DateTime.now(),
    });
  }
}
