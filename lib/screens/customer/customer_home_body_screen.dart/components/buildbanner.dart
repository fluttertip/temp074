import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BuildBanner extends StatefulWidget {
  final List<String> dataforbannerImages;
  
  const BuildBanner({
    super.key,
    required this.dataforbannerImages,
  });
     
  @override
  State<BuildBanner> createState() => _BuildBannerState();
}

class _BuildBannerState extends State<BuildBanner> {
  int _currentIndex = 0;
  static const double bannerHeight = 150.0; // Reduced height
  
  @override
  Widget build(BuildContext context) {
    if (widget.dataforbannerImages.isEmpty) {
      return _buildShimmer();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.dataforbannerImages.length,
          options: CarouselOptions(
            height: bannerHeight,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.dataforbannerImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => _buildShimmer(),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.dataforbannerImages.asMap().entries.map((entry) {
            return Container(
              width: 6, // Smaller dots
              height: 6, // Smaller dots
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: bannerHeight,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}