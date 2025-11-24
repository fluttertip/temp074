import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/services/customer/customer_homepage_services/firebase_source/servicewithproviderfirestore_source.dart';

class RecommendServiceWithProviderImpl {
  final ServiceWithProviderFirestoreSource _source;

  RecommendServiceWithProviderImpl({ServiceWithProviderFirestoreSource? source})
    : _source = source ?? ServiceWithProviderFirestoreSource();

  Future<List<ServiceWithProviderModel>> fetchRecommendedServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) => _source.fetchRecommendedServicesWithProvider(
    limit: limit,
    lastDocument: lastDocument,
  );
}
