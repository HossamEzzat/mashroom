import 'dart:convert';
import 'package:flutter/services.dart';
import 'plant_model.dart';

class MushroomPair {
  final String className;
  final Mushroom safe;
  final Mushroom lookalike;
  final List<String> differences;

  MushroomPair({
    required this.className,
    required this.safe,
    required this.lookalike,
    required this.differences,
  });

  factory MushroomPair.fromJson(Map<String, dynamic> json) {
    return MushroomPair(
      className: json['class'],
      safe: _mushroomFromJson(json['safe_mushroom']),
      lookalike: _mushroomFromJson(json['lookalike']),
      differences: List<String>.from(json['differences']),
    );
  }
}

// Helper function to create Mushroom from JSON
Mushroom _mushroomFromJson(Map<String, dynamic> json) {
  return Mushroom(
    name: json['name'] ?? 'Unknown',
    image: json['image'] ?? '',
    type: json['type'] ?? 'Unknown',
    habitat: json['habitat'] ?? 'Unknown',
    edibility: json['edibility'] ?? 'Unknown',
    description: json['description'] ?? '',
    symptoms:
        json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
    sporePrintColor: json['spore_print_color'] ?? 'Unknown',
  );
}

Future<List<MushroomPair>> loadLookalikes() async {
  final jsonString = await rootBundle
      .loadString('assets/json_files/lookalikes_with_images.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((e) => MushroomPair.fromJson(e)).toList();
}
