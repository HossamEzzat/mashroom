import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/prediction_result.dart';

/// Widget to display prediction results
class PredictionResultCard extends StatelessWidget {
  final PredictionResult result;
  final String imagePath;
  final VoidCallback onMoreInfo;

  const PredictionResultCard({
    super.key,
    required this.result,
    required this.imagePath,
    required this.onMoreInfo,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prediction Result',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Mushroom: ${result.prediction}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (result.confidence != null)
              Text(
                'Confidence: ${(result.confidence! * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            const SizedBox(height: 12),
            if (result.probabilities != null)
              ExpansionTile(
                title: const Text(
                  'All Probabilities',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white70,
                children: result.probabilities!.entries.map((entry) {
                  return ListTile(
                    title: Text(
                      '${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: result.hasError ? null : onMoreInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                ),
                child: const Text(
                  'More Info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
