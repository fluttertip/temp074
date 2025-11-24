import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/services/customer/customer_homepage_services/firebase_source/servicewithproviderfirestore_source.dart';

class TopProviderServiceWithProviderImpl {
  final ServiceWithProviderFirestoreSource _source;

  TopProviderServiceWithProviderImpl({
    ServiceWithProviderFirestoreSource? source,
  }) : _source = source ?? ServiceWithProviderFirestoreSource();

  Future<List<ServiceWithProviderModel>> fetchTopProviderServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) => _source.fetchTopProviderServicesWithProvider(
    limit: limit,
    lastDocument: lastDocument,
  );
}
