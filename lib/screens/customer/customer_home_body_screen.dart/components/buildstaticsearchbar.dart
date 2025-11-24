import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/providers/customer/customersearchbarprovider/static_searchbaranim_provider.dart';
import 'package:homeservice/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BuildStaticSearchBar extends StatefulWidget {
  const BuildStaticSearchBar({super.key});

  @override
  State<BuildStaticSearchBar> createState() => _BuildStaticSearchBarState();
}

class _BuildStaticSearchBarState extends State<BuildStaticSearchBar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaticSearchBarAnimProvider>().startServiceRotation();
    });
  }

  @override
  void dispose() {
    context.read<StaticSearchBarAnimProvider>().stopServiceRotation();
    super.dispose();
  }

  void _navigateToSearchPage() {
    Navigator.pushNamed(context, AppRoutes.customerAdvanceSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<StaticSearchBarAnimProvider>(
        builder: (context, searchProvider, child) {
          return GestureDetector(
            onTap: _navigateToSearchPage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Search for ",
                            style: AppTheme.searchbaranimtext,
                          ),
                          TextSpan(
                            text: searchProvider.currentService,
                            style: AppTheme.searchbaranimtext,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF033e8a),
                    size: 22,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
