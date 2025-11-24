import 'package:homeservice/models/user_model.dart';

abstract class ICustomerProfileService {
  Future<UserModel?> getCustomerProfile(String uid);
  Future<void> updateCustomerProfile({
    required String uid,
    String? name,
    String? address,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    bool? isprofilecompletecustomer,
  });
}
