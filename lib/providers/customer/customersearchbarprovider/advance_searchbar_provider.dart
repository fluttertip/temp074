import 'package:flutter/material.dart';
import 'dart:async';

import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/services/customer/customer_advancesearch_services/customer_advancesearch_services.dart';

class CustomerAdvanceSearchProvider extends ChangeNotifier {
  final CustomerAdvanceSearchServices _searchService =
      CustomerAdvanceSearchServices();

  List<ServiceWithProviderModel> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';

  // Debouncing
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  // Caching for internal filter
  List<ServiceWithProviderModel> _allFetchedResults = [];
  String _lastSearchQuery = '';

  // Filter state
  final Map<String, String?> _selectedFiltersByGroup = {
    'Category': null,
    'Rating': null,
    'Price Range': null,
  };

  bool _showFilters = false;

  final Map<String, List<String>> _filterOptions = const {
    'Category': [
      'Cleaning Services',
      'Plumbing Services',
      'Electrical Services',
      'Painting Services',
      'Repair Services',
      'Moving Services',
      'Handyman Services',
    ],
    'Rating': ['4.5+ Stars', '4.0+ Stars', '3.5+ Stars', '3.0+ Stars'],
    'Price Range': [
      'Under Rs. 500',
      'Rs. 500 - Rs. 1000',
      'Rs. 1000 - Rs. 2000',
      'Above Rs. 2000',
    ],
  };

  List<ServiceWithProviderModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  bool get showFilters => _showFilters;
  Map<String, List<String>> get filterOptions => _filterOptions;
  List<String> get selectedFilters => _selectedFiltersByGroup.values
      .whereType<String>()
      .toList(growable: false);
  Map<String, String?> get selectedFiltersByGroup => _selectedFiltersByGroup;
  int get selectedFiltersCount =>
      _selectedFiltersByGroup.values.whereType<String>().length;

  // SIMPLIFIED: Firebase on every search, internal filtering
  Future<void> searchServices(String query) async {
    if (query.trim().isEmpty) {
      _clearSearchResults();
      return;
    }

    //cancel previous timer
    _debounceTimer?.cancel();
    // set up new debounce timer
    _debounceTimer = Timer(_debounceDelay, () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      _clearSearchResults();
      return;
    }

    _isSearching = true;
    _searchQuery = query;
    notifyListeners();

    try {
      if (query != _lastSearchQuery) {
        await _fetchFromFirebase(query);
        _lastSearchQuery = query;
      }

      // internal filter ot cachequery
      _applyInternalFilters();
    } catch (e) {
      _searchResults = [];
      print('Search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFromFirebase(String query) async {
    final results = await _searchService.searchServices(
      query: query,
      selectedFilters: [],
    );

    _allFetchedResults = results;
  }

  void _applyInternalFilters() {
    if (_allFetchedResults.isEmpty) {
      _searchResults = [];
      return;
    }

    final textFiltered = _allFetchedResults.where((service) {
      final title = service.service.title.toLowerCase();
      final description = service.service.description.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();

      return title.contains(searchLower) || description.contains(searchLower);
    }).toList();

    _searchResults = textFiltered.where((service) {
      return _matchesCategoryFilter(service) &&
          _matchesRatingFilter(service) &&
          _matchesPriceFilter(service);
    }).toList();
  }

  bool _matchesCategoryFilter(ServiceWithProviderModel service) {
    final categoryFilter = _selectedFiltersByGroup['Category'];
    if (categoryFilter == null) return true;

    return service.service.category == categoryFilter;
  }

  bool _matchesRatingFilter(ServiceWithProviderModel service) {
    final ratingFilter = _selectedFiltersByGroup['Rating'];
    if (ratingFilter == null) return true;

    final serviceRating =
        double.tryParse(service.service.rating.toString()) ?? 0.0;

    switch (ratingFilter) {
      case '4.5+ Stars':
        return serviceRating >= 4.5;
      case '4.0+ Stars':
        return serviceRating >= 4.0;
      case '3.5+ Stars':
        return serviceRating >= 3.5;
      case '3.0+ Stars':
        return serviceRating >= 3.0;
      default:
        return true;
    }
  }

  bool _matchesPriceFilter(ServiceWithProviderModel service) {
    final priceFilter = _selectedFiltersByGroup['Price Range'];
    if (priceFilter == null) return true;

    final price = service.service.price.toDouble();

    switch (priceFilter) {
      case 'Under Rs. 500':
        return price < 500;
      case 'Rs. 500 - Rs. 1000':
        return price >= 500 && price <= 1000;
      case 'Rs. 1000 - Rs. 2000':
        return price >= 1000 && price <= 2000;
      case 'Above Rs. 2000':
        return price > 2000;
      default:
        return true;
    }
  }

  void _clearSearchResults() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  void selectFilterOption({required String group, required String option}) {
    if (!_filterOptions.containsKey(group)) return;

    final current = _selectedFiltersByGroup[group];
    if (current == option) {
      _selectedFiltersByGroup[group] = null;
    } else {
      _selectedFiltersByGroup[group] = option;
    }
    notifyListeners();

    if (_searchQuery.isNotEmpty && _allFetchedResults.isNotEmpty) {
      _applyInternalFilters();
      notifyListeners();
    }
  }

  void toggleFilter(String option) {
    final inferredGroup = _inferGroupForOption(option);
    if (inferredGroup == null) return;
    selectFilterOption(group: inferredGroup, option: option);
  }

  String? _inferGroupForOption(String option) {
    for (final entry in _filterOptions.entries) {
      if (entry.value.contains(option)) return entry.key;
    }
    return null;
  }

  void clearFilters() {
    for (final key in _selectedFiltersByGroup.keys) {
      _selectedFiltersByGroup[key] = null;
    }
    notifyListeners();

    if (_searchQuery.isNotEmpty && _allFetchedResults.isNotEmpty) {
      _applyInternalFilters();
      notifyListeners();
    }
  }

  void toggleFiltersVisibility() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = '';
    _searchResults = [];
    _showFilters = false;
    notifyListeners();
  }

  void clearAll() {
    _debounceTimer?.cancel();
    _searchQuery = '';
    _searchResults = [];
    _allFetchedResults = [];
    _lastSearchQuery = '';
    clearFilters();
    _showFilters = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
