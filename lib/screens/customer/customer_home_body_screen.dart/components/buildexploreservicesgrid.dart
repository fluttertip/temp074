
// import 'package:flutter/material.dart';
// import 'package:homeservice/core/theme/app_theme.dart';

// class BuildExploreServicesGrid extends StatelessWidget {
//   final Function(String)? onCategoryTap;

//   const BuildExploreServicesGrid({super.key, this.onCategoryTap});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> serviceCategories = [
//       {
//         'title': 'Plumbing',
//         'image': Icons.pl
//       },
//       {
//         'title': 'Repairing',
//         'image': 'assets/images/explore_service_icon/repairing.png',
//       },
//       {
//         'title': 'Electrical',
//         'image': 'assets/images/explore_service_icon/electrical.png',
//       },
//       {
//         'title': 'Appliance',
//         'image': 'assets/images/explore_service_icon/appliance.png',
//       },
//       {
//         'title': 'Cleaning',
//         'image': 'assets/images/explore_service_icon/cleaning.png',
//       },
//       {
//         'title': 'Painting',
//         'image': 'assets/images/explore_service_icon/plumbing.png',
//       },
//       {
//         'title': 'Moving',
//         'image': 'assets/images/explore_service_icon/moving.png',
//       },

//       {
//         'title': 'Handyman',
//         'image': 'assets/images/explore_service_icon/plumbing.png',
//       },
//     ];

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(8),
//       decoration: AppTheme.containerDecoration,
//       // decoration: BoxDecoration(
//       //   color: Colors.white,
//       //   borderRadius: BorderRadius.circular(20),
//       //   border: Border.all(color: Colors.grey.shade200),
//       //   boxShadow: [
//       //     BoxShadow(
//       //       color: Colors.black12.withOpacity(0.05),
//       //       blurRadius: 10,
//       //       offset: const Offset(0, 4),
//       //     ),
//       //   ],
//       // ),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: serviceCategories.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           mainAxisSpacing: 24,
//           crossAxisSpacing: 12,
//           mainAxisExtent: 95,
//         ),
//         itemBuilder: (context, index) {
//           final category = serviceCategories[index];

//           return GestureDetector(
//             onTap: () {
//               onCategoryTap?.call(category['title']);
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   category['image'],
//                   width: 40,
//                   height: 40,
//                   fit: BoxFit.contain,
//                 ),
//                 // const SizedBox(height: 8),
//                 const SizedBox(height: AppTheme.spacingSM),
//                 Text(
//                   category['title'],
//                   style: AppTheme.categoryText,
//                   // style: GoogleFonts.poppins(
//                   //   fontSize: 12,
//                   //   fontWeight: FontWeight.w500,
//                   //   color: Colors.grey.shade800,
//                   // ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


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