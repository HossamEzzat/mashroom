import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App theme configuration
class AppTheme {
  // Spacing constants
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusRound = 100.0;

  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve springCurve = Curves.easeOutBack;

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundLight,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Text theme
      textTheme: TextTheme(
        // Headings
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        // Titles
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // Body
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),

        // Labels
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        color: AppColors.backgroundLight,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: elevationM,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textTertiary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  /// Card decoration
  static BoxDecoration cardDecoration({
    Color? color,
    double? radius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.backgroundLight,
      borderRadius: BorderRadius.circular(radius ?? radiusM),
      boxShadow:
          shadows ??
          [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
    );
  }

  /// Feature card decoration
  static BoxDecoration featureCardDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radiusM),
    );
  }

  /// Search bar decoration
  static BoxDecoration searchBarDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundLight,
      borderRadius: BorderRadius.circular(radiusM),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 5,
          spreadRadius: 2,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Glassmorphism decoration
  static BoxDecoration glassmorphismDecoration({
    double radius = radiusM,
    double blur = 10.0,
  }) {
    return BoxDecoration(
      color: AppColors.glassBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.glassBorder, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.warmShadow,
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Shimmer decoration for loading states
  static BoxDecoration shimmerDecoration({double radius = radiusM}) {
    return BoxDecoration(
      gradient: AppColors.shimmerGradient,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Enhanced card decoration with depth
  static BoxDecoration enhancedCardDecoration({
    Color? color,
    double? radius,
    Gradient? gradient,
    bool elevated = true,
  }) {
    return BoxDecoration(
      color: gradient == null ? (color ?? AppColors.backgroundLight) : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius ?? radiusL),
      border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: AppColors.warmShadow,
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.glassHighlight,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ]
          : null,
    );
  }

  /// Pulsing decoration for warnings
  static BoxDecoration pulsingDecoration({
    required Color color,
    double radius = radiusM,
  }) {
    return BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withOpacity(0.3), width: 2),
    );
  }
}
