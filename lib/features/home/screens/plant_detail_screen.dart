import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mashroom/models/plant_model.dart';
import '../../../core/providers/favorites_provider.dart';

import '../../../core/theme/app_colors.dart';

class MushroomDetailScreen extends StatefulWidget {
  final Mushroom mushroom;

  const MushroomDetailScreen({super.key, required this.mushroom});

  @override
  State<MushroomDetailScreen> createState() => _MushroomDetailScreenState();
}

class _MushroomDetailScreenState extends State<MushroomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mushroom = widget.mushroom;
    final isPoisonous = mushroom.type == 'Poisonous';

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.8),
            child: const BackButton(color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.8),
              child: Consumer<FavoritesProvider>(
                builder: (context, provider, child) {
                  final isFavorite = provider.isFavorite(mushroom.name);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(mushroom.name);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? "${mushroom.name} removed from favorites"
                                : "${mushroom.name} added to favorites",
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(mushroom),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(mushroom, isPoisonous),
                  const SizedBox(height: 20),
                  _buildDescription(mushroom),
                  const SizedBox(height: 30),
                  _buildQuickInfoGrid(mushroom),
                  const SizedBox(height: 30),
                  if (isPoisonous) _buildWarningSection(mushroom),
                  _buildMorphologySection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(Mushroom mushroom) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.secondary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Hero(
        tag: mushroom.name, // Use name for uniqueness if image is reused
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Image.asset(mushroom.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildTitleSection(Mushroom mushroom, bool isPoisonous) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                mushroom.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (isPoisonous ? Colors.red : Colors.green).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (isPoisonous ? Colors.red : Colors.green).withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              child: Text(
                mushroom.type.toUpperCase(),
                style: TextStyle(
                  color: isPoisonous ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(Mushroom mushroom) {
    return Text(
      mushroom.description,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade700,
        height: 1.6,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildQuickInfoGrid(Mushroom mushroom) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _infoTile(
                Icons.terrain_rounded,
                "Habitat",
                mushroom.habitat,
              ),
            ),
            const VerticalDivider(color: Colors.white24, width: 20),
            Expanded(
              child: _infoTile(
                Icons.whatshot_rounded,
                "Spore",
                mushroom.sporePrintColor,
              ),
            ),
            const VerticalDivider(color: Colors.white24, width: 20),
            Expanded(
              child: _infoTile(
                Icons.restaurant_menu_rounded,
                "Edibility",
                mushroom.edibility,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningSection(Mushroom mushroom) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.gpp_bad_rounded, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text(
                "TOXICITY ALERT",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...mushroom.symptoms.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "•",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorphologySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: 28,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Text(
              "Identification Guide",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            "Carefully examine the cap shape, gill attachment, and stem base. Proper identification requires observing these key features in detail. Always consult an expert before consumption.",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
