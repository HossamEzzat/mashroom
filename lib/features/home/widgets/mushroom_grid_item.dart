import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mashroom/models/plant_model.dart';
import '../screens/plant_detail_screen.dart';

/// Grid view widget for displaying mushrooms
class MushroomGridView extends StatelessWidget {
  final List<Mushroom> mushrooms;

  const MushroomGridView({super.key, required this.mushrooms});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: MasonryGridView(
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          const Text(
            "Found\n15 Results",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              height: 1.1,
            ),
          ),
          for (var mushroom in mushrooms) MushroomGridItem(mushroom: mushroom),
        ],
      ),
    );
  }
}

/// Individual mushroom grid item widget
class MushroomGridItem extends StatelessWidget {
  final Mushroom mushroom;

  const MushroomGridItem({super.key, required this.mushroom});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MushroomDetailScreen(mushroom: mushroom),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: mushroom.image,
                child: Image.asset(
                  mushroom.image,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              mushroom.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              mushroom.type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: mushroom.type == "Poisonous" ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              mushroom.habitat,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
