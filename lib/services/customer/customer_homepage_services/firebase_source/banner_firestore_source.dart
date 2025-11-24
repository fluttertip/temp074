import 'package:cloud_firestore/cloud_firestore.dart';

class BannerFirestoreSource {
  final FirebaseFirestore _firestore;

  BannerFirestoreSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<String>> fetchBannerImages() async {
    try {
      final snapshot = await _firestore.collection('promotional_offer').get();
      print("Fetched ${snapshot.docs.length} banner images");
      
      if (snapshot.docs.isEmpty) {
        return [];
      }
      
      return snapshot.docs
          .where((doc) => doc.data().containsKey('imgurl') && doc['imgurl'] != null)
          .map((doc) => doc['imgurl'] as String)
          .toList();
    } catch (e) {
      print("Error fetching banner images: $e");
      rethrow;
    }
  }
}