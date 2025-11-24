import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/routes/app_routes.dart';

class BuildHorizontalServiceWithProviderList extends StatefulWidget {
  final List<ServiceWithProviderModel> dataforhorizontalList;
  final VoidCallback? onLoadMore;
  final bool hasMoreData;
  final bool isLoadingMore;

  const BuildHorizontalServiceWithProviderList({
    super.key,
    required this.dataforhorizontalList,
    this.onLoadMore,
    this.hasMoreData = false,
    this.isLoadingMore = false,
  });

  @override
  State<BuildHorizontalServiceWithProviderList> createState() =>
      _BuildHorizontalServiceWithProviderListState();
}

class _BuildHorizontalServiceWithProviderListState
    extends State<BuildHorizontalServiceWithProviderList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        widget.hasMoreData &&
        !widget.isLoadingMore &&
        widget.onLoadMore != null) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataforhorizontalList.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingSM),
      color: Colors.white,
      height: 230,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount:
            widget.dataforhorizontalList.length + (widget.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.dataforhorizontalList.length) {
            return _buildLoadingIndicator();
          }

          final serviceswithvendordata = widget.dataforhorizontalList[index];
          final servicedatalist = serviceswithvendordata.service;
          final vendordatalist = serviceswithvendordata.provider;

          return _buildServiceCard(context, servicedatalist, vendordatalist);
        },
      ),
    );
  }

  Widget _buildServiceCard(context, servicedatalist, vendordatalist) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.customerServiceDetail,
          arguments: ServiceWithProviderModel(
            service: servicedatalist,
            provider: vendordatalist,
          ),
        );
      },
      child: Container(
        width: 180,

        margin: EdgeInsets.only(right: AppTheme.spacingMD),
        decoration: AppTheme.containerDecoration,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                servicedatalist.imageUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100,
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF5ba3f8),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppTheme.spacingSM),
            // Service Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXS,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servicedatalist.title,
                    style: AppTheme.serviceTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppTheme.spacingSM),
                  // Provider Name
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 20,
                        color: AppTheme.textTertiary,
                      ),
                      SizedBox(width: AppTheme.spacingXS),
                      Expanded(
                        child: Text(
                          vendordatalist.name ?? 'Unknown Provider',
                          style: AppTheme.providerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingXS),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: AppTheme.spacingXS),

                      Expanded(
                        child: Text(
                          'Kathmandu, Nepal',
                          style: AppTheme.locationText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Rs. ${servicedatalist.price}",
                        style: AppTheme.priceText,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.favorite_border,
                        color: AppTheme.secondary,
                        size: 20,
                      ),
                    ],
                  ),
                  // Service Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: AppTheme.rating),
                      SizedBox(width: AppTheme.spacingXS),
                      Text(
                        servicedatalist.rating.toString(),
                        style: AppTheme.ratingText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5ba3f8)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 230,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No services available', style: AppTheme.emptyStateTitle),
          ],
        ),
      ),
    );
  }
}
