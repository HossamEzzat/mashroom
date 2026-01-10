import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../screens/disease_prediction_screen.dart';
import '../../home/screens/home_screen.dart';

class PlantPredictionCards extends StatelessWidget {
  final Function(int)? onTabChange; // Callback to change the tab in MainScreen

  const PlantPredictionCards(
      {super.key, this.onTabChange}); // Add onTabChange to the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text("Mushroom Prediction Guide"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Card 1 - Plant Disease
            Card(
              color: AppColors.cardPink,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/mushroom.jpg', // Add your own image in the assets
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Mushroom Disease Classification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text(
                        'Learn About Mushroom Diseases and Their Prevention'),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.black),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DiseasePredictionScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Spacing between cards
          ],
        ),
      ),
    );
  }
}
