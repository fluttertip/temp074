import '../firebase_source/expert_locality_firestore_source.dart';
import 'package:homeservice/models/user_model.dart';

class ExpertLocalityServiceImpl {
  final ExpertLocalityFirestoreSource _source;

  ExpertLocalityServiceImpl({ExpertLocalityFirestoreSource? source})
    : _source = source ?? ExpertLocalityFirestoreSource();

  Future<List<UserModel>> fetchExpertsByLocation(String location) {
    return _source.fetchExpertsByLocation(location);
  }
}
