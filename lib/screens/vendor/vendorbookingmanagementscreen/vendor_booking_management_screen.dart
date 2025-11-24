import 'package:flutter/material.dart';

class VendorBookingManagementScreen extends StatefulWidget {
  const VendorBookingManagementScreen({super.key});

  @override
  State<VendorBookingManagementScreen> createState() =>
      _VendorBookingManagementScreenState();
}

class _VendorBookingManagementScreenState
    extends State<VendorBookingManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Booking Management')),
      body: const Center(child: Text('Vendor Booking Management Details')),
    );
  }
}
