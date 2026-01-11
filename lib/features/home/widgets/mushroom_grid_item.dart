import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mashroom/models/plant_model.dart';

import '../screens/plant_detail_screen.dart';

class MushroomGridView extends StatefulWidget {
  final List<Mushroom> mushrooms;

  const MushroomGridView({super.key, required this.mushrooms});

  @override
  State<MushroomGridView> createState() => _MushroomGridViewState();
}

class _MushroomGridViewState extends State<MushroomGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create staggered animations for each item
    _itemAnimations = List.generate(widget.mushrooms.length, (index) {
      final start = (index * 0.1).clamp(0.0, 0.6);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section - Now spans full width
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text.rich(
            TextSpan(
              text: "Found\n",
              style: const TextStyle(
                fontSize: 32,
                height: 1.1,
                color: Colors.grey,
              ),
              children: [
                TextSpan(
                  text: "${widget.mushrooms.length} Results",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Grid Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.mushrooms.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _itemAnimations[index],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _itemAnimations[index].value)),
                    child: Opacity(
                      opacity: _itemAnimations[index].value,
                      child: MushroomGridItem(
                        mushroom: widget.mushrooms[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class MushroomGridItem extends StatelessWidget {
  final Mushroom mushroom;

  const MushroomGridItem({super.key, required this.mushroom});

  @override
  Widget build(BuildContext context) {
    // Determine edibility status for UI cues
    final bool isPoisonous = mushroom.type.toLowerCase().contains("poisonous");
    final Color accentColor = isPoisonous ? Colors.red : Colors.teal;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MushroomDetailScreen(mushroom: mushroom),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Identification Badge
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Hero(
                    tag: mushroom.image,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(mushroom.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(
                    isPoisonous
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color: accentColor.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mushroom.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildHabitatTag(mushroom.habitat),
                  const SizedBox(height: 12),
                  _buildStatusFooter(mushroom.type, accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitatTag(String habitat) {
    return Row(
      children: [
        Icon(Icons.terrain, size: 12, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            habitat,
            maxLines: 1,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFooter(String type, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
        const Icon(Icons.arrow_forward, size: 16, color: Colors.black12),
      ],
    );
  }
}
