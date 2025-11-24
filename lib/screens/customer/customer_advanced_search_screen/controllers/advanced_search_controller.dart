import 'package:flutter/material.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/advance_searchbar_provider.dart';

class AdvancedSearchController {
  final CustomerAdvanceSearchProvider _searchProvider;
  final TextEditingController searchTextController;

  AdvancedSearchController(this._searchProvider)
    : searchTextController = TextEditingController() {
    _searchProvider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (_searchProvider.searchQuery.isEmpty &&
        searchTextController.text.isNotEmpty) {
      searchTextController.clear();
    }
  }

  bool get isSearching => _searchProvider.isSearching;
  String get searchQuery => _searchProvider.searchQuery;
  List get searchResults => _searchProvider.searchResults;
  List<String> get selectedFilters => _searchProvider.selectedFilters;
  bool get showFilters => _searchProvider.showFilters;
  Map<String, List<String>> get filterOptions => _searchProvider.filterOptions;
  int get selectedFiltersCount => _searchProvider.selectedFiltersCount;

  void performSearch(String query) {
    _searchProvider.searchServices(query);
  }

  void clearSearch() {
    searchTextController.clear();
    _searchProvider.clearSearch();
  }

  void selectFilterOption({required String group, required String option}) {
    _searchProvider.selectFilterOption(group: group, option: option);
  }

  void toggleFilter(String filter) {
    _searchProvider.toggleFilter(filter);
  }

  void clearFilters() {
    _searchProvider.clearFilters();
  }

  void toggleFiltersVisibility() {
    _searchProvider.toggleFiltersVisibility();
  }

  void dispose() {
    _searchProvider.removeListener(_onProviderChanged);
    searchTextController.dispose();
  }

  void handleBackNavigation() {
    _searchProvider.clearAll();
  }
}
