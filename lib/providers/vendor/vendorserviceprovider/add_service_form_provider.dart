import 'package:flutter/material.dart';
import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/services/vendor/vendor_services_tab_service/vendor_services_tab_page_service.dart';

class AddServiceFormProvider extends ChangeNotifier {
  final VendorServicesTabPageService _service = VendorServicesTabPageService();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategory;
  String? _selectedSubcategoryName;
  String? _selectedPricingUnit;

  List<HardcodedServicesModel> _allCategories = [];
  List<String> _availableSubcategories = [];
  List<String> _allTitles = [];
  List<String> _filteredTitles = [];
  double _minPrice = 0;
  double _maxPrice = 0;

  final List<String> pricingUnits = [
    'Per Visit',
    'Per Day',
    'Per Job',
    'Per Shift',
    'Per Session',
    'Per Project',
    'Per Event',
    'Per Delivery',
    'Per Trip',
  ];

  bool _isLoading = false;
  bool _isLoadingSubcategories = false;
  bool _isLoadingTitles = false;
  String? _error;

  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubcategoryName => _selectedSubcategoryName;
  String? get selectedPricingUnit => _selectedPricingUnit;
  List<HardcodedServicesModel> get allCategories => _allCategories;
  List<String> get availableSubcategories => _availableSubcategories;
  List<String> get allTitles => _allTitles;
  List<String> get filteredTitles => _filteredTitles;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  bool get isLoading => _isLoading;
  bool get isLoadingSubcategories => _isLoadingSubcategories;
  bool get isLoadingTitles => _isLoadingTitles;
  String? get error => _error;

  bool get isValid {
    return _selectedCategoryId != null &&
        _selectedSubcategoryName != null &&
        titleController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        _selectedPricingUnit != null &&
        descriptionController.text.trim().isNotEmpty &&
        _validatePrice();
  }

  bool _validatePrice() {
    final priceText = priceController.text.trim();
    if (priceText.isEmpty) return false;

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) return false;

    if (_minPrice > 0 && _maxPrice > 0) {
      return price >= _minPrice && price <= _maxPrice;
    }

