import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../repositories/geo_repository.dart';

class GeoRecommenderScreen extends StatefulWidget {
  const GeoRecommenderScreen({super.key});

  @override
  State<GeoRecommenderScreen> createState() => _GeoRecommenderScreenState();
}

class _GeoRecommenderScreenState extends State<GeoRecommenderScreen> {
  final GeoRepository _repo = GeoRepository();
  bool _isLoading = true;
  String? _error;

  Map<String, dynamic>? _options;
  Map<String, dynamic>? _result;

  final Map<String, String?> _selectedInputs = {
    'land_type': null,
    'soil_type': null,
    'season': null,
    'temperature_level': null,
    'humidity_level': null,
    'rainfall_level': null,
    'latitude': '0.0',
  };

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final options = await _repo.fetchOptions();
      setState(() {
        _options = options;
        _isLoading = false;

        // Auto-select first option to avoid nulls
        _selectedInputs['land_type'] = options['land_types']?[0];
        _selectedInputs['soil_type'] = options['soil_types']?[0];
        _selectedInputs['season'] = options['seasons']?[0];
        _selectedInputs['temperature_level'] =
            options['temperature_levels']?[0];
        _selectedInputs['humidity_level'] = options['humidity_levels']?[0];
        _selectedInputs['rainfall_level'] = options['rainfall_levels']?[0];
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await _repo.fetchRecommendations(_selectedInputs);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Farming Guide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_result == null) _buildForm(),
                  if (_result != null) _buildResult(),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    if (_options == null) return const SizedBox();

    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.eco_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Tell us about your land to find the perfect mushroom species to cultivate.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Environmental Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Land Type',
            'land_type',
            _options!['land_types'],
            Icons.landscape,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Soil Type',
            'soil_type',
            _options!['soil_types'],
            Icons.grass,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Season',
            'season',
            _options!['seasons'],
            Icons.cloudy_snowing,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Temperature',
            'temperature_level',
            _options!['temperature_levels'],
            Icons.thermostat,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Humidity',
            'humidity_level',
            _options!['humidity_levels'],
            Icons.water_drop,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            'Rainfall',
            'rainfall_level',
            _options!['rainfall_levels'],
            Icons.water,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _selectedInputs['latitude'],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Latitude (e.g. 34.05)',
              prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (val) {
              _selectedInputs['latitude'] = val;
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withValues(alpha: 0.4),
            ),
            onPressed: () {
              FocusScope.of(context).unfocus(); // Close keyboard
              _fetchRecommendations();
            },
            child: const Text(
              'Analyze Environment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String key,
    List<dynamic>? items,
    IconData icon,
  ) {
    if (items == null || items.isEmpty) return const SizedBox();

    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      initialValue: _selectedInputs[key],
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item.toString(),
          child: Text(
            item.toString().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedInputs[key] = val;
          });
        }
      },
    );
  }

  Widget _buildResult() {
    final matches = _result!['top_matches'] as List<dynamic>? ?? [];
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Environment Analysis',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _result!['environment_label'].toString().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Match Score:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_result!['match_score']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Recommended Species',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...matches.map((m) {
            final fitLevel = m['fit_level'].toString().toUpperCase();
            final isHigh = fitLevel == 'HIGH';
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[100]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: isHigh
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.eco,
                      color: isHigh ? AppColors.primary : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['class_name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fit: $fitLevel',
                          style: TextStyle(
                            fontSize: 13,
                            color: isHigh ? AppColors.primary : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${m['match_score']}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: const BorderSide(color: AppColors.primary, width: 2),
            ),
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            label: const Text(
              'Analyze Another Layout',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                _result = null;
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
