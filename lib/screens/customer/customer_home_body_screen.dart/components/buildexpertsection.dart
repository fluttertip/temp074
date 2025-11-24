import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import '../../../../models/user_model.dart';

class BuildExpertSection extends StatefulWidget {
  final List<UserModel> dataforlocalExperts;
  const BuildExpertSection({super.key, required this.dataforlocalExperts});

  @override
  State<BuildExpertSection> createState() => _BuildExpertSectionState();
}

class _BuildExpertSectionState extends State<BuildExpertSection> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      final expertList = widget.dataforlocalExperts;
      if (_pageController.hasClients && expertList.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= expertList.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expertList = widget.dataforlocalExperts;

    if (expertList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(
              color: Colors.black.withOpacity(0.08),
              width: 0.6,
            ),
          ),
          child: SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              itemCount: expertList.length,
              itemBuilder: (context, index) {
                final expert = expertList[index];
                return _ExpertCard(expert: expert);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpertCard extends StatelessWidget {
  final UserModel expert;

  const _ExpertCard({required this.expert});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Image.network(
              'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 36, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        expert.name ,
                        style: AppTheme.expertName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  expert.role == 'provider'
                      ? 'Expert Professional'
                      : 'Service Provider',
                  style: AppTheme.expertRole,
                ),
                Row(
                  children: [
                    Text(
                      '4.9',
                      style: AppTheme.ratingText.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('(37)', style: AppTheme.ratingText),
                    const Spacer(),
                    const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
