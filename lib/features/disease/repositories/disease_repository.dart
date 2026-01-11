import 'dart:convert';
import 'dart:io';

import '../../../models/prediction_result.dart';

/// Define an interface to allow for easy mocking/testing
abstract class IDiseaseRepository {
  Future<PredictionResult> classifyImage(File imageFile);
}

class DiseaseRepository implements IDiseaseRepository {
  static const String _apiEndpoint = 'https://api.mushroom-ai.com/v1/classify';

  @override
  Future<PredictionResult> classifyImage(File imageFile) async {
    try {
      // 1. Validate Image
      if (!await imageFile.exists()) {
        return PredictionResult.error('Image file does not exist');
      }

      // 2. Prepare Data (Optional: Compress image here if using a real API)
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 3. Network Call with Timeout
      // For now, we keep the delay to simulate the ML inference time
      await Future.delayed(const Duration(seconds: 1));

      // 4. API Logic (Uncomment for production)
      /*
      final response = await http.post(
        Uri.parse(_apiEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PredictionResult.fromJson(data);
      } else {
        return PredictionResult.error('Server Error: ${response.statusCode}');
      }
      */

      // 5. Success Mock
      return _generateMockSuccess();
    } on SocketException {
      return PredictionResult.error('No internet connection');
    } on PathNotFoundException {
      return PredictionResult.error('Image path is invalid');
    } catch (e) {
      return PredictionResult.error('Unexpected error: ${e.toString()}');
    }
  }

  PredictionResult _generateMockSuccess() {
    return PredictionResult(
      prediction: 'Agaricus Bisporus',
      confidence: 0.92,
      probabilities: {
        'Agaricus Bisporus': 0.92,
        'Amanita Muscaria': 0.05,
        'Boletus Edulis': 0.02,
        'Other': 0.01,
      },
    );
  }
}
