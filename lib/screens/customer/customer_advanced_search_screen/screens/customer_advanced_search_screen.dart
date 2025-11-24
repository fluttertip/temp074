import 'package:flutter/material.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/filter_section.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/search_result.dart';
import 'package:homeservice/screens/customer/customer_advanced_search_screen/components/search_section.dart';
import 'package:provider/provider.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/advance_searchbar_provider.dart';
import '../controllers/advanced_search_controller.dart';

class CustomerAdvancedSearchScreen extends StatefulWidget {
  const CustomerAdvancedSearchScreen({super.key});

  @override
  State<CustomerAdvancedSearchScreen> createState() =>
      _CustomerAdvancedSearchScreenState();
}

class _CustomerAdvancedSearchScreenState
    extends State<CustomerAdvancedSearchScreen> {
  late AdvancedSearchController _searchController;

  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<CustomerAdvanceSearchProvider>(
      context,
      listen: false,
    );
    _searchController = AdvancedSearchController(searchProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Consumer<CustomerAdvanceSearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              SearchSectionComponent(controller: _searchController),

              if (_searchController.showFilters)
                FilterSectionComponent(controller: _searchController),

              Expanded(
                child: SearchResultsComponent(controller: _searchController),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.appbar,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.cardBackground),
        onPressed: () {
          _searchController.handleBackNavigation();
          Navigator.pop(context);
        },
      ),
      title: Text('Search Result', style: AppTheme.appbartext),
      centerTitle: false,
    );
  }
}
