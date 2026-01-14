import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/mushroom_data.dart';
import '../../../core/providers/favorites_provider.dart';
import '../../home/widgets/mushroom_grid_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, child) {
          final favoriteMushrooms = mushroomList
              .where((m) => provider.isFavorite(m.name))
              .toList();

          if (favoriteMushrooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mark mushrooms as favorite to see them here",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MushroomGridView(mushrooms: favoriteMushrooms),
          );
        },
      ),
    );
  }
}
