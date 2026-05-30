import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_endpoints.dart';

class GeoRepository {
  Future<Map<String, dynamic>> fetchOptions() async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.geoOptions),
        headers: {'Bypass-Tunnel-Reminder': 'true'},
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Server Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load options: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> fetchRecommendations(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.geoRecommend),
        headers: {
          'Content-Type': 'application/json',
          'Bypass-Tunnel-Reminder': 'true'
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 60));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Server Error: ${response.statusCode} - ${response.body}');
    } catch (e) {
      throw Exception('Failed to get recommendations: ${e.toString()}');
    }
  }
}
