import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isGoogleInitialized = false;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authEventsSubscription;

  // Web client ID
  static const String _webClientId =
      '348922347003-m5s12n1tq3ba5sqrdkvi338g3natv2cb.apps.googleusercontent.com';

  // Server client ID for Android/iOS
  // Use the same web client ID for Android
  static String? get _serverClientId => kIsWeb ? null : _webClientId;

  // ---------------- Core Firebase Methods ----------------

  Future<User?> getCurrentUser() async => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserModel?> getLatestUserData(String uid) async {
    try {
      final userData = await _firestore.collection('users').doc(uid).get();
      if (!userData.exists || userData.data() == null) return null;
      return UserModel.fromFirestore(userData.data()!, uid);
    } catch (e) {
      print('Get latest user data error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> initializeUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        await _createUserDocument(firebaseUser);
      }

      final userData = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userData.exists || userData.data() == null) {
        throw Exception('User document not found after creation');
      }

      final userModel = UserModel.fromFirestore(userData.data()!, firebaseUser.uid);

      return {
        'user': userModel,
        'activeRole': userModel.activeRole,
        'availableRoles': userModel.role,
      };
    } catch (e) {
      print('Initialize user error: $e');
      rethrow;
    }
  }

Future<void> signOut() async {
  try {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.disconnect().catchError((_) => null), // Handle gracefully
    ]);
  } catch (e) {
    print('Sign out error: $e');
    rethrow;
  }
}

  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'activeRole': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Update user role error: $e');
      rethrow;
    }
  }

  Future<void> _createUserDocument(User firebaseUser) async {
    try {
      final initialUser = UserModel.initial(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'User',
      );

      final data = initialUser.toFirestore();
      data['profilePhotoUrl'] = firebaseUser.photoURL;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(firebaseUser.uid).set(data);
      print('User document created successfully for ${firebaseUser.uid}');
    } catch (e) {
      print('Create user document error: $e');
      try {
        await firebaseUser.delete();
        print('Firebase Auth user deleted after document creation failure');
      } catch (deleteError) {
        print('Failed to cleanup Firebase Auth user: $deleteError');
      }
      rethrow;
    }
  }

  // ------------------- Google Sign-In (v7.2.0) -------------------

  Future<void> _initializeGoogle() async {
    if (_isGoogleInitialized) return;

    try {
      await _googleSignIn.initialize(
        clientId: _webClientId,
        serverClientId: _serverClientId,// Will be null for Web, populated for Android
      );

      // Listen to authentication events
      _authEventsSubscription =
          _googleSignIn.authenticationEvents.listen((event) {}, onError: (error) {
        print('Google authentication error: $error');
      });

      // Attempt lightweight authentication
      _googleSignIn.attemptLightweightAuthentication();

      _isGoogleInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Disconnect previous sessions
      await _googleSignIn.disconnect().catchError((_) {});
      print('⚡ [GoogleSignIn] Previous sessions cleared');
      
      if (!_isGoogleInitialized && !kIsWeb) await _initializeGoogle();

      UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        if (!_googleSignIn.supportsAuthenticate()) {
          throw Exception('Platform does not support authenticate()');
        }

        final account = await _googleSignIn.authenticate();
        final auth = account.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken,
          accessToken: auth.idToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Firebase user is null after sign in');

      // Create user document if new
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) await _createUserDocument(firebaseUser);

      // Fetch user data
      final userData = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userData.exists || userData.data() == null) {
        throw Exception('User document not found after creation');
      }

      final userModel = UserModel.fromFirestore(userData.data()!, firebaseUser.uid);

      return {
        'user': userModel,
        'activeRole': userModel.activeRole,
        'availableRoles': userModel.role,
      };
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  void dispose() {
    _authEventsSubscription?.cancel();
  }
}

