import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/services/customer/customer_homepage_services/impl/expert_locality_service_impl.dart';
import 'package:homeservice/services/customer/customer_homepage_services/impl/popular_service_with_provider_impl.dart';
import 'package:homeservice/services/customer/customer_homepage_services/impl/recommend_service_with_provider_impl.dart';
import 'package:homeservice/services/customer/customer_homepage_services/impl/top_provider_service_with_provider_impl.dart';
import 'core/icustomer_homepage_service_interface.dart';
import 'impl/banner_service_impl.dart';

class CustomerHomeService implements ICustomerHomeService {
  final BannerServiceImpl _bannerService;
  final ExpertLocalityServiceImpl _expertlocalityService;
  final RecommendServiceWithProviderImpl _recommendServiceWithProvider;
  final PopularServiceWithProviderImpl _popularServiceWithProvider;
  final TopProviderServiceWithProviderImpl _topProviderServiceWithProvider;

  CustomerHomeService({
    BannerServiceImpl? bannerService,
    ExpertLocalityServiceImpl? expertlocalityService,
    RecommendServiceWithProviderImpl? recommendServiceWithProvider,
    PopularServiceWithProviderImpl? popularServiceWithProvider,
    TopProviderServiceWithProviderImpl? topProviderServiceWithProvider,
  }) : _bannerService = bannerService ?? BannerServiceImpl(),
       _expertlocalityService =
           expertlocalityService ?? ExpertLocalityServiceImpl(),
       _recommendServiceWithProvider =
           recommendServiceWithProvider ?? RecommendServiceWithProviderImpl(),
       _popularServiceWithProvider =
           popularServiceWithProvider ?? PopularServiceWithProviderImpl(),
       _topProviderServiceWithProvider =
           topProviderServiceWithProvider ??
           TopProviderServiceWithProviderImpl();

  @override
  Future<List<String>> fetchBannerImages() async {
    try {
      return await _bannerService.fetchBannerImages();
    } catch (e) {
      throw Exception('Failed to fetch banner images: $e');
    }
  }

  @override
  Future<List<UserModel>> fetchLocalExperts(String location) async {
    try {
      return await _expertlocalityService.fetchExpertsByLocation(location);
    } catch (e) {
      throw Exception('Failed to fetch local experts: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> fetchRecommendedServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _recommendServiceWithProvider
          .fetchRecommendedServicesWithProvider(
            limit: limit,
            lastDocument: lastDocument,
          );
    } catch (e) {
      throw Exception('Failed to fetch recommended services with provider: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> fetchPopularServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _popularServiceWithProvider.fetchPopularServicesWithProvider(
        limit: limit,
        lastDocument: lastDocument,
      );
    } catch (e) {
      throw Exception('Failed to fetch popular services with provider: $e');
    }
  }

  @override
  Future<List<ServiceWithProviderModel>> fetchTopProviderServicesWithProvider({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _topProviderServiceWithProvider
          .fetchTopProviderServicesWithProvider(
            limit: limit,
            lastDocument: lastDocument,
          );
    } catch (e) {
      throw Exception(
        'Failed to fetch top provider services with provider: $e',
      );
    }
  }
}
