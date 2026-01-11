class Plant {
  final String plantType;
  final String plantName;
  final double plantPrice;
  final String image;
  final double stars;
  final PlantMetrics metrics;
  final bool isFavorite; // Added for UI state

  Plant({
    required this.plantType,
    required this.plantName,
    required this.plantPrice,
    required this.image,
    required this.stars,
    required this.metrics,
    this.isFavorite = false,
  });

  // Allows creating a new version of the plant with specific changes
  Plant copyWith({bool? isFavorite}) {
    return Plant(
      plantType: plantType,
      plantName: plantName,
      plantPrice: plantPrice,
      image: image,
      stars: stars,
      metrics: metrics,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class PlantMetrics {
  final String height;
  final String humidity;
  final String width;

  const PlantMetrics({
    required this.height,
    required this.humidity,
    required this.width,
  });
}
