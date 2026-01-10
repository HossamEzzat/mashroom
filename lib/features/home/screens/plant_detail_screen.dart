import 'package:flutter/material.dart';
import 'package:mashroom/models/plant_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class MushroomDetailScreen extends StatefulWidget {
  final Mushroom mushroom;

  const MushroomDetailScreen({super.key, required this.mushroom});

  @override
  State<MushroomDetailScreen> createState() => _MushroomDetailScreenState();
}

class _MushroomDetailScreenState extends State<MushroomDetailScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mushroom = widget.mushroom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppTheme.spacingM),
            child: Icon(
              Icons.local_florist_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Hero animation
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 3, // Same image, just for animation purpose
                    onPageChanged: (value) => setState(() {
                      currentIndex = value;
                    }),
                    itemBuilder: (context, index) => Hero(
                      tag: mushroom.image,
                      child: Image.asset(mushroom.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 100,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 5),
                        width: 7,
                        height: index == currentIndex ? 20 : 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: index == currentIndex
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mushroom Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                mushroom.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mushroom Type (Poisonous or Healthy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                mushroom.type,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: mushroom.type == 'Poisonous'
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Mushroom Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                mushroom.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  letterSpacing: -.3,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom sheet with additional mushroom info
      bottomSheet: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                mushroomInfo(Icons.terrain, "Habitat", mushroom.habitat),
                mushroomInfo(
                  Icons.color_lens,
                  "Spore Color",
                  mushroom.sporePrintColor,
                ),
                mushroomInfo(
                  Icons.info_outline,
                  "Edibility",
                  mushroom.edibility,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Symptoms if poisonous
            if (mushroom.type == "Poisonous") ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Common Symptoms",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...mushroom.symptoms.map(
                (symptom) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          symptom,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Reusable info block for mushroom properties
  Column mushroomInfo(IconData icon, String name, String value) => Column(
    children: [
      Icon(icon, size: 40, color: Colors.white),
      const SizedBox(height: 6),
      Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade200),
      ),
    ],
  );
}
