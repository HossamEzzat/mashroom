import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';

class SustainableRecipeScreen extends StatefulWidget {
  const SustainableRecipeScreen({super.key});

  @override
  State<SustainableRecipeScreen> createState() =>
      _SustainableRecipeScreenState();
}

class _SustainableRecipeScreenState extends State<SustainableRecipeScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Recipe Data Object
  Map<String, dynamic>? _recipeData;

  // Static Recipe Database
  final List<Map<String, String>> _staticRecipes = [
    {
      'title': 'Warm Mushroom Soup with Agaricus',
      'image': 'https://images.unsplash.com/photo-1548943487-a2e4e43b4859?q=80&w=600',
      'full': '''
A comforting and creamy soup perfect for cold evenings.
- Calories: 250 kcal | Time: 30 mins

## Ingredients
- 200g Agaricus mushrooms
- 1 cup vegetable broth
- 1/2 cup cream
- Onion and garlic

## Directions
1. Sauté onion and garlic.
2. Add mushrooms and cook until brown.
3. Pour in broth and simmer.
4. Blend until smooth and stir in cream.

## Sustainability
- Agaricus mushrooms have a very low carbon footprint and require minimal water.
      ''',
    },
    {
      'title': 'Grilled Portobello Burgers',
      'image': 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=600',
      'full': '''
A hearty, meatless burger alternative packed with umami.
- Calories: 320 kcal | Time: 20 mins

## Ingredients
- 4 large Portobello mushrooms
- Burger buns
- Lettuce, tomato, cheese
- Olive oil and balsamic vinegar

## Directions
1. Marinate mushrooms in oil and vinegar.
2. Grill for 5-7 minutes on each side.
3. Assemble burgers with toppings.

## Sustainability
- Replacing beef with Portobello reduces greenhouse gas emissions by up to 90%.
      ''',
    },
    {
      'title': 'Shiitake Stir-Fry',
      'image': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=600',
      'full': '''
A quick, vibrant vegetable and mushroom stir-fry.
- Calories: 210 kcal | Time: 15 mins

## Ingredients
- 150g Shiitake mushrooms
- Broccoli, carrots, bell peppers
- Soy sauce, ginger, sesame oil

## Directions
1. Slice mushrooms and chop vegetables.
2. Wok-fry on high heat with ginger.
3. Add soy sauce and sesame oil. Serve hot.

## Sustainability
- Shiitake cultivation helps recycle agricultural waste like sawdust.
      ''',
    }
  ];

  Future<void> _generateRecipe(String userPrompt) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _recipeData = null;
    });

    // Simulate network delay for a better user experience
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      Map<String, String> selected;
      
      if (userPrompt.isEmpty) {
        // Pick a random recipe if search is empty
        selected = _staticRecipes[DateTime.now().millisecondsSinceEpoch % _staticRecipes.length];
      } else {
        // Search by title or content
        final query = userPrompt.toLowerCase();
        final matches = _staticRecipes.where((r) => 
          r['title']!.toLowerCase().contains(query) || 
          r['full']!.toLowerCase().contains(query)
        ).toList();
        
        if (matches.isNotEmpty) {
          selected = matches.first;
        } else {
          // Fallback if no match found
          selected = _staticRecipes.first; 
        }
      }

      setState(() {
        _recipeData = {
          'title': selected['title'],
          'image': selected['image'],
          'full': selected['full'],
        };
      });
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred while loading the recipe. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Green Kitchen'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputSection(),
            const SizedBox(height: 30),
            if (_isLoading) _buildLoadingState(),
            if (_errorMessage.isNotEmpty) _buildErrorState(),
            if (_recipeData != null) RecipeResultWidget(data: _recipeData!),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          TextField(
            controller: _promptController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Search: "Warm mushroom soup with Agaricus"',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () => _generateRecipe(_promptController.text),
            child: const Text('Generate Green Recipe'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() =>
      const Center(child: CircularProgressIndicator());
  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red.shade900, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-Widget for Cleanliness
class RecipeResultWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const RecipeResultWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['title'],
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            data['image'] ?? 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=400',
            fit: BoxFit.cover,
            height: 250,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 20),
        MarkdownBody(data: data['full']),
      ],
    );
  }
}
