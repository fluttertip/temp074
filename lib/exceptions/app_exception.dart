class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? data;

  AppException(this.message, {this.code, this.data});

  @override
  String toString() => "AppException: $message (${code ?? 'UNKNOWN'})";
}

class NetworkException extends AppException {
  NetworkException(super.message) : super(code: 'NETWORK_ERROR');
}

class ValidationException extends AppException {
  ValidationException(super.message) : super(code: 'VALIDATION_ERROR');
}

class AuthException extends AppException {
  AuthException(super.message, {String? code, super.data})
    : super(code: code ?? 'AUTH_ERROR');
}

class FirestoreException extends AppException {
  FirestoreException(super.message) : super(code: 'FIRESTORE_ERROR');
}

// Specific Authentication Exceptions
class UserNotFoundException extends AuthException {
  UserNotFoundException(super.message)
    : super(code: 'USER_NOT_FOUND');
}

class InvalidPasswordException extends AuthException {
  InvalidPasswordException(super.message)
    : super(code: 'INVALID_PASSWORD');
}

class UserExistsException extends AuthException {
  UserExistsException(super.message) : super(code: 'USER_EXISTS');
}

class OtpVerificationException extends AuthException {
  OtpVerificationException(super.message, {String? code})
    : super(code: code ?? 'OTP_VERIFICATION_FAILED');
}

class GoogleSignInException extends AuthException {
  GoogleSignInException(super.message, {String? code})
    : super(code: code ?? 'GOOGLE_SIGN_IN_ERROR');
}

// Auth Success Data Class (for successful operations)
class AuthSuccessData {
  final Map<String, dynamic> userData;
  final String userId;

  AuthSuccessData({required this.userData, required this.userId});

  @override
  String toString() => 'AuthSuccessData(userId: $userId)';
}
