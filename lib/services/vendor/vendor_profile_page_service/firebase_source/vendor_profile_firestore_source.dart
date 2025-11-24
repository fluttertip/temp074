import 'package:cloud_firestore/cloud_firestore.dart';

class VendorProfileFirestoreSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  Future<DocumentSnapshot<Map<String, dynamic>>> getProfile(String uid) {
    return _usersCol.doc(uid).get();
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _usersCol.doc(uid).update(data);
  }
}
