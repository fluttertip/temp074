import 'package:flutter/material.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/filter_toogle.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/search_input.dart';
import '../controllers/advanced_search_controller.dart';

class SearchSectionComponent extends StatelessWidget {
  final AdvancedSearchController controller;

  const SearchSectionComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SearchInputComponent(controller: controller),
          const SizedBox(height: 12),
          FilterToggleComponent(controller: controller),
        ],
      ),
    );
  }
}
