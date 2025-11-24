import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/base/base_provider.dart';
import 'package:homeservice/services/auth/auth_service.dart';
import 'dart:async';

class UserProvider extends BaseProvider {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isAuthenticated = false;
  String? _activeRole;
  List<String> _availableRoles = [];
  bool _isRoleSwitching = false;
  StreamSubscription<dynamic>? _authStateSubscription;

  // UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String? get activeRole => _activeRole;
  List<String> get availableRoles => _availableRoles;
  bool get isRoleSwitching => _isRoleSwitching;
   UserModel? getCachedUser() => _user;

  UserProvider() {
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authStateSubscription = _authService.authStateChanges().listen((user) async {
      if (user == null && _isAuthenticated) {
        print('⚡ [UserProvider] User signed out detected');
        await _handleSignOut();
      } else if (user != null && !_isAuthenticated) {
        print('⚡ [UserProvider] User signed in detected');
        await initializeAuth();
      }
    });
  }
  
Future<bool> switchActiveRole(String newRole) async {
  if (!_availableRoles.contains(newRole) || _activeRole == newRole) {
    print('⚠️ [RoleSwitch] Attempted invalid role switch to "$newRole"');
    return false;
  }

  _isRoleSwitching = true;
  notifyListeners();

  try {
    print('🔄 [RoleSwitch] Switching role to "$newRole"...');
    await _authService.updateUserRole(_user!.uid, newRole);

    _activeRole = newRole;
    _user = _user!.copyWith(activeRole: newRole);
    _isRoleSwitching = false;

    print('✅ [RoleSwitch] Role successfully switched to "$newRole"');
    notifyListeners();

    return true;
  } catch (e) {
    print('❌ [RoleSwitch] Failed to switch role: $e');
    setError('Failed to switch role: $e');
    _isRoleSwitching = false;
    notifyListeners();
    return false;
  }
}

Future<void> initializeAuth() async {
  setLoading(true);
  clearError();

  print('⚡ [AuthInit] Starting authentication initialization...');

  try {
    final result = await _authService.initializeUser();

    if (result == null) {
      _isAuthenticated = false;
      _user = null;
      _activeRole = null;
      _availableRoles = [];
      print('⚠️ [AuthInit] No user found');
    } else {
      _user = result['user'] as UserModel;
      _activeRole = result['activeRole'] as String;
      _availableRoles = result['availableRoles'] as List<String>;
      _isAuthenticated = true;
      print('✅ [AuthInit] User initialized: ${_user!.name} (${_user!.uid})');
      print('    🔹 Active role: $_activeRole');
      print('    🔹 Available roles: $_availableRoles');
    }
  } catch (e) {
    print('❌ [AuthInit] Error initializing authentication: $e');
    setError('Failed to initialize authentication: $e');
    _isAuthenticated = false;
    _user = null;
    _activeRole = null;
    _availableRoles = [];
  } finally {
    setLoading(false);
    print('⚡ [AuthInit] Authentication initialization complete.');
  }
}

Future<UserModel?> refreshUserData() async {
  if (!_isAuthenticated || _user?.uid == null) {
    print('⚠️ [UserRefresh] Cannot refresh, no authenticated user');
    return null;
  }

  try {
    print('🔄 [UserRefresh] Fetching latest user data for ${_user!.uid}...');
    final latestUser = await _authService.getLatestUserData(_user!.uid);
    if (latestUser != null) {
      _user = latestUser;
      _activeRole = latestUser.activeRole;
      _availableRoles = latestUser.role;
      print('✅ [UserRefresh] User data refreshed successfully');
      print('    🔹 Active role: $_activeRole');
      print('    🔹 Available roles: $_availableRoles');
      notifyListeners();
    }
    return latestUser;
  } catch (e) {
    print('❌ [UserRefresh] Failed to refresh user data: $e');
    setError('Failed to refresh user data: $e');
    return _user;
  }
}

Future<bool> signInWithGoogle() async {
  setLoading(true);
  clearError();
  print('⚡ [GoogleSignIn] Starting Google sign-in...');

  try {
    final result = await _authService.signInWithGoogle();

    if (result != null) {
      _user = result['user'] as UserModel;
      _activeRole = result['activeRole'] as String;
      _availableRoles = result['availableRoles'] as List<String>;
      _isAuthenticated = true;

      print('✅ [GoogleSignIn] Sign-in successful: ${_user!.name} (${_user!.uid})');
      print('    🔹 Active role: $_activeRole');
      print('    🔹 Available roles: $_availableRoles');

      setLoading(false);
      return true;
    } else {
      print('⚠️ [GoogleSignIn] Sign-in cancelled by user');
      setError('Sign in cancelled');
      setLoading(false);
      return false;
    }
  } catch (e) {
    print('❌ [GoogleSignIn] Error during sign-in: $e');
    setLoading(false);
    setError('Sign-in failed: $e');
    return false;
  }
}

Future<void> signOut() async {
  setLoading(true);
  print('⚡ [SignOut] Signing out user...');
  try {
    await _authService.signOut();
    await _handleSignOut();
    print('✅ [SignOut] User signed out successfully');
  } catch (e) {
    print('❌ [SignOut] Error signing out: $e');
    setError('Failed to sign out: $e');
  } finally {
    setLoading(false);
  }
}


  Future<void> _handleSignOut() async {
    _user = null;
    _isAuthenticated = false;
    _activeRole = null;
    _availableRoles = [];
    clearError();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

