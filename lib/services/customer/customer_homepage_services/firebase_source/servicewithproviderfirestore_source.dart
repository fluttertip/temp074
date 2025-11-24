import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/models/user_model.dart';

class ServiceWithProviderFirestoreSource {
  final FirebaseFirestore _firestore;

  ServiceWithProviderFirestoreSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ServiceWithProviderModel>> fetchPopularServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('provider_services')
          .where('isActive', isEqualTo: true)
          .where('adminapprove', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit);

      // Add pagination cursor if provided
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final servicesSnapshot = await query.get();

      if (servicesSnapshot.docs.isEmpty) {
        return [];
      }

      // Batch fetch all
      final providerIds = servicesSnapshot.docs
          .map(
            (doc) => ServiceModel.fromMap(
              doc.data() as Map<String, dynamic>,
            ).providerId,
          )
          .toSet()
          .toList();

      // Fetch providers in batch 10 doc per batch
      final providersData = await _batchFetchProviders(providerIds);

      List<ServiceWithProviderModel> servicesWithProvider = [];

      for (var serviceDoc in servicesSnapshot.docs) {
        final service = ServiceModel.fromMap(
          serviceDoc.data() as Map<String, dynamic>,
        );
        final provider = providersData[service.providerId];

        if (provider != null) {
          servicesWithProvider.add(
            ServiceWithProviderModel(
              service: service,
              provider: provider,
              lastDocument: serviceDoc, // Store document for pagination
            ),
          );
        }
      }

      return servicesWithProvider;
    } catch (e) {
      throw Exception('Failed to fetch popular services with provider: $e');
    }
  }

  Future<List<ServiceWithProviderModel>> fetchRecommendedServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('provider_services')
          .where('isActive', isEqualTo: true)
          .where('adminapprove', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final servicesSnapshot = await query.get();

      if (servicesSnapshot.docs.isEmpty) {
        return [];
      }

      final providerIds = servicesSnapshot.docs
          .map(
            (doc) => ServiceModel.fromMap(
              doc.data() as Map<String, dynamic>,
            ).providerId,
          )
          .toSet()
          .toList();

      final providersData = await _batchFetchProviders(providerIds);

      List<ServiceWithProviderModel> servicesWithProvider = [];

      for (var serviceDoc in servicesSnapshot.docs) {
        final service = ServiceModel.fromMap(
          serviceDoc.data() as Map<String, dynamic>,
        );
        final provider = providersData[service.providerId];

        if (provider != null) {
          servicesWithProvider.add(
            ServiceWithProviderModel(
              service: service,
              provider: provider,
              lastDocument: serviceDoc,
            ),
          );
        }
      }

      print('Fetched ${servicesWithProvider.length} recommended services');
      print(servicesWithProvider);

      return servicesWithProvider;
    } catch (e) {
      throw Exception('Failed to fetch recommended services with provider: $e');
    }
  }

  Future<List<ServiceWithProviderModel>> fetchTopProviderServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection('provider_services')
          .where('isActive', isEqualTo: true)
          .where('adminapprove', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final servicesSnapshot = await query.get();

      if (servicesSnapshot.docs.isEmpty) {
        return [];
      }

      final providerIds = servicesSnapshot.docs
          .map(
            (doc) => ServiceModel.fromMap(
              doc.data() as Map<String, dynamic>,
            ).providerId,
          )
          .toSet()
          .toList();

      final providersData = await _batchFetchProviders(providerIds);

      List<ServiceWithProviderModel> servicesWithProvider = [];

      for (var serviceDoc in servicesSnapshot.docs) {
        final service = ServiceModel.fromMap(
          serviceDoc.data() as Map<String, dynamic>,
        );
        final provider = providersData[service.providerId];

        if (provider != null) {
          servicesWithProvider.add(
            ServiceWithProviderModel(
              service: service,
              provider: provider,
              lastDocument: serviceDoc,
            ),
          );
        }
      }

      print('Fetched ${servicesWithProvider.length} top provider services');
      print(servicesWithProvider);

      return servicesWithProvider;
    } catch (e) {
      throw Exception(
        'Failed to fetch top provider services with provider: $e',
      );
    }
  }

  Future<Map<String, UserModel>> _batchFetchProviders(
    List<String> providerIds,
  ) async {
    if (providerIds.isEmpty) return {};

    final Map<String, UserModel> providersData = {};

    for (int i = 0; i < providerIds.length; i += 10) {
      final chunk = providerIds.skip(i).take(10).toList();

      final providersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (var providerDoc in providersSnapshot.docs) {
        final provider = UserModel.fromFirestore(
          providerDoc.data(),
          providerDoc.id,
        );
        providersData[providerDoc.id] = provider;
      }
    }

    print('Fetched ${providersData.length} providers in batch');
    print(providersData);

    return providersData;
  }
}
