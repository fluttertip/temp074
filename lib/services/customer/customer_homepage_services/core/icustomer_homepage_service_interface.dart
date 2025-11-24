import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/models/user_model.dart';

abstract class ICustomerHomeService {
  Future<List<String>> fetchBannerImages();

  Future<List<UserModel>> fetchLocalExperts(String location);

  Future<List<ServiceWithProviderModel>> fetchRecommendedServicesWithProvider({
    int limit,
    DocumentSnapshot? lastDocument,
  });
  Future<List<ServiceWithProviderModel>> fetchPopularServicesWithProvider({
    int limit,
    DocumentSnapshot? lastDocument,
  });
  Future<List<ServiceWithProviderModel>> fetchTopProviderServicesWithProvider({
    int limit,
    DocumentSnapshot? lastDocument,
  });
}
