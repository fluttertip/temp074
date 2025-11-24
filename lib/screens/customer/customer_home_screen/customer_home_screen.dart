import 'package:flutter/material.dart';
import 'package:homeservice/screens/customer/customer_booking_screen/screens/customer_booking_history_screen.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/screens/customer_home_body.dart';
import 'package:homeservice/screens/customer/customer_profilepage_screen/screens/customer_profile_screen.dart';
import 'package:homeservice/screens/customer/customer_setting_screen/screens/customer_setting_screen.dart';

class CustomerHomeScreen extends StatelessWidget {
  final int currentIndex;

  const CustomerHomeScreen({super.key, required this.currentIndex});

  final List<Widget> _screens = const [
    CustomerHomeBody(),
    CustomerBookingHistoryScreen(),
    CustomerProfileScreen(),
    CustomerSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    print(' CustomerHomeScreen building with index: $currentIndex');

    // Add safety check for index bounds
    final safeIndex = currentIndex >= 0 && currentIndex < _screens.length
        ? currentIndex
        : 0;

    if (safeIndex != currentIndex) {
      print(
        ' CustomerHomeScreen: Invalid index $currentIndex, using $safeIndex',
      );
    }

    return SafeArea(child: _screens[safeIndex]);
  }
}
