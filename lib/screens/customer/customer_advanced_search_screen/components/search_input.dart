import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/advance_searchbar_provider.dart';
import '../controllers/advanced_search_controller.dart';

class SearchInputComponent extends StatelessWidget {
  final AdvancedSearchController controller;

  const SearchInputComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerAdvanceSearchProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          child: TextField(
            style: AppTheme.searchBarText,
            controller: controller.searchTextController,
            onChanged: controller.performSearch,
            decoration: InputDecoration(
              hintStyle: AppTheme.searchbaranimtext,
              hintText: 'Search for services...',
              suffixIcon: _buildSuffixIcon(provider),
              prefixIcon: provider.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppTheme.textSecondary),
                      onPressed: controller.clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuffixIcon(CustomerAdvanceSearchProvider provider) {
    if (provider.isSearching) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      );
    }

    return Icon(Icons.search, color: AppTheme.textSecondary);
  }
}
