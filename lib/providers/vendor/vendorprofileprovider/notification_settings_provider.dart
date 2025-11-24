import 'package:flutter/material.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _showOnline = true;
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get showOnline => _showOnline;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  void initializeSettings({
    required bool email,
    required bool push,
    required bool online,
  }) {
    if (!_isInitialized) {
      _emailNotifications = email;
      _pushNotifications = push;
      _showOnline = online;
      _isInitialized = true;
    }
  }

  void updateEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void updatePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void updateShowOnline(bool value) {
    _showOnline = value;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Map<String, bool> getNotificationSettings() {
    return {'email': _emailNotifications, 'push': _pushNotifications};
  }

  Map<String, dynamic> getPreferences() {
    return {'showOnline': _showOnline};
  }
}
