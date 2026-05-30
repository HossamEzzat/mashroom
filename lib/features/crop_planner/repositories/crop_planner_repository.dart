import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crop_responses.dart';
import '../../../core/constants/api_endpoints.dart';

class CropPlannerRepository {

  Future<CropOptimizeResponse> optimizeCropPlan({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double waterLimit,
    required double budget,
    required String goal,
    required double areaHa,
    required double temperature,
    required double humidity,
    required double rainfall,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.cropOptimize),
        headers: {
          'Content-Type': 'application/json',
          'Bypass-Tunnel-Reminder': 'true'
        },
        body: jsonEncode({
          'n': n,
          'p': p,
          'k': k,
          'ph': ph,
          'temperature': temperature,
          'humidity': humidity,
          'rainfall': rainfall,
          'water_limit_m3': waterLimit,
          'budget_usd': budget,
          'profile': goal,
          'area_ha': areaHa,
        }),
      ).timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        return CropOptimizeResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('No optimization solutions found for these inputs.');
      } else {
        throw Exception('Server error: Unable to process your request at this time.');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: ${e.toString()}');
      }
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<CropRecommendResponse> recommendCrop({
    required double n,
    required double p,
    required double k,
    required double ph,
    required double areaHa,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.cropRecommend),
        headers: {
          'Content-Type': 'application/json',
          'Bypass-Tunnel-Reminder': 'true'
        },
        body: jsonEncode({
          'n': n,
          'p': p,
          'k': k,
          'ph': ph,
          'temperature': 24.0,
          'humidity': 60.0,
          'rainfall': 80.0,
          'area_ha': areaHa,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        return CropRecommendResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Server error: Unable to fetch recommendations.');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: ${e.toString()}');
      }
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
