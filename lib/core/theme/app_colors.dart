import 'package:flutter/material.dart';

/// App color palette - centralized color definitions
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFD993E4);
  static const Color primaryDark = Color(0xFF42114A);
  static const Color primaryLight = Color(0xFFE699F1);

  // Secondary colors
  static const Color secondary = Color(0xFF782B87);
  static const Color secondaryLight = Color(0xFFE08DE8);

  // Background colors
  static const Color background = Color(0xFFF5F7F2);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFECECEE);

  // Text colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Mushroom type colors
  static const Color poisonous = Color(0xFFFF5252);
  static const Color healthy = Color(0xFF66BB6A);
  static const Color toxic = Color(0xFFFF9800);

  // Card colors
  static const Color cardPink = Color(0xFFF4CBFD);
  static const Color cardGreen = Color(0xFFE6F4EA);
  static const Color cardYellow = Color(0xFFFFF9E6);
  static const Color cardPremium = Color(0xFFFFF3CD);

  // Shadow and overlay colors
  static Color shadow = Colors.black.withValues(alpha: 0.1);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.2);
  static Color overlay = Colors.black.withValues(alpha: 0.5);
  static Color overlayLight = Colors.black.withValues(alpha: 0.3);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE699F1), Color(0xFFB65EC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFD993E4), Color(0xFF42114A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Nature-inspired gradients
  static const LinearGradient forestGradient = LinearGradient(
    colors: [Color(0xFF2D5016), Color(0xFF4A7C59)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mushroomGradient = LinearGradient(
    colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient toxicGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient safeGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer gradient for loading states
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // Glassmorphism colors
  static Color glassBackground = Colors.white.withOpacity(0.1);
  static Color glassBorder = Colors.white.withOpacity(0.2);
  static Color glassHighlight = Colors.white.withOpacity(0.05);

  // Enhanced shadows with warmer tones
  static Color warmShadow = const Color(0xFF000000).withOpacity(0.08);
  static Color warmShadowMedium = const Color(0xFF000000).withOpacity(0.15);
  static Color warmShadowStrong = const Color(0xFF000000).withOpacity(0.25);
}
