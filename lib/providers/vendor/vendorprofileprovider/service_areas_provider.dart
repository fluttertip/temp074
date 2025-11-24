import 'package:flutter/material.dart';

class ServiceAreasProvider extends ChangeNotifier {
  final TextEditingController _newAreaController = TextEditingController();
  List<String> _areas = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  TextEditingController get newAreaController => _newAreaController;
  List<String> get areas => List.unmodifiable(_areas);
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  void initializeAreas(List<String> initialAreas) {
    if (!_isInitialized) {
      _areas = List.from(initialAreas);
      _isInitialized = true;
      notifyListeners();
    }
  }

  void addArea() {
    final area = _newAreaController.text.trim();
    if (area.isNotEmpty && !_areas.contains(area)) {
      _areas.add(area);
      _newAreaController.clear();
      notifyListeners();
    }
  }

  void removeArea(String area) {
    _areas.remove(area);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _newAreaController.dispose();
    super.dispose();
  }
}
