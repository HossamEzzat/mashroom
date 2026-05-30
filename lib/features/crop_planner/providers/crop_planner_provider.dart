import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crop_responses.dart';
import '../repositories/crop_planner_repository.dart';

class CropPlannerProvider extends ChangeNotifier {
  final CropPlannerRepository _repository = CropPlannerRepository();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Responses
  CropOptimizeResponse? _optimizeResponse;
  CropOptimizeResponse? get optimizeResponse => _optimizeResponse;

  CropRecommendResponse? _recommendResponse;
  CropRecommendResponse? get recommendResponse => _recommendResponse;

  // Input Data
  double n = 60.0;
  double p = 25.0;
  double k = 110.0;
  double ph = 6.5;
  double waterLimit = 250.0;
  double budget = 350.0;
  double areaHa = 5.0;

  // Environment Data
  String locationName = 'Fayoum, Egypt';
  double temperature = 24.0;
  double humidity = 60.0;
  double rainfall = 80.0;
  double latitude = 29.3084;
  double longitude = 30.8428;
  bool isFetchingLocation = false;

  // Selected Goal
  String selectedGoal = 'sustainability_first';

  // Available Goals
  final List<String> goals = ['balanced', 'sustainability_first', 'profit_first', 'water_saving', 'low_carbon'];

  CropPlannerProvider() {
    _loadPersistedLocation();
  }

  Future<void> _loadPersistedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('crop_planner_lat')) {
        latitude = prefs.getDouble('crop_planner_lat') ?? latitude;
        longitude = prefs.getDouble('crop_planner_lon') ?? longitude;
        locationName = prefs.getString('crop_planner_name') ?? locationName;
        temperature = prefs.getDouble('crop_planner_temp') ?? temperature;
        humidity = prefs.getDouble('crop_planner_humidity') ?? humidity;
        rainfall = prefs.getDouble('crop_planner_rainfall') ?? rainfall;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading persisted location: $e');
    }
  }

  Future<void> _savePersistedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('crop_planner_lat', latitude);
      await prefs.setDouble('crop_planner_lon', longitude);
      await prefs.setString('crop_planner_name', locationName);
      await prefs.setDouble('crop_planner_temp', temperature);
      await prefs.setDouble('crop_planner_humidity', humidity);
      await prefs.setDouble('crop_planner_rainfall', rainfall);
    } catch (e) {
      debugPrint('Error saving location: $e');
    }
  }

  void setGoal(String goal) {
    selectedGoal = goal;
    notifyListeners();
  }

  void updateInputs({
    double? newN,
    double? newP,
    double? newK,
    double? newPh,
    double? newWater,
    double? newBudget,
    double? newArea,
  }) {
    if (newN != null) n = newN;
    if (newP != null) p = newP;
    if (newK != null) k = newK;
    if (newPh != null) ph = newPh;
    if (newWater != null) waterLimit = newWater;
    if (newBudget != null) budget = newBudget;
    if (newArea != null) areaHa = newArea;
    notifyListeners();
  }

  Future<void> fetchLocationAndWeather() async {
    isFetchingLocation = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) throw Exception('Location permissions are permanently denied');

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      
      // Fetch Weather from Open-Meteo
      final weatherUrl = 'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m,relative_humidity_2m,precipitation';
      final weatherRes = await http.get(Uri.parse(weatherUrl)).timeout(const Duration(seconds: 10));
      if (weatherRes.statusCode == 200) {
        final wData = jsonDecode(weatherRes.body);
        temperature = (wData['current']['temperature_2m'] as num).toDouble();
        humidity = (wData['current']['relative_humidity_2m'] as num).toDouble();
        rainfall = (wData['current']['precipitation'] as num).toDouble();
      }

      // Fetch Location Name from Nominatim
      try {
        final locUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
        final locRes = await http.get(Uri.parse(locUrl), headers: {'User-Agent': 'MashroomApp/1.0'}).timeout(const Duration(seconds: 10));
        if (locRes.statusCode == 200) {
          final lData = jsonDecode(locRes.body);
          locationName = lData['address']['city'] ?? lData['address']['state'] ?? lData['address']['country'] ?? 'Current Location';
        } else {
          locationName = 'Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}';
        }
      } catch (e) {
        locationName = 'Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}';
      }

      // Persist the fetched location
      await _savePersistedLocation();

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isFetchingLocation = false;
      notifyListeners();
    }
  }

  Future<void> runOptimization() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _optimizeResponse = await _repository.optimizeCropPlan(
        n: n,
        p: p,
        k: k,
        ph: ph,
        waterLimit: waterLimit,
        budget: budget,
        goal: selectedGoal,
        areaHa: areaHa,
        temperature: temperature,
        humidity: humidity,
        rainfall: rainfall,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _optimizeResponse = null;
    _recommendResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
