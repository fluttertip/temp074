import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';

class BuildCreatePost extends StatelessWidget {
  const BuildCreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 175,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFe9ecf3),
        // borderRadius: BorderRadius.circular(12),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),

        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Can’t find Your Mindful Services?",
                      // style: TextStyle(
                      //   color: Color(0xFF5ba3f8),

                      //   fontSize: 14,
                      //   fontWeight: FontWeight.w600,
                      // ),
                      style: AppTheme.createPostTitle,
                    ),
                    // SizedBox(height: 10),
                    const SizedBox(height: AppTheme.spacingSM),
                    Text(
                      "Create a post about your service with\n"
                      "customized description & pricing",
                      style: AppTheme.createPostDescription,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 80,
                    width: 100,
                    child: Image.network(
                      "https://www.pngall.com/wp-content/uploads/8/Sample-PNG-HD-Image.png",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 10),
          const SizedBox(height: AppTheme.spacingSM),
          ElevatedButton(
            onPressed: () {},
            // style: ElevatedButton.styleFrom(
            //   backgroundColor: Colors.blue,
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
            style: AppTheme.primaryButtonStyle,
            child: Text(
              'Create Post',
              // style: TextStyle(color: Colors.white, fontSize: 13),
              style: AppTheme.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
