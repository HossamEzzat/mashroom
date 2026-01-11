import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

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

  // Replace with your actual Gemini API key
  final String _apiKey = 'YOUR_API_KEY';

  Future<void> _generateRecipe(String userPrompt) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _recipeData = null;
    });

    try {
      final String aiPrompt = '''
      You are a mushroom sustainability expert. 
      Generate a recipe using edible mushrooms: Agaricus, Boletus, etc.
      Return the data strictly in this Markdown format:
      # [Title]
      [Short Description]
      - Calories: [X] kcal | Time: [Y] mins
      ## Ingredients
      - [Item]
      ## Directions
      1. [Step]
      ## Sustainability
      - [Benefit]
      ''';

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent',
        ),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': "$aiPrompt \n User request: $userPrompt"},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates'][0]['content']['parts'][0]['text'];
        _parseResponse(rawText);
      } else {
        throw Exception('API limit reached or key invalid.');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _parseResponse(String text) {
    // Simple robust parsing using Split logic
    final sections = text.split('##');
    setState(() {
      _recipeData = {
        'full': text,
        'title': text.split('\n').first.replaceAll('#', '').trim(),
        'ingredients': sections.firstWhere(
          (s) => s.contains('Ingredients'),
          orElse: () => '',
        ),
        'directions': sections.firstWhere(
          (s) => s.contains('Directions'),
          orElse: () => '',
        ),
        'sustainability': sections.firstWhere(
          (s) => s.contains('Sustainability'),
          orElse: () => '',
        ),
      };
    });
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
  Widget _buildErrorState() =>
      Text(_errorMessage, style: const TextStyle(color: Colors.red));
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
            'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=400',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        MarkdownBody(data: data['full']),
      ],
    );
  }
}
