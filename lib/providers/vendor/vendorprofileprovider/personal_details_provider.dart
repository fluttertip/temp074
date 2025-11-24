import 'package:flutter/material.dart';

class PersonalDetailsProvider extends ChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  bool _isInitialized = false;

  TextEditingController get nameController => _nameController;
  TextEditingController get aboutMeController => _aboutMeController;
  TextEditingController get addressController => _addressController;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  void initializeControllers({
    required String name,
    required String aboutMe,
    required String address,
  }) {
    if (!_isInitialized) {
      _nameController.text = name;
      _aboutMeController.text = aboutMe;
      _addressController.text = address;
      _isInitialized = true;
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool validateForm() {
    return _nameController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutMeController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
