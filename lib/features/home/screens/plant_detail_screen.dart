import 'package:flutter/material.dart';
import 'package:mashroom/models/plant_model.dart';

import '../../../core/theme/app_colors.dart';

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
            backgroundColor: Colors.white.withOpacity(0.8),
            child: const BackButton(color: Colors.black),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: const Icon(Icons.favorite_border, color: Colors.red),
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
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.05),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
          ),
          child: PageView.builder(
            itemCount: 3, // Assuming 3 gallery images
            onPageChanged: (value) => setState(() => currentIndex = value),
            itemBuilder: (context, index) => Hero(
              tag: mushroom.image,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(mushroom.image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => _buildIndicator(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index ? AppColors.primary : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitleSection(Mushroom mushroom, bool isPoisonous) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mushroom.name,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (isPoisonous ? Colors.red : Colors.green).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            mushroom.type.toUpperCase(),
            style: TextStyle(
              color: isPoisonous ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(Mushroom mushroom) {
    return Text(
      mushroom.description,
      style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
    );
  }

  Widget _buildQuickInfoGrid(Mushroom mushroom) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoTile(Icons.terrain, "Habitat", mushroom.habitat),
          _infoTile(Icons.colorize, "Spore", mushroom.sporePrintColor),
          _infoTile(Icons.restaurant, "Edibility", mushroom.edibility),
        ],
      ),
    );
  }

  Widget _buildWarningSection(Mushroom mushroom) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "TOXICITY ALERT",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...mushroom.symptoms.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "• $s",
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
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
        const Text(
          "Anatomy & Identification",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Text(
          "Carefully examine the cap shape, gill attachment, and stem base. Proper identification requires observing these key features.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
