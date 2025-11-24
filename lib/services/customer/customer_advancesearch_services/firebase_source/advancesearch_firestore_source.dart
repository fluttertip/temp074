import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/models/user_model.dart';

class AdvanceSearchFirestoreSource {
  final FirebaseFirestore _firestore;

  AdvanceSearchFirestoreSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ServiceWithProviderModel>> searchServices({
    required String query,
    List<String>? selectedFilters,
    int limit = 100,
  }) async {
    try {
      Query baseQuery = _firestore
          .collection('provider_services')
          .where('isActive', isEqualTo: true)
          .where('adminapprove', isEqualTo: true);

      final servicesSnapshot = await baseQuery.limit(limit).get();

      if (servicesSnapshot.docs.isEmpty) {
        return [];
      }

      final List<QueryDocumentSnapshot> textFilteredDocs = servicesSnapshot.docs
          .where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final title = (data['title'] ?? '').toString().toLowerCase();
            final description = (data['description'] ?? '')
                .toString()
                .toLowerCase();
            final searchLower = query.toLowerCase();

            return title.contains(searchLower) ||
                description.contains(searchLower);
          })
          .toList();

      if (textFilteredDocs.isEmpty) {
        return [];
      }

      final providerIds = textFilteredDocs
          .map(
            (doc) => ServiceModel.fromMap(
              doc.data() as Map<String, dynamic>,
            ).providerId,
          )
          .toSet()
          .toList();

      final providersData = await _batchFetchProviders(providerIds);

      List<ServiceWithProviderModel> servicesWithProvider = [];

      for (var serviceDoc in textFilteredDocs) {
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

      return servicesWithProvider;
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }

  Future<Map<String, UserModel>> _batchFetchProviders(
    List<String> providerIds,
  ) async {
    if (providerIds.isEmpty) return {};

    final Map<String, UserModel> providersData = {};

    for (int i = 0; i < providerIds.length; i += 10) {
      final chunk = providerIds.skip(i).take(10).toList();

      try {
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
      } catch (e) {
        print('Error fetching providers chunk: $e');
      }
    }

    return providersData;
  }
}
