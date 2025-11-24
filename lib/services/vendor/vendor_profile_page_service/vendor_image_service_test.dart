import 'dart:io';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();

  factory ImageUploadService() {
    return _instance;
  }

  ImageUploadService._internal();

  /// should return url after implementation
  ///
  Future<String?> uploadProfilePhoto(File imageFile, String userId) async {
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('profile_photos')
    //     .child('$userId.jpg');
    //
    // final uploadTask = ref.putFile(imageFile);
    // final snapshot = await uploadTask;
    // return await snapshot.ref.getDownloadURL();

    //mimicking services
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://temporary-url-placeholder.com/profile_$userId.jpg';
  }

  Future<String?> uploadCoverPhoto(File imageFile, String userId) async {
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('cover_photos')
    //     .child('$userId.jpg');
    //
    // final uploadTask = ref.putFile(imageFile);
    // final snapshot = await uploadTask;
    // return await snapshot.ref.getDownloadURL();

    // Temporary placeholder
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://temporary-url-placeholder.com/cover_$userId.jpg';
  }

  Future<String?> uploadKycDocument(
    File imageFile,
    String userId,
    bool isFront,
  ) async {
    // final side = isFront ? 'front' : 'back';
    // final ref = FirebaseStorage.instance
    //     .ref()
    //     .child('kyc_documents')
    //     .child(userId)
    //     .child('citizenship_$side.jpg');
    //
    // final uploadTask = ref.putFile(imageFile);
    // final snapshot = await uploadTask;
    // return await snapshot.ref.getDownloadURL();

    //mimicking services
    await Future.delayed(const Duration(milliseconds: 500));
    final side = isFront ? 'front' : 'back';
    return 'https://temporary-url-placeholder.com/kyc_${userId}_$side.jpg';
  }

  Future<bool> deleteImage(String imageUrl) async {
    // try {
    //   final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    //   await ref.delete();
    //   return true;
    // } catch (e) {
    //   return false;
    // }
    //mimicking services
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  bool validateImage(File imageFile) {
    final fileSizeInBytes = imageFile.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 5) {
      return false;
    }

    final fileName = imageFile.path.toLowerCase();
    final allowedExtensions = ['.jpg', '.jpeg', '.png'];

    return allowedExtensions.any((ext) => fileName.endsWith(ext));
  }

  int getOptimizedQuality(File imageFile) {
    final fileSizeInBytes = imageFile.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 3) return 70;
    if (fileSizeInMB > 1.5) return 80;
    return 85;
  }
}
