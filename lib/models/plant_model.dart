class Mushroom {
  final String name;
  final String image;
  final String type;
  final String habitat;
  final String edibility;
  final String description;
  final List<String> symptoms;
  final String sporePrintColor;

  Mushroom({
    required this.name,
    required this.image,
    required this.type,
    required this.habitat,
    required this.edibility,
    required this.description,
    required this.symptoms,
    required this.sporePrintColor,
  });

  // Helper to identify high-risk mushrooms in the UI
  bool get isDangerous =>
      type.toLowerCase().contains('poisonous') ||
      type.toLowerCase().contains('toxic');

  // Serialization support
  factory Mushroom.fromJson(Map<String, dynamic> json) {
    return Mushroom(
      name: json['name'],
      image: json['image'],
      type: json['type'],
      habitat: json['habitat'],
      edibility: json['edibility'],
      description: json['description'],
      symptoms: List<String>.from(json['symptoms'] ?? []),
      sporePrintColor: json['sporePrintColor'],
    );
  }
}
