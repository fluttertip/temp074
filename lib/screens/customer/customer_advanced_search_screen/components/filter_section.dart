import 'package:flutter/material.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/filter_category.dart';
import '../controllers/advanced_search_controller.dart';

class FilterSectionComponent extends StatelessWidget {
  final AdvancedSearchController controller;

  const FilterSectionComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: controller.filterOptions.entries.map((entry) {
          return FilterCategoryComponent(
            category: entry.key,
            options: entry.value,
            controller: controller,
          );
        }).toList(),
      ),
    );
  }
}
