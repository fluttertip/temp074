

import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';

class BuildExploreServicesGrid extends StatelessWidget {
  final Function(String)? onCategoryTap;

  const BuildExploreServicesGrid({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> serviceCategories = [
      {
        'title': 'Plumbing',
        'icon': Icons.plumbing_outlined,
      },
      {
        'title': 'Repairing',
        'icon': Icons.build_outlined,
      },
      {
        'title': 'Electrical',
        'icon': Icons.electric_bolt_outlined,
      },
      {
        'title': 'Appliance',
        'icon': Icons.desktop_windows_outlined,
      },
      {
        'title': 'Cleaning',
        'icon': Icons.cleaning_services_outlined,
      },
      {
        'title': 'Painting',
        'icon': Icons.format_paint_outlined,
      },
      {
        'title': 'Moving',
        'icon': Icons.local_shipping_outlined,
      },
      {
        'title': 'Handyman',
        'icon': Icons.handyman_outlined,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: AppTheme.containerDecoration,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: serviceCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 24,
          crossAxisSpacing: 12,
          mainAxisExtent: 95,
        ),
        itemBuilder: (context, index) {
          final category = serviceCategories[index];

          return GestureDetector(
            onTap: () {
              onCategoryTap?.call(category['title']);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'],
                  size: 32,
                  color: Colors.black87, // Soft color for icons
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(
                  category['title'],
                  style: AppTheme.categoryText,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}