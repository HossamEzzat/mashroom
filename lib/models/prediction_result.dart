class PredictionResult {
  final String prediction;
  final double? confidence;
  final Map<String, double>? probabilities;
  final String? error;

  // New Enhanced Fields
  final bool isHighlyConfident;
  final bool hasLookalikeRisk;

  PredictionResult({
    required this.prediction,
    this.confidence,
    this.probabilities,
    this.error,
  }) : // Logic: Confidence > 80% is considered a stable match
       isHighlyConfident = (confidence ?? 0.0) >= 0.8,
       // Logic: If the 2nd highest probability is close to the 1st, flag as risk
       hasLookalikeRisk = _calculateLookalikeRisk(probabilities);

  /// Helper to detect if two classes have very close probability scores
  static bool _calculateLookalikeRisk(Map<String, double>? probs) {
    if (probs == null || probs.length < 2) return false;
    var values = probs.values.toList()..sort((a, b) => b.compareTo(a));
    // If the difference between top 1 and top 2 is less than 15%, it's risky
    return (values[0] - values[1]) < 0.15;
  }

  bool get hasError => error != null && error!.isNotEmpty;

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'] as String? ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble(),
      probabilities: json['probabilities'] != null
          ? Map<String, double>.from(json['probabilities'] as Map)
          : null,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'prediction': prediction,
    'confidence': confidence,
    'probabilities': probabilities,
    'error': error,
  };

  factory PredictionResult.error(String errorMessage) =>
      PredictionResult(prediction: 'Error', error: errorMessage);
}
