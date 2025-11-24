import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/user_model.dart';

class ExpertLocalityFirestoreSource {
  final FirebaseFirestore _firestore;

  ExpertLocalityFirestoreSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<UserModel>> fetchExpertsByLocation(String location) async {
    try {
      final expertSnapshot = await _firestore
          .collection('expert_in_locality')
          .where('location', isEqualTo: location.toLowerCase())
          .get();

      final List<UserModel> experts = [];

      for (final doc in expertSnapshot.docs) {
        final providerId = doc['providerId'];
        final userDoc = await _firestore
            .collection('users')
            .doc(providerId)
            .get();

        if (userDoc.exists) {
          experts.add(UserModel.fromFirestore(userDoc.data()!, userDoc.id));
        }
      }

      print('Fetched ${experts.length} experts for location: $location');

      return experts;
    } catch (e) {
      print('Error fetching experts: $e');
      rethrow;
    }
  }
}
