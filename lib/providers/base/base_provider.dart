import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Sets loading state with safety checks
  void setLoading(bool loading) {
    if (_isDisposed) return;
    
    if (_isLoading != loading) {
      _isLoading = loading;
      _safeNotifyListeners();
    }
  }

  /// Sets error state with safety checks
  void setError(String error) {
    if (_isDisposed) return;
    
    if (_error != error) {
      _error = error;
      _safeNotifyListeners();
    }
  }

  /// Clears error state with safety checks
  void clearError() {
    if (_isDisposed) return;
    
    if (_error != null) {
      _error = null;
      _safeNotifyListeners();
    }
  }

  /// Safely notifies listeners only if there are active listeners
  void _safeNotifyListeners() {
    if (!_isDisposed && hasListeners) {
      notifyListeners();
    }
  }

  /// Resets provider to initial state
  void reset() {
    if (_isDisposed) return;
    
    _isLoading = false;
    _error = null;
    _safeNotifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}