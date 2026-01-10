import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Consolidated application constants
/// Merged from: constants.dart, constants2.dart, Utils/constants.dart
class AppConstants {
  // App Configuration
  static const String appName = 'Mushroomy';

  // Primary Colors (from constants.dart)
  static const Color primaryColor = Color(0xff76984c);
  static const Color myBackgroundColor = Color(0xffececee);
  static const Color secondaryColor = Color(0xff101010);
  static const Color cartButtonColor = Color(0xff68874a);
  static const Color containerColor = Color(0xffb3cf95);

  // Green Theme Colors (from constants2.dart)
  static final Color darkGreenColor = const Color(0xFF184A2C);
  static final Color ginColor = const Color(0xFFE5F0EA);
  static final Color spiritedGreen = const Color(0xFFC1DFCB);
  static final Color foamColor = const Color(0xFFEBFDF2);
  static final Color greyColor = Colors.grey.shade600;

  // Background Colors (from Utils/constants.dart)
  static const Color onboardBackground = Color(0xFFe9f5e8);
  static const Color backgroundColor = Color(0xFFf7f8fb);
  static const Color textGreen = Color(0xFF50bf6e);

  // Gradients
  static const LinearGradient gradientColor = LinearGradient(
    colors: [
      Color(0xffb65ec4),
      Color(0xffa581ac),
    ],
  );

  // Text Styles
  static TextStyle billTextStyle = GoogleFonts.poppins(
    color: darkGreenColor,
    fontSize: 15.0,
  );
}
