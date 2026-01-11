class MushroomData {
  final String mushroomName;
  final String healthStatus; // Healthy, Unhealthy, Caution
  final String overview;
  final List<String> recommendedRecipes;
  final List<String> alternativeSuggestions;
  final bool isToxic; // Safety flag
  final Map<String, String>?
  identificationTraits; // {Cap: 'Convex', Gills: 'Free'}

  MushroomData({
    required this.mushroomName,
    required this.healthStatus,
    required this.overview,
    required this.recommendedRecipes,
    required this.alternativeSuggestions,
    this.isToxic = false,
    this.identificationTraits,
  });

  // Factory to safely create data from JSON
  factory MushroomData.fromMap(Map<String, dynamic> map) {
    return MushroomData(
      mushroomName: map['name'] ?? 'Unknown',
      healthStatus: map['status'] ?? 'Unknown',
      overview: map['overview'] ?? '',
      recommendedRecipes: List<String>.from(map['recipes'] ?? []),
      alternativeSuggestions: List<String>.from(map['alternatives'] ?? []),
      isToxic: map['isToxic'] ?? false,
      identificationTraits: Map<String, String>.from(map['traits'] ?? {}),
    );
  }
}

class MushroomInfo {
  static final Map<String, MushroomData> _data = {
    'agaricus': MushroomData(
      mushroomName: 'Agaricus (Button Mushroom)',
      healthStatus: 'Healthy',
      overview: 'Includes edible species like A. bisporus. High in B vitamins.',
      recommendedRecipes: ['Grilled Agaricus', 'Stuffed Button Mushrooms'],
      alternativeSuggestions: ['Pleurotus ostreatus'],
      isToxic: false,
      identificationTraits: {
        'Cap': 'Smooth, white to brown',
        'Gills': 'Pink when young, turning dark brown',
        'Stem': 'Thick with a distinct ring',
      },
    ),
    'amanita': MushroomData(
      mushroomName: 'Amanita (Death Cap / Fly Agaric)',
      healthStatus: 'Unhealthy',
      isToxic: true,
      overview:
          'Extremely dangerous. Contains amatoxins which cause liver failure.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Agaricus bisporus (SAFE LOOKALIKES)'],
      identificationTraits: {
        'Cap': 'Often has white warts/spots',
        'Gills': 'White and free from the stem',
        'Base': 'Check for a bulbous volva (cup) at the base',
      },
    ),
  };

  static MushroomData getMushroomData(String prediction) {
    // Regex helps remove special characters or scientific sub-names
    final normalized = prediction.trim().toLowerCase().split(' ').first;

    return _data[normalized] ?? _buildUnknown(prediction);
  }

  static MushroomData _buildUnknown(String name) {
    return MushroomData(
      mushroomName: name.isNotEmpty ? name : 'Unknown Specimen',
      healthStatus: 'Unknown',
      overview: 'Safety data not available. Do not consume.',
      recommendedRecipes: [],
      alternativeSuggestions: [],
      isToxic: true, // Default to true for safety if unknown
    );
  }
}
