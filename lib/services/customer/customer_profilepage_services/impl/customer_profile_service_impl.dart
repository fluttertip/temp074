import 'package:homeservice/models/user_model.dart';
import '../core/icustomer_profile_service_interface.dart';
import '../firebase_source/customer_profile_firestore_source.dart';

class CustomerProfileServiceImpl implements ICustomerProfileService {
  final CustomerProfileFirestoreSource _source;

  CustomerProfileServiceImpl({CustomerProfileFirestoreSource? source})
    : _source = source ?? CustomerProfileFirestoreSource();

  @override
  Future<UserModel?> getCustomerProfile(String uid) =>
      _source.getCustomerProfile(uid);

  @override
  Future<void> updateCustomerProfile({
    required String uid,
    String? name,
    String? address,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    bool? isprofilecompletecustomer,
  }) => _source.updateCustomerProfile(
    uid: uid,
    name: name,
    address: address,
    profilePhotoUrl: profilePhotoUrl,
    coverPhotoUrl: coverPhotoUrl,
    isprofilecompletecustomer: isprofilecompletecustomer,
  );
}