    return true;
  }

  Future<void> initializeForm() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allCategories = await _service.getHardcodedServices();
      _selectedPricingUnit = pricingUnits.first;
    } catch (e) {
      _error = 'Failed to load categories: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(String categoryId) async {
    if (_selectedCategoryId == categoryId) return;

    final category = _allCategories.firstWhere((cat) => cat.id == categoryId);

    _selectedCategoryId = categoryId;
    _selectedCategory = category.category;
    _selectedSubcategoryName = null;
    _availableSubcategories.clear();
    _allTitles.clear();
    _filteredTitles.clear();
    titleController.clear();
    descriptionController.clear();
    priceController.clear();

    notifyListeners();

    await _loadSubcategories(categoryId);
    await _loadPriceRange(category);
  }

  Future<void> _loadSubcategories(String categoryId) async {
    _isLoadingSubcategories = true;
    notifyListeners();

    try {
      final category = _allCategories.firstWhere((cat) => cat.id == categoryId);

      final uniqueSubcategories = <String>{};
      for (final serviceSubcategory in category.subcategories) {
        if (serviceSubcategory.isActive &&
            serviceSubcategory.subcategory.isNotEmpty) {
          uniqueSubcategories.add(serviceSubcategory.subcategory);
        }
      }

      _availableSubcategories = uniqueSubcategories.toList()..sort();
    } catch (e) {
      _error = 'Failed to load subcategories: ${e.toString()}';
    } finally {
      _isLoadingSubcategories = false;
      notifyListeners();
    }
  }

  Future<void> _loadPriceRange(HardcodedServicesModel category) async {
    try {
      _minPrice = category.metadata.priceRange.min;
      _maxPrice = category.metadata.priceRange.max;

      if (_minPrice > 0) {
        priceController.text = _minPrice.toStringAsFixed(0);
      }
    } catch (e) {
      _error = 'Failed to load price range: ${e.toString()}';
    }
    notifyListeners();
  }

  Future<void> selectSubcategory(String subcategoryName) async {
    if (_selectedSubcategoryName == subcategoryName) return;

    _selectedSubcategoryName = subcategoryName;

    titleController.clear();
    _allTitles.clear();
    _filteredTitles.clear();

    await _loadAutoDescription(subcategoryName);
    await _loadAllTitles();
    notifyListeners();
  }

  Future<void> _loadAutoDescription(String subcategoryName) async {
    try {
      final category = _allCategories.firstWhere(
        (cat) => cat.id == _selectedCategoryId,
      );

      final serviceInSubcategory = category.subcategories.firstWhere(
        (service) =>
            service.subcategory == subcategoryName &&
            service.description.isNotEmpty,
        orElse: () => category.subcategories.first,
      );

      if (serviceInSubcategory.description.isNotEmpty) {
        descriptionController.text = serviceInSubcategory.description;
      }
    } catch (e) {
      descriptionController.clear();
    }
  }

  Future<void> _loadAllTitles() async {
    if (_selectedCategoryId == null || _selectedSubcategoryName == null) return;

    _isLoadingTitles = true;
    notifyListeners();

    try {
      final category = _allCategories.firstWhere(
        (cat) => cat.id == _selectedCategoryId,
      );

      final titlesInSubcategory = <String>{};
      for (final service in category.subcategories) {
        if (service.isActive &&
            service.subcategory == _selectedSubcategoryName) {
          titlesInSubcategory.add(service.name);
        }
      }

      final existingTitles = await _service.searchServiceTitles(
        categoryId: _selectedCategoryId!,
        subcategoryId: _selectedSubcategoryName!,
        query: '',
      );

      titlesInSubcategory.addAll(existingTitles);

      _allTitles = titlesInSubcategory.toList()..sort();
      _filteredTitles = List.from(_allTitles);
    } catch (e) {
      _allTitles.clear();
      _filteredTitles.clear();
    } finally {
      _isLoadingTitles = false;
      notifyListeners();
    }
  }

  void filterTitles(String query) {
    if (query.isEmpty) {
      _filteredTitles = List.from(_allTitles);
    } else {
      _filteredTitles = _allTitles
          .where((title) => title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void selectTitle(String title) {
    titleController.text = title;
    notifyListeners();
  }

  void selectPricingUnit(String unit) {
    _selectedPricingUnit = unit;
    notifyListeners();
  }

  String? validateForm() {
    if (_selectedCategoryId == null) return 'Please select a service category';
    if (_selectedSubcategoryName == null) {
      return 'Please select a service subcategory';
    }
    if (titleController.text.trim().isEmpty) {
      return 'Please enter a service title';
    }
    if (priceController.text.trim().isEmpty) return 'Please enter a price';
    if (_selectedPricingUnit == null) return 'Please select a pricing unit';
    if (descriptionController.text.trim().isEmpty) {
      return 'Please enter a description';
    }

    final price = double.tryParse(priceController.text);
    if (price == null || price <= 0) return 'Please enter a valid price';

    if (_minPrice > 0 &&
        _maxPrice > 0 &&
        (price < _minPrice || price > _maxPrice)) {
      return 'Price must be between NPR ${_minPrice.toStringAsFixed(0)} and NPR ${_maxPrice.toStringAsFixed(0)}';
    }

    return null;
  }

  ServiceModel createServiceModel(String providerId) {
    final price = double.parse(priceController.text);

    final category = _allCategories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
    );
    final serviceInSubcategory = category.subcategories.firstWhere(
      (service) => service.subcategory == _selectedSubcategoryName,
      orElse: () => category.subcategories.first,
    );

    return ServiceModel(
      id: '',
      providerId: providerId,
      category: _selectedCategory!,
      title: titleController.text.trim(),
      imageUrl: serviceInSubcategory.imageUrl.isEmpty
          ? "https://dummyimage.com/600x400/4A90E2/FFFFFF?text=Service"
          : serviceInSubcategory.imageUrl,
      price: price,
      rating: '0.0',
      description: descriptionController.text.trim(),
      isActive: true,
      admindelete: false,
      adminapprove: false,
      createdAt: DateTime.now(),
    );
  }

  void clearForm() {
    titleController.clear();
    priceController.clear();
    descriptionController.clear();

    _selectedCategoryId = null;
    _selectedCategory = null;
    _selectedSubcategoryName = null;
    _selectedPricingUnit = pricingUnits.first;

    _availableSubcategories.clear();
    _allTitles.clear();
    _filteredTitles.clear();
    _minPrice = 0;
    _maxPrice = 0;
    _error = null;

    notifyListeners();
  }

  void onFieldChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
