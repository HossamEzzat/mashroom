import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/constants/app_constants.dart';

class SustainableRecipeScreen extends StatefulWidget {
  const SustainableRecipeScreen({super.key});

  @override
  State<SustainableRecipeScreen> createState() =>
      _SustainableRecipeScreenState();
}

class _SustainableRecipeScreenState extends State<SustainableRecipeScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedRecipe = '';
  bool _isLoading = false;
  String _errorMessage = '';
  String _recipeTitle = '';
  String _recipeSubtitle = '';
  String _description = '';
  String _calories = '1';
  String _prepTime = '';

  // Replace with your actual Gemini API key
  final String _apiKey = 'AIzaSyCk8dM2y4Up7dETzdsmYsZ03I94Ywcdh_I';

  Future<void> _generateRecipe(String userPrompt) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _generatedRecipe = '';
      _recipeTitle = '';
      _recipeSubtitle = '';
      _description = '';
      _calories = '';
      _prepTime = '';
    });

    try {
      final String aiPrompt = '''
You are a culinary expert focused on creating sustainable recipes using safe-to-eat mushrooms only. 

Generate a healthy and sustainable recipe that includes **only** edible mushrooms from the following list: Agaricus, Boletus, Lactarius, Russula, Suillus, Hygrocybe, Pluteus, Exidia. 
Do not use any toxic or potentially dangerous mushrooms like Amanita, Inocybe, Entoloma, or Cortinarius.

Follow this exact format for the response:
- Make the recipe title bold.
- Align all icons to the left side.
- Include calories and preparation time clearly.
- Use ingredients in short format with emojis or icons (e.g. 🧅 onion - 100g).
- Write the directions in a beautifully ordered list.
- Include a final section on sustainability benefits as bullet points.

Use this markdown structure:
# Recipe Name  
Subtitle (optional)

## Calories | Time  
- 250 kcal | 25 minutes  

## Ingredients  
- 🍄 200g fresh Agaricus mushrooms  
- 🧄 1 garlic clove, minced  
- 🧅 1 small onion  
- 🧂 Pinch of salt  
- 🌿 10mL olive oil  

### Direction  
1. Clean and slice the mushrooms.  
2. Sauté onions and garlic in olive oil.  
3. Add mushrooms and cook until golden.  
4. Season with salt and serve warm.  

## Sustainability Benefits  
- 🌍 Uses locally grown mushrooms with low carbon footprint   
- ♻️  Minimal waste from ingredients  
- ⚡ Quick cooking method to reduce energy use 

Use metric units only (g, mL, °C) and make sure the recipe is both practical and safe.
''';

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent'),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': aiPrompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recipeText = data['candidates'][0]['content']['parts'][0]['text'];

        // Parse the recipe components
        final lines = recipeText.split('\n');
        setState(() {
          _recipeTitle =
              lines.isNotEmpty ? lines[0].replaceFirst('# ', '') : '';
          _recipeSubtitle = lines.length > 1 ? lines[1] : '';
          if (lines.length > 2 &&
              lines[2].isNotEmpty &&
              !lines[2].startsWith('##')) {
            _description = lines[2];
          }
          if (lines.length > 4 && lines[4].startsWith('-')) {
            final info = lines[4].split('|');
            if (info.length >= 2) {
              _calories = info[0].replaceFirst('- ', '').trim();
              _prepTime = info[1].trim();
            } else {
              _calories = 'N/A';
              _prepTime = 'N/A';
            }
          }
          _generatedRecipe = recipeText;
        });
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate recipe: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRecipeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          _recipeTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          _recipeSubtitle,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            'https://images.unsplash.com/photo-1519996529931-28324d5a630e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&h=200&q=80',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Text('Image failed to load')),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Description
        if (_description.isNotEmpty)
          Text(
            _description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Calories
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                margin: const EdgeInsets.only(
                    right: 8), // Add spacing between the two boxes
                decoration: BoxDecoration(
                  color: const Color(0xffe08de8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 25,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      // Wrap text column to avoid overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _calories,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Calories',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Time
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(
                    left: 20), // Add spacing between the two boxes
                decoration: BoxDecoration(
                  color: const Color(0xffe08de8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _prepTime,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Ingredients Section
        ExpansionTile(
          title: const Text(
            'Ingredients',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Image.network(
            'https://cdn-icons-png.flaticon.com/512/2985/2985150.png',
            width: 24,
            height: 24,
            color: Colors.black,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.expand_more, color: Colors.black),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _generatedRecipe.isEmpty
                  ? const Text('No ingredients available yet.')
                  : MarkdownBody(
                      data: _generatedRecipe
                          .split('## Ingredients')[1]
                          .split('### Direction')[0],
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                            fontSize: 14, color: Color(0xFF666666)),
                        listBullet: const TextStyle(
                            fontSize: 14, color: Color(0xFF666666)),
                      ),
                    ),
            ),
          ],
        ),

        // Directions Section
        ExpansionTile(
          title: const Text(
            'Directions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Image.network(
            'https://cdn-icons-png.flaticon.com/512/2985/2985150.png',
            width: 24,
            height: 24,
            color: Colors.black,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.expand_more, color: Colors.black),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _generatedRecipe.isEmpty
                      ? const Text('No directions available yet.')
                      : MarkdownBody(
                          data: _generatedRecipe
                              .split('### Direction')[1]
                              .split('## Sustainability')[0],
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                                fontSize: 14, color: Color(0xFF666666)),
                            h3: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),

        // Sustainability Benefits
        ExpansionTile(
          title: const Text(
            'Sustainability Benefits',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Image.network(
            'https://cdn-icons-png.flaticon.com/512/2985/2985150.png',
            width: 24,
            height: 24,
            color: Colors.black,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.expand_more, color: Colors.black),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _generatedRecipe.isEmpty
                  ? const Text('No benefits available yet.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _generatedRecipe
                          .split('## Sustainability Benefits')[1]
                          .split('\n')
                          .where((line) => line.startsWith('-'))
                          .map((benefit) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      benefit.replaceFirst('- ', ''),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666)),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Recipe',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.network(
              'https://cdn-icons-png.flaticon.com/512/1077/1077035.png',
              width: 24,
              height: 24,
              color: Colors.black,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.favorite_border, color: Colors.black),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Your Sustainable Recipe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptController,
                      decoration: InputDecoration(
                        hintText:
                            'E.g., "Quick vegan meal with sweet potatoes and lentils"',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () => _generateRecipe(_promptController.text),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: AppConstants
                              .gradientColor, // Use the same gradient color
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Generate Recipe",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Results Section
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),

              if (_generatedRecipe.isNotEmpty) ...[
                const Text(
                  'Your Sustainable Recipe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecipeCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}
