import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/user_model.dart';

class CustomerProfileFirestoreSource {
  final FirebaseFirestore _firestore;

  CustomerProfileFirestoreSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel?> getCustomerProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCustomerProfile({
    required String uid,
    String? name,
    String? address,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    bool? isprofilecompletecustomer,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) {
        updateData['name'] = name;
      }
      if (address != null) {
        updateData['address'] = address;
      }
      if (profilePhotoUrl != null) {
        updateData['profilePhotoUrl'] = profilePhotoUrl;
      }
      if (coverPhotoUrl != null) {
        updateData['coverPhotoUrl'] = coverPhotoUrl;
      }
      if (isprofilecompletecustomer != null) {
        updateData['isprofilecompletecustomer'] = isprofilecompletecustomer;
      }

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      rethrow;
    }
  }
}
