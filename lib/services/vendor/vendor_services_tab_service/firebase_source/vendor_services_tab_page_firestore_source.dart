import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';

class VendorServicesTabPageFirestoreSource {
  final FirebaseFirestore _firestore;

  VendorServicesTabPageFirestoreSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ServiceModel>> fetchProviderServices(String providerId) async {
    try {
      final snapshot = await _firestore
          .collection('provider_services')
          .where('providerId', isEqualTo: providerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch provider services: $e');
    }
  }

  Future<List<HardcodedServicesModel>> fetchHardcodedServicesInfo() async {
    try {
      final snapshot = await _firestore
          .collection('hardcoded_services_info')
          .where('isActive', isEqualTo: true)
          .orderBy('category')
          .get();

      return snapshot.docs
          .map((doc) => HardcodedServicesModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch hardcoded services info: $e');
    }
  }

  Future<void> addProviderService(ServiceModel service) async {
    try {
      final docRef = _firestore.collection('provider_services').doc();
      final serviceWithId = ServiceModel(
        id: docRef.id,
        providerId: service.providerId,
        category: service.category,
        title: service.title,
        imageUrl: service.imageUrl,
        price: service.price,
        description: service.description,
        isActive: service.isActive,
        admindelete: service.admindelete,
        adminapprove: service.adminapprove,
        createdAt: service.createdAt,
        rating: service.rating,
      );
      await docRef.set(serviceWithId.toMap());
    } catch (e) {
      throw Exception('Failed to add provider service: $e');
    }
  }

  Future<void> updateProviderService(ServiceModel service) async {
    try {
      await _firestore
          .collection('provider_services')
          .doc(service.id)
          .update(service.toMap());
    } catch (e) {
      throw Exception('Failed to update provider service: $e');
    }
  }

  Future<void> deleteProviderService(String serviceId) async {
    try {
      await _firestore.collection('provider_services').doc(serviceId).delete();
    } catch (e) {
      throw Exception('Failed to delete provider service: $e');
    }
  }

  Future<List<String>> searchServiceTitles({
    required String categoryId,
    required String subcategoryId,
    required String query,
  }) async {
    try {
      Query queryRef = _firestore
          .collection('provider_services')
          .where('category', isEqualTo: categoryId)
          .where('isActive', isEqualTo: true)
          .limit(50);

      final querySnapshot = await queryRef.get();

      final titles = <String>{};

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final title = data['title'] as String?;
        final serviceSubcategory = data['subcategory'] as String?;

        if (title != null && serviceSubcategory == subcategoryId) {
          if (query.isEmpty ||
              title.toLowerCase().contains(query.toLowerCase())) {
            titles.add(title);
          }
        }
      }

      return titles.toList()..sort();
    } catch (e) {
      throw Exception('Failed to search service titles: ${e.toString()}');
    }
  }
}
