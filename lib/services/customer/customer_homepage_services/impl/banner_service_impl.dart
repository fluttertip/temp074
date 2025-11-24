import '../firebase_source/banner_firestore_source.dart';

class BannerServiceImpl {
  final BannerFirestoreSource _source;

  BannerServiceImpl({BannerFirestoreSource? source})
      : _source = source ?? BannerFirestoreSource();

  Future<List<String>> fetchBannerImages() => _source.fetchBannerImages();
}
