import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// This class defines the app's theme, including colors and text styles.
/// Ultra-clean, modern design system optimized for home services app.
/// Emphasis on subtle hierarchy and refined typography.

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF004AAD);
  static const Color secondary = Color(0xFFc61f3d);
  static const Color background = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textTertiary = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x0D000000);
  static const Color rating = Colors.amber;
  static const Color appbar = Color(0xFFffffff);

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double spacingXL = 24.0;

  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(radiusMD),
    border: Border.all(color: Colors.black.withOpacity(0.1), width: 0.8),
  );

  static BoxDecoration get containerDecoration => BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(radiusLG),
    border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.6),
  );

  //Primary Button Style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primary,
    elevation: 0.5, // almost flat
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusSM),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
  );

  // Expert Name (14px, regular - much lighter)
  static TextStyle expertName = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  // Expert Role (11px, light, grey)
  static TextStyle expertRole = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Create Post Title (12px, regular, primary - much smaller)
  static TextStyle createPostTitle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: primary,
  );

  // Create Post Description (10px, light, grey)
  static TextStyle createPostDescription = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: textSecondary,
  );

  //appbar text
  static TextStyle appbartext = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    // color: Colors.white,
    color: Colors.black,
  );

  // Button Text (12px, medium, white)
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    // color: Colors.white,
    color: Color(0xFF033e8a),
  );

  // FIXED HIERARCHY - Service Title should be BIGGER than Provider Name

  // Section Titles (15px, regular - clean and minimal)
  static TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  // Service Card Title (14px, medium - BIGGEST in card hierarchy)
  static TextStyle serviceTitle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -0.1,
  );

  // Provider Name (12px, regular, primary - SMALLER than service title)
  static TextStyle providerName = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    // color: primary,
    color: textPrimary,
  );

  // Location Text (10px, light, grey)
  static TextStyle locationText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Price Text (13px, medium, red - important but not dominant)
  static TextStyle priceText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.green,
  );

  // Rating Text (10px, light, grey)
  static TextStyle ratingText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Header Username (14px, light - much cleaner)
  static TextStyle headerUsername = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF033e8a),
    letterSpacing: -0.2,
  );

  // Header Location (10px, light)
  static TextStyle headerLocation = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: Color(0xFF033e8a),
  );

  // Category Text (10px, light, grey)
  static TextStyle categoryText = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Empty State Title (13px, light)
  static TextStyle emptyStateTitle = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Search bar placeholder (12px, light)
  static TextStyle searchbaranimtext = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.grey[600],
  );

  // Search bar text (12px, regular)
  static TextStyle searchBarText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  // Additional refined text styles

  // Caption Text (9px, light) - for smallest text
  static TextStyle captionText = GoogleFonts.poppins(
    fontSize: 9,
    fontWeight: FontWeight.w300,
    color: textTertiary,
  );

  // Body Text (12px, light) - for general content
  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: textSecondary,
  );

  // Subtitle Text (13px, regular) - for subtitles
  static TextStyle subtitleText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  // Large Title (16px, medium) - for main headings only
  static TextStyle largeTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: -0.4,
  );

  // Profile section styles - smaller, cleaner
  static TextStyle profileSectionTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle profileSectionSubtitle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
  );

  static TextStyle profileFieldLabel = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static TextStyle profileButtonText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle profileChipText = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
}