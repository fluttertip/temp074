import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';

class BuildSectionTitle extends StatelessWidget {
  final String title;

  const BuildSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTheme.sectionTitle);
  }
}
