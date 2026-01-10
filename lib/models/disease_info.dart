class MushroomData {
  final String mushroomName;
  final String healthStatus;
  final String overview;
  final List<String> recommendedRecipes;
  final List<String> alternativeSuggestions;

  MushroomData({
    required this.mushroomName,
    required this.healthStatus,
    required this.overview,
    required this.recommendedRecipes,
    required this.alternativeSuggestions,
  });
}

class MushroomInfo {
  static final Map<String, MushroomData> mushroomInfo = {
    'agaricus': MushroomData(
      mushroomName: 'Agaricus',
      healthStatus: 'Healthy',
      overview: 'Includes edible species like Agaricus bisporus, rich in nutrients, but some lookalikes are toxic.',
      recommendedRecipes: ['Grilled Agaricus', 'Stuffed Button Mushrooms'],
      alternativeSuggestions: ['Pleurotus ostreatus', 'Lentinus edodes'],
    ),
    'amanita': MushroomData(
      mushroomName: 'Amanita',
      healthStatus: 'Unhealthy',
      overview: 'Includes extremely poisonous species such as Amanita phalloides (Death Cap). Avoid consumption.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Cantharellus cibarius', 'Boletus edulis'],
    ),
    'boletus': MushroomData(
      mushroomName: 'Boletus',
      healthStatus: 'Healthy',
      overview: 'Includes popular edible species like Boletus edulis (porcini). Nutty and rich flavor.',
      recommendedRecipes: ['Porcini Risotto', 'Sautéed Boletus'],
      alternativeSuggestions: [],
    ),
    'cortinarius': MushroomData(
      mushroomName: 'Cortinarius',
      healthStatus: 'Unhealthy',
      overview: 'Contains highly toxic species such as Cortinarius orellanus. Can cause kidney damage.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Lactarius deliciosus', 'Russula cyanoxantha'],
    ),
    'entoloma': MushroomData(
      mushroomName: 'Entoloma',
      healthStatus: 'Unhealthy',
      overview: 'Many Entoloma species are toxic. Proper identification is difficult and consumption is risky.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Pluteus cervinus'],
    ),
    'exidia': MushroomData(
      mushroomName: 'Exidia',
      healthStatus: 'Healthy',
      overview: 'Jelly fungi often used in soups. Exidia recisa is considered edible, while others may be mildly toxic.',
      recommendedRecipes: ['Exidia Soup', 'Stir-fried Jelly Fungus'],
      alternativeSuggestions: [],
    ),
    'hygrocybe': MushroomData(
      mushroomName: 'Hygrocybe',
      healthStatus: 'Caution',
      overview: 'Brightly colored mushrooms; most are inedible or mildly toxic. Rarely consumed.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Agaricus bisporus'],
    ),
    'inocybe': MushroomData(
      mushroomName: 'Inocybe',
      healthStatus: 'Unhealthy',
      overview: 'Dangerously toxic genus. Contains muscarine and can be fatal. Never consume.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Lentinus edodes', 'Pleurotus eryngii'],
    ),
    'lactarius': MushroomData(
      mushroomName: 'Lactarius',
      healthStatus: 'Healthy',
      overview: 'Includes species like Lactarius deliciosus, known for its orange milk and pleasant taste.',
      recommendedRecipes: ['Fried Lactarius', 'Lactarius Stew'],
      alternativeSuggestions: ['Russula cyanoxantha'],
    ),
    'pluteus': MushroomData(
      mushroomName: 'Pluteus',
      healthStatus: 'Healthy',
      overview: 'Some species like Pluteus cervinus are edible, others may have psychoactive effects.',
      recommendedRecipes: ['Grilled Pluteus', 'Mushroom Pilaf'],
      alternativeSuggestions: ['Agaricus bisporus'],
    ),
    'russula': MushroomData(
      mushroomName: 'Russula',
      healthStatus: 'Caution',
      overview: 'Some Russula species are edible, others like Russula emetica are toxic. Taste testing not recommended.',
      recommendedRecipes: [],
      alternativeSuggestions: ['Lactarius deliciosus'],
    ),
    'suillus': MushroomData(
      mushroomName: 'Suillus',
      healthStatus: 'Healthy',
      overview: 'Slimy-capped mushrooms, often edible like Suillus luteus. Best peeled and cooked.',
      recommendedRecipes: ['Suillus Soup', 'Pan-Fried Suillus'],
      alternativeSuggestions: ['Boletus edulis'],
    ),
  };

  static MushroomData getMushroomData(String prediction) {
    String normalizedPrediction = prediction.trim().toLowerCase();

    if (mushroomInfo.containsKey(normalizedPrediction)) {
      return mushroomInfo[normalizedPrediction]!;
    } else {
      return MushroomData(
        mushroomName: 'Unknown Mushroom',
        healthStatus: 'Unknown',
        overview: 'No information available for the given mushroom.',
        recommendedRecipes: [],
        alternativeSuggestions: [],
      );
    }
  }
}
