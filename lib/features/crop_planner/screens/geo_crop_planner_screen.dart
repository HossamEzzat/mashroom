import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/crop_planner_provider.dart';
import '../models/crop_responses.dart';


class GeoCropPlannerScreen extends StatefulWidget {
  const GeoCropPlannerScreen({Key? key}) : super(key: key);

  @override
  State<GeoCropPlannerScreen> createState() => _GeoCropPlannerScreenState();
}

class _GeoCropPlannerScreenState extends State<GeoCropPlannerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CropPlannerProvider(),
      child: Consumer<CropPlannerProvider>(
        builder: (context, provider, _) {
          final isResult = provider.optimizeResponse != null;
          return Scaffold(
            backgroundColor: const Color(0xFFF3F7F0), // Matching mushroom screen background
            appBar: AppBar(
              backgroundColor: isResult 
                  ? const Color(0xFF1B3B22) 
                  : const Color(0xFFF3F7F0),
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: isResult ? Colors.white : Colors.black87,
              ),
              title: Column(
                children: [
                  Text(
                    'Geo Crop Planner',
                    style: TextStyle(color: isResult ? Colors.white : const Color(0xFF1B4332), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  if (isResult)
                    const Text(
                      'AI Optimization Results',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                ],
              ),
            ),
            body: Container(
              decoration: isResult
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B3B22), Color(0xFF112615)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    )
                  : null,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isResult) ...[
                      FadeInUp(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildLocationWeatherCard(provider),
                            const SizedBox(height: 24),
                            _buildLandSoilData(provider),
                            const SizedBox(height: 24),
                            _buildOptimizationGoal(provider),
                            const SizedBox(height: 32),
                            if (provider.isLoading)
                              const Center(child: CircularProgressIndicator(color: Color(0xFF1B4332)))
                            else if (provider.errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7E6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.alertCircle, color: Colors.orange, size: 28),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        provider.errorMessage!,
                                        style: const TextStyle(color: Color(0xFFB06000), fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B4332),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  shadowColor: const Color(0xFF1B4332).withValues(alpha: 0.4),
                                ),
                                icon: const Icon(LucideIcons.brainCircuit, color: Colors.white),
                                label: const Text(
                                  'Run AI Optimization',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  provider.runOptimization();
                                },
                              ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                    if (isResult)
                      _buildOptimizedPlan(provider),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- FORM WIDGETS ---
  
  Widget _buildLocationWeatherCard(CropPlannerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: provider.isFetchingLocation
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1B4332)))
                    : const Icon(LucideIcons.mapPin, color: Color(0xFF1B4332)),
                onPressed: provider.isFetchingLocation ? null : provider.fetchLocationAndWeather,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  provider.locationName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B4332)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${provider.areaHa} ha', style: const TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherItem(LucideIcons.sun, '${provider.temperature.toStringAsFixed(1)}°C', 'Temp'),
              _buildWeatherItem(LucideIcons.droplets, '${provider.humidity.toStringAsFixed(0)}%', 'Humidity'),
              _buildWeatherItem(LucideIcons.cloudRain, '${provider.rainfall.toStringAsFixed(1)}mm', 'Rainfall'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
      ],
    );
  }

  Widget _buildLandSoilData(CropPlannerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LucideIcons.sprout, color: Color(0xFF1B4332), size: 20),
            SizedBox(width: 8),
            Text('Land & Soil Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B4332))),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField('Nitrogen (N)', provider.n.toString(), 'kg/ha', (v) => provider.updateInputs(newN: double.tryParse(v)))),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Phosphorus (P)', provider.p.toString(), 'kg/ha', (v) => provider.updateInputs(newP: double.tryParse(v)))),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Potassium (K)', provider.k.toString(), 'kg/ha', (v) => provider.updateInputs(newK: double.tryParse(v)))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildInputField('Soil pH', provider.ph.toString(), '', (v) => provider.updateInputs(newPh: double.tryParse(v)))),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Water Limit', provider.waterLimit.toString(), 'm³', (v) => provider.updateInputs(newWater: double.tryParse(v)))),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField('Budget', provider.budget.toString(), '\$', (v) => provider.updateInputs(newBudget: double.tryParse(v)))),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(String label, String initialValue, String suffix, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            initialValue: initialValue,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
              suffixText: suffix,
              suffixStyle: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptimizationGoal(CropPlannerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Optimization Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B4332))),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.goals.map((goal) {
            final isSelected = provider.selectedGoal == goal;
            return GestureDetector(
              onTap: () => provider.setGoal(goal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1B4332) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                  boxShadow: isSelected ? [
                    BoxShadow(color: const Color(0xFF1B4332).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))
                  ] : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) const Icon(LucideIcons.check, color: Colors.white, size: 16),
                    if (isSelected) const SizedBox(width: 6),
                    Text(
                      goal.replaceAll('_', ' ').capitalize(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- RESULT WIDGETS ---

  Widget _buildOptimizedPlan(CropPlannerProvider provider) {
    final response = provider.optimizeResponse!;
    final plan = response.recommendedPlan;
    
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResultSummaryCard(plan, response.profile.title),
          const SizedBox(height: 12),
          _buildResultInputsCard(provider),
          const SizedBox(height: 12),
          _buildAllocationCard(plan.allocation),
          const SizedBox(height: 12),
          _buildInsightsCard(plan.cards),
          const SizedBox(height: 12),
          _buildWarningCard(),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B4332),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF1B4332).withOpacity(0.4),
            ),
            onPressed: () {
              provider.clearResults();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.leaf, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text(
                  'Try Another Environment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(width: 12),
                Icon(LucideIcons.arrowRight, color: Colors.white, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildResultSummaryCard(RecommendedPlan plan, String profileTitle) {
    final sustainability = plan.cards.sustainability.toDouble();
    return _buildCardContainer(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A4D32),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.leaf, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  plan.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A4D32)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(LucideIcons.globe, 'Goal:', profileTitle, const Color(0xFF2A4D32)),
                    const SizedBox(height: 12),
                    _buildInfoRow(LucideIcons.barChart2, 'Profit:', '\$${plan.cards.profitUsd.toInt()}', const Color(0xFFE6A31E)),
                    const SizedBox(height: 12),
                    _buildInfoRow(LucideIcons.target, 'Health:', '${plan.cards.soilHealth.toInt()}/100', const Color(0xFF2A4D32)),
                  ],
                ),
              ),
              SizedBox(
                width: 110,
                height: 110,
                child: CircularPercentIndicator(
                  radius: 55.0,
                  lineWidth: 8.0,
                  animation: true,
                  percent: (sustainability / 100).clamp(0.0, 1.0),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${sustainability.toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF2A4D32)),
                      ),
                      const Text('Match Score', style: TextStyle(fontSize: 10, color: Color(0xFF2A4D32), fontWeight: FontWeight.w500)),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: _getScoreColor(sustainability),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildResultInputsCard(CropPlannerProvider provider) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.leaf, color: Color(0xFF2A4D32), size: 20),
              SizedBox(width: 8),
              Text('Selected Inputs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A4D32))),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: [
              _buildInputBadge('Nitrogen', '${provider.n} kg', LucideIcons.testTube),
              _buildInputBadge('Phosphorus', '${provider.p} kg', LucideIcons.testTube2),
              _buildInputBadge('Potassium', '${provider.k} kg', LucideIcons.testTube),
              _buildInputBadge('Soil pH', '${provider.ph}', LucideIcons.flaskConical),
              _buildInputBadge('Water Limit', '${provider.waterLimit} m³', LucideIcons.droplets),
              _buildInputBadge('Budget', '\$${provider.budget}', LucideIcons.wallet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBadge(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF2A4D32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF2A4D32)), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAllocationCard(List<Allocation> allocation) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.trophy, color: Color(0xFF2A4D32), size: 20),
              SizedBox(width: 8),
              Text('Top Matches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A4D32))),
            ],
          ),
          const SizedBox(height: 16),
          ...allocation.map((alloc) {
            return _buildAllocationItem(alloc.crop.capitalize(), alloc.areaPercent, alloc.expectedProductionTon);
          }),
        ],
      ),
    );
  }

  Widget _buildAllocationItem(String name, double percent, double production) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: const Icon(LucideIcons.leaf, size: 20, color: Color(0xFFE6A31E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2A4D32))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text('Prod: ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('${production.toStringAsFixed(1)} tons', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFE6A31E))),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Match Score', style: TextStyle(fontSize: 9, color: Color(0xFF2A4D32), fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('${percent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2A4D32))),
            ],
          ),
          const SizedBox(width: 8),
          CircularPercentIndicator(
            radius: 14.0,
            lineWidth: 3.0,
            percent: (percent / 100).clamp(0.0, 1.0),
            progressColor: _getScoreColor(percent),
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(Cards metrics) {
    return _buildCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.lightbulb, color: Color(0xFF2A4D32), size: 20),
              SizedBox(width: 8),
              Text('Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A4D32))),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: [
              _buildInsightBadge('Production', '${metrics.expectedProductionTon.toStringAsFixed(1)} ton', LucideIcons.pieChart),
              _buildInsightBadge('Water Use', '${metrics.waterUseM3.toInt()} m³', LucideIcons.droplets),
              _buildInsightBadge('Carbon', '${metrics.carbonKgco2e.toInt()} kg', LucideIcons.wind),
              _buildInsightBadge('Profit', '\$${metrics.profitUsd.toInt()}', LucideIcons.coins),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBadge(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2A4D32)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF2A4D32)), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCF3D7), Color(0xFFF6E7B6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFE6A31E), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'AI-driven optimization only. Actual field results may vary depending on local environmental conditions.',
              style: TextStyle(color: Color(0xFF8B6311), fontSize: 12, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }


  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
