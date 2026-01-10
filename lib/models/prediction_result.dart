/// Model class to hold mushroom prediction results
class PredictionResult {
  final String prediction;
  final double? confidence;
  final Map<String, double>? probabilities;
  final String? error;

  PredictionResult({
    required this.prediction,
    this.confidence,
    this.probabilities,
    this.error,
  });

  /// Check if the result has an error
  bool get hasError => error != null && error!.isNotEmpty;

  /// Factory constructor from JSON
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'] as String? ?? 'Unknown',
      confidence: json['confidence'] as double?,
      probabilities: json['probabilities'] != null
          ? Map<String, double>.from(json['probabilities'] as Map)
          : null,
      error: json['error'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'confidence': confidence,
      'probabilities': probabilities,
      'error': error,
    };
  }

  /// Create an error result
  factory PredictionResult.error(String errorMessage) {
    return PredictionResult(
      prediction: 'Error',
      error: errorMessage,
    );
  }
}
