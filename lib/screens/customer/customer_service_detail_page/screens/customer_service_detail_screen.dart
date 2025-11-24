import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/models/service_model.dart';
import 'package:homeservice/models/user_model.dart';
import 'package:homeservice/providers/customer/customerprofileprovider/customer_profile_provider.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:provider/provider.dart';

class CustomerServiceDescriptionPage extends StatefulWidget {
  final ServiceModel service;
  final UserModel vendorData;

  const CustomerServiceDescriptionPage({
    super.key,
    required this.service,
    required this.vendorData,
  });

  @override
  State<CustomerServiceDescriptionPage> createState() =>
      _CustomerServiceDescriptionPageState();
}

class _CustomerServiceDescriptionPageState
    extends State<CustomerServiceDescriptionPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.appbar,
        automaticallyImplyLeading: true,
        title: Text(widget.service.title, style: AppTheme.appbartext),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<CustomerProfileProvider>(
                    builder: (context, customerProfileProvider, _) {
                      if (!customerProfileProvider.isCustomerProfileComplete &&
                          !customerProfileProvider.isBannerShown(
                            'customer_service_detail',
                          )) {
                        customerProfileProvider.markBannerShown(
                          'customer_service_detail',
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          CompleteProfileBannerOverlay.show(
                            context,
                            message:
                                "Complete your profile to unlock booking features!",
                            duration: Duration(seconds: 5),
                          );
                        });
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  _buildServiceImage(),

                  _buildActionRow(),

                  SizedBox(height: AppTheme.spacingLG),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLG,
                    ),
                    child: _buildProviderCard(),
                  ),

                  SizedBox(height: AppTheme.spacingLG),

                  SizedBox(height: AppTheme.spacingLG),

                  // Description Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLG,
                    ),
                    child: _buildDescriptionSection(),
                  ),

                  SizedBox(height: AppTheme.spacingLG),

                  // Reviews Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLG,
                    ),
                    child: _buildReviewsSection(),
                  ),

                  // SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildServiceImage() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Image.network(
        widget.service.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade100,
          child: Icon(
            Icons.home_repair_service,
            size: 60,
            color: AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacingLG),
      child: Row(
        children: [
          // Share button
          Container(
            padding: EdgeInsets.all(8),
            decoration: AppTheme.containerDecoration,
            child: Icon(Icons.share_outlined, color: Colors.black, size: 20),
          ),

          SizedBox(width: AppTheme.spacingSM),

          // Favorite button
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),

          Spacer(),

          // Price
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMD,
              vertical: AppTheme.spacingSM,
            ),
            decoration: AppTheme.containerDecoration,
            child: Text(
              'Rs. ${widget.service.price}',
              style: AppTheme.priceText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard() {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingLG),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              // Provider Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: AppTheme.primary, size: 24),
              ),

              SizedBox(width: AppTheme.spacingMD),

              // Provider info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.vendorData.name,
                      style: AppTheme.providerName.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: AppTheme.spacingXS),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppTheme.rating, size: 14),
                        SizedBox(width: 4),
                        Text(
                          widget.service.rating,
                          style: AppTheme.ratingText.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          // '(${widget.service.reviewCount} Reviews)'
                          '(240 reviews)',
                          style: AppTheme.ratingText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Service count
              Text(
                'Services (12)',
                style: AppTheme.captionText.copyWith(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingMD),
          _buildFeaturesSection(),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {'icon': Icons.verified_outlined, 'text': 'KYC Verified'},
      {'icon': Icons.shield_outlined, 'text': 'Quality Assurance'},
      {'icon': Icons.location_on_outlined, 'text': 'Service Area'},
      {
        'icon': Icons.workspace_premium_outlined,
        'text': 'Accreditations and Awards',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppTheme.spacingSM),
          child: Row(
            children: [
              Icon(
                feature['icon'] as IconData,
                color: AppTheme.primary,
                size: 18,
              ),
              SizedBox(width: AppTheme.spacingMD),
              Text(
                feature['text'] as String,
                style: AppTheme.bodyText.copyWith(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTheme.sectionTitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppTheme.spacingMD),
        Container(
          padding: EdgeInsets.all(AppTheme.spacingLG),
          decoration: AppTheme.cardDecoration,
          child: Text(
            widget.service.description,
            style: AppTheme.bodyText.copyWith(
              fontSize: 13,
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews',
              style: AppTheme.sectionTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: AppTheme.spacingMD),
            Icon(Icons.star, color: AppTheme.rating, size: 16),
            SizedBox(width: 4),
            Text(
              widget.service.rating,
              style: AppTheme.ratingText.copyWith(fontSize: 12),
            ),
            Spacer(),
            Text(
              '(240 Reviews)',
              style: AppTheme.captionText.copyWith(
                fontSize: 11,
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),

        SizedBox(height: AppTheme.spacingMD),

        // Review cards
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            final reviewNames = ['John Doe', 'Sarah Smith', 'Mike Johnson'];
            final reviewTexts = [
              'Excellent service! Very professional and reliable. Highly recommended.',
              'Great work! The technician was on time and fixed the issue quickly.',
              'Outstanding service quality. Will definitely use again in the future.',
            ];

            return Container(
              margin: EdgeInsets.only(bottom: AppTheme.spacingMD),
              padding: EdgeInsets.all(AppTheme.spacingLG),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewNames[index],
                    style: AppTheme.providerName.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingXS),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < 4 ? Icons.star : Icons.star_border,
                        color: AppTheme.rating,
                        size: 14,
                      );
                    }),
                  ),
                  SizedBox(height: AppTheme.spacingSM),
                  Text(
                    reviewTexts[index],
                    style: AppTheme.bodyText.copyWith(
                      fontSize: 12,
                      height: 1.4,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingLG),
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final provider = Provider.of<CustomerProfileProvider>(
            context,
            listen: false,
          );

          if (!provider.isCustomerProfileComplete) {
            CompleteProfileBannerOverlay.show(
              context,
              message: "Complete your customer profile for booking services",
              duration: const Duration(seconds: 5),
            );
            return;
          }
          //will cause error widget error dispose if navigation is not inside the future methods

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Booking service...'),
          //     backgroundColor: AppTheme.primary,
          //     behavior: SnackBarBehavior.floating,
          //   ),
          // );
          Navigator.pushNamed(
            context,
            '/customer/booking/intermediate',
            arguments: {'service': widget.service, 'vendor': widget.vendorData},
          );
        },

        style: AppTheme.primaryButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(AppTheme.appbar),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(vertical: AppTheme.spacingLG),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
          ),
        ),
        child: Text(
          'Book this service now',
          style: AppTheme.buttonText.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
