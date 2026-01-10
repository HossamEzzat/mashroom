import 'package:flutter/material.dart';
import 'package:mashroom/models/plant_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/feature_card.dart';
import '../../disease/screens/disease_prediction_screen.dart';
import '../../pollution/screens/pollution_report_screen.dart';
import '../widgets/mushroom_grid_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 4,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.primary),
            const SizedBox(width: AppTheme.spacingS),
            Text("World", style: theme.textTheme.titleSmall),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingM),
            child: CircleAvatar(
              backgroundColor: AppColors.backgroundLight,
              child: const Icon(Icons.person, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Good morning, mushroom explorer!",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Search Bar
              Container(
                decoration: AppTheme.searchBarDecoration(),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for Mushrooms",
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textTertiary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Feature Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiseasePredictionScreen(),
                          ),
                        );
                      },
                      child: const FeatureCard(
                        icon: Icons.camera_alt,
                        title: "Identify",
                        subtitle: "Tap to recognize Mushrooms",
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SustainableRecipeScreen(), // Updated class name
                          ),
                        );
                      },
                      child: const FeatureCard(
                        icon: Icons.emergency,
                        title: "Advanced",
                        subtitle: "Generate Recipes Based on Species",
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Premium Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.cardPremium,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: AppColors.warning,
                      size: 30,
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Go Premium",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Unlock All Features",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Mushroom Grid View
              MushroomGridView(mushrooms: mushrooms),
            ],
          ),
        ),
      ),
    );
  }
}
