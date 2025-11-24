import 'package:flutter/material.dart';
import 'package:homeservice/screens/vendor/vendor_dashboard_screen/screens/vendor_dashboard_screen.dart';
import 'package:homeservice/screens/vendor/vendor_profile_screen/screens/vendor_profile_screen.dart';
import 'package:homeservice/screens/vendor/vendor_services_screen/screens/vendor_services_screen.dart';
import 'package:homeservice/screens/vendor/vendor_setting_screen/screens/vendor_setting_screen.dart';

class VendorHomeScreen extends StatelessWidget {
  final int currentIndex;

  const VendorHomeScreen({super.key, required this.currentIndex});

  final List<Widget> _screens = const [
    VendorDashboardScreen(),
    VendorServicesScreen(),
    VenodrProfileScreen(),
    VendorSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print(' VendorHomeScreen building with index: $currentIndex');

    // Add safety check for index bounds
    final safeIndex = currentIndex >= 0 && currentIndex < _screens.length
        ? currentIndex
        : 0;

    if (safeIndex != currentIndex) {
      print(' VendorHomeScreen: Invalid index $currentIndex, using $safeIndex');
    }

    return SafeArea(child: _screens[safeIndex]);
  }
}
