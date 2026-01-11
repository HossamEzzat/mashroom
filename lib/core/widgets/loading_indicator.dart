import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final String? message;
  final bool isAdaptive;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 40,
    this.message,
    this.isAdaptive = true,
  });

  /// Factory for button-sized loaders
  const LoadingIndicator.small({
    super.key,
    this.color, // Removed hardcoded white to allow theme/logic fallback
    this.size = 20,
    this.message,
    this.isAdaptive = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Logic for choosing color: specific param > primary color
    final indicatorColor = color ?? AppColors.primary;

    return Center(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) =>
            Opacity(opacity: value, child: child),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: isAdaptive
                  ? _buildAdaptiveIndicator(
                      context,
                      indicatorColor,
                    ) // Fixed: Passed context
                  : CircularProgressIndicator(
                      color: indicatorColor,
                      strokeWidth: size < 30 ? 2 : 3,
                    ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Method signature now matches the call in build()
  Widget _buildAdaptiveIndicator(BuildContext context, Color color) {
    return CircularProgressIndicator(
      color: color,
      strokeWidth: size < 30 ? 2 : 3,
    );
  }
}

/// Enhanced Full Screen Loading Overlay with Blur
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool useBlur;

  const LoadingOverlay({super.key, this.message, this.useBlur = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The Blur layer
        if (useBlur)
          Positioned.fill(
            // Ensure the blur fills the whole stack
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: AppColors.overlay.withOpacity(0.5)),
              ),
            ),
          )
        else
          Positioned.fill(child: Container(color: AppColors.overlay)),

        // The Indicator
        LoadingIndicator(color: Colors.white, message: message, size: 45),
      ],
    );
  }
}
