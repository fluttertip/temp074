import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/services/customer/customer_homepage_services/firebase_source/servicewithproviderfirestore_source.dart';

class PopularServiceWithProviderImpl {
  final ServiceWithProviderFirestoreSource _source;

  PopularServiceWithProviderImpl({ServiceWithProviderFirestoreSource? source})
    : _source = source ?? ServiceWithProviderFirestoreSource();

  Future<List<ServiceWithProviderModel>> fetchPopularServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) => _source.fetchPopularServicesWithProvider(
    limit: limit,
    lastDocument: lastDocument,
  );
}
