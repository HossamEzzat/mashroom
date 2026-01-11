class ViewHistory {
  final String id;
  final String mushroomName;
  final String scientificName;
  final String imagePath;
  final DateTime dateScanned;
  final bool isToxic;

  ViewHistory({
    required this.id,
    required this.mushroomName,
    required this.scientificName,
    required this.imagePath,
    required this.dateScanned,
    required this.isToxic,
  });

  // Convert to Map for Local Storage (Sqflite/SharedPrefs)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mushroomName': mushroomName,
      'scientificName': scientificName,
      'imagePath': imagePath,
      'dateScanned': dateScanned.toIso8601String(),
      'isToxic': isToxic ? 1 : 0,
    };
  }

  // Create from Map
  factory ViewHistory.fromMap(Map<String, dynamic> map) {
    return ViewHistory(
      id: map['id'],
      mushroomName: map['mushroomName'],
      scientificName: map['scientificName'],
      imagePath: map['imagePath'],
      dateScanned: DateTime.parse(map['dateScanned']),
      isToxic: map['isToxic'] == 1,
    );
  }
}
