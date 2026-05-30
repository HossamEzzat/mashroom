import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/prediction_result.dart';
import '../../../core/constants/api_endpoints.dart';

/// Define an interface to allow for easy mocking/testing
abstract class IDiseaseRepository {
  Future<PredictionResult> classifyImage(File imageFile);
}

class DiseaseRepository implements IDiseaseRepository {
  final String apiUrl;

  DiseaseRepository({this.apiUrl = ApiEndpoints.predictLocal});

  @override
  Future<PredictionResult> classifyImage(File imageFile) async {
    try {
      // 1. Validate Image
      if (!await imageFile.exists()) {
        return PredictionResult.error('Image file does not exist');
      }

      // 2. Prepare Data (Optional: Compress image here if using a real API)
      // final bytes = await imageFile.readAsBytes();
      // final base64Image = base64Encode(bytes);

      // 3. Network Call with Timeout
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Bypass-Tunnel-Reminder'] = 'true';
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PredictionResult.fromJson(data);
      } else {
        return PredictionResult.error('Server Error: ${response.statusCode}');
      }
    } on SocketException {
      return PredictionResult.error('No internet connection');
    } on PathNotFoundException {
      return PredictionResult.error('Image path is invalid');
    } catch (e) {
      return PredictionResult.error('Unexpected error: ${e.toString()}');
    }
  }
}
