/// API endpoint constants
class ApiEndpoints {
  // Base URL - Update this based on your environment
  static const String baseUrl = 'http://192.168.1.6:5000';

  // Disease Prediction
  static const String predictLocal = '$baseUrl/predict_local';
  static const String predictRoboflow = '$baseUrl/predict_roboflow';
  static const String predictCsf = '$baseUrl/predict_csf';
  static const String geoOptions = '$baseUrl/geo_options';
  static const String geoRecommend = '$baseUrl/geo_recommend';
}
