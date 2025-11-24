import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/empty_searchresult_state.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/no_searchresult_state.dart';
import 'package:homeservice/screens/customer/shared/components/build_vertical_service_with_provider_list.dart';
import '../controllers/advanced_search_controller.dart';

class SearchResultsComponent extends StatelessWidget {
  final AdvancedSearchController controller;

  const SearchResultsComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isSearching) {
      return _buildLoadingState();
    }

    if (controller.searchQuery.isEmpty) {
      return const EmptySearchStateComponent();
    }

    if (controller.searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultsHeader(),
          const SizedBox(height: 8),
          BuildVerticalServiceWithProviderList(
            dataforverticalList: controller.searchResults
                .cast<ServiceWithProviderModel>(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'plumbi..',
            style: AppTheme.bodyText.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Column(
      children: [
        _buildResultsHeader(),
        const Expanded(child: NoResultsStateComponent()),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${controller.searchResults.length} result${controller.searchResults.length == 1 ? '' : 's'} found',
            style: AppTheme.bodyText.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (controller.selectedFiltersCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.selectedFiltersCount} filter${controller.selectedFiltersCount == 1 ? '' : 's'} applied',
                style: AppTheme.captionText.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
