import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../screens/disease_prediction_screen.dart';

class PlantPredictionCards extends StatelessWidget {
  final Function(int)? onTabChange;

  const PlantPredictionCards({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Prediction Guide"),
        centerTitle: true,
        // Using standard back button logic to maintain navigation stack
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildHeroSection(theme),
          const SizedBox(height: 24),

          // Disease Classification Card
          _PredictionFeatureCard(
            title: 'Disease Classification',
            subtitle:
                'Identify fungal infections and physiological disorders in real-time.',
            imagePath: 'assets/mushroom.jpg',
            accentColor: AppColors.primary,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DiseasePredictionScreen(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Potential 2nd Card (Example: Edibility check)
          _PredictionFeatureCard(
            title: 'Edibility Scanner',
            subtitle:
                'AI-powered assessment of physical characteristics for edibility.',
            imagePath: 'assets/mushroom_onboard.jpg',
            accentColor: Colors.orangeAccent,
            onTap: () {
              // Future feature navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mushroom AI",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Select a diagnostic tool to begin your analysis",
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

class _PredictionFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color accentColor;
  final VoidCallback onTap;

  const _PredictionFeatureCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Section with Gradient Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "AI ACTIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundColor: accentColor.withOpacity(0.1),
                    child: Icon(Icons.chevron_right, color: accentColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
