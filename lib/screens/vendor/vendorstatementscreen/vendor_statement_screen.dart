import 'package:flutter/material.dart';

class VendorStatementScreen extends StatefulWidget {
  const VendorStatementScreen({super.key});

  @override
  State<VendorStatementScreen> createState() => _VendorStatementScreenState();
}

class _VendorStatementScreenState extends State<VendorStatementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Statement'),
      ),
      body: const Center(
        child: Text('Vendor Statement Details'),
      ),
    );
  }
}