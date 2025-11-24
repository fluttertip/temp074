import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/models/servicewithprovider_model.dart';
import 'package:homeservice/routes/app_routes.dart';

class BuildVerticalServiceWithProviderList extends StatefulWidget {
  final List<ServiceWithProviderModel> dataforverticalList;
  final VoidCallback? onLoadMore;
  final bool hasMoreData;
  final bool isLoadingMore;

  const BuildVerticalServiceWithProviderList({
    super.key,
    required this.dataforverticalList,
    this.onLoadMore,
    this.hasMoreData = false,
    this.isLoadingMore = false,
  });

  @override
  State<BuildVerticalServiceWithProviderList> createState() =>
      _BuildVerticalServiceWithProviderListState();
}

class _BuildVerticalServiceWithProviderListState
    extends State<BuildVerticalServiceWithProviderList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataforverticalList.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ...widget.dataforverticalList.map((serviceswithvendordata) {
            final servicedatalist = serviceswithvendordata.service;
            final vendordatalist = serviceswithvendordata.provider;
            return _buildVerticalCard(context, servicedatalist, vendordatalist);
          }),

          if (widget.isLoadingMore) _buildLoadingIndicator(),

          if (widget.hasMoreData && !widget.isLoadingMore)
            _buildLoadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildVerticalCard(context, servicedatalist, vendordatalist) {
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
        margin: EdgeInsets.only(bottom: AppTheme.spacingMD + 2),
        padding: EdgeInsets.all(AppTheme.spacingMD + 2),
        decoration: AppTheme.containerDecoration,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.spacingSM + 2),
              child: Image.network(
                servicedatalist.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            SizedBox(width: AppTheme.spacingMD + 2),
            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            servicedatalist.title,
                            style: AppTheme.serviceTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          offset: const Offset(0, 25),
                          onSelected: (String value) {
                            if (value == 'share') {
                              _handleShare(servicedatalist);
                            } else if (value == 'bookmark') {
                              _handleBookmark(servicedatalist);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'share',
                              height: 40,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'bookmark',
                              height: 40,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bookmark_outline,
                                    size: 18,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Bookmark',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Provider name
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
                  // Location (static)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: AppTheme.spacingXS),
                      Text('Kathmandu, Nepal', style: AppTheme.locationText),
                    ],
                  ),
                  SizedBox(height: AppTheme.spacingXS),
                  // Rating
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
                  SizedBox(height: AppTheme.spacingSM - 2),
                  Row(
                    children: [
                      Text(
                        "Rs. ${servicedatalist.price}",
                        style: AppTheme.priceText,
                      ),
                      const Spacer(),
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

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: widget.onLoadMore,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Load More'),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 48, color: AppTheme.textTertiary),
            SizedBox(height: AppTheme.spacingLG),
            Text('No services available', style: AppTheme.emptyStateTitle),
          ],
        ),
      ),
    );
  }

  void _handleShare(dynamic servicedatalist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${servicedatalist.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBookmark(dynamic servicedatalist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${servicedatalist.title} to bookmarks'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
