import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import '../controllers/advanced_search_controller.dart';

class FilterToggleComponent extends StatelessWidget {
  final AdvancedSearchController controller;

  const FilterToggleComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterButton(),
        const SizedBox(width: 12),
        if (controller.selectedFiltersCount > 0) _buildClearButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: controller.toggleFiltersVisibility,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: controller.showFilters
              ? AppTheme.primary
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.showFilters
                ? AppTheme.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 18,
              color: controller.showFilters
                  ? Colors.white
                  : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Filters',
              style: TextStyle(
                color: controller.showFilters
                    ? Colors.white
                    : AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (controller.selectedFilters.isNotEmpty) ...[
              const SizedBox(width: 4),
              _buildFilterCount(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCount() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: controller.showFilters ? Colors.white : AppTheme.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        '${controller.selectedFilters.length}',
        style: TextStyle(
          color: controller.showFilters ? AppTheme.primary : Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: controller.clearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear, size: 18, color: Colors.red),
            const SizedBox(width: 4),
            Text(
              'Clear',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
