class Profile {
  final String key;
  final String title;

  Profile({required this.key, required this.title});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class Allocation {
  final double areaHa;
  final double areaPercent;
  final String crop;
  final double expectedProductionTon;

  Allocation({
    required this.areaHa,
    required this.areaPercent,
    required this.crop,
    required this.expectedProductionTon,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      areaHa: (json['area_ha'] ?? 0).toDouble(),
      areaPercent: (json['area_percent'] ?? 0).toDouble(),
      crop: json['crop'] ?? '',
      expectedProductionTon: (json['expected_production_ton'] ?? 0).toDouble(),
    );
  }
}

class Cards {
  final double carbonKgco2e;
  final double expectedProductionTon;
  final double profitUsd;
  final double soilHealth;
  final double sustainability;
  final double waterUseM3;

  Cards({
    required this.carbonKgco2e,
    required this.expectedProductionTon,
    required this.profitUsd,
    required this.soilHealth,
    required this.sustainability,
    required this.waterUseM3,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      carbonKgco2e: (json['carbon_kgco2e'] ?? 0).toDouble(),
      expectedProductionTon: (json['expected_production_ton'] ?? 0).toDouble(),
      profitUsd: (json['profit_usd'] ?? 0).toDouble(),
      soilHealth: (json['soil_health'] ?? 0).toDouble(),
      sustainability: (json['sustainability'] ?? 0).toDouble(),
      waterUseM3: (json['water_use_m3'] ?? 0).toDouble(),
    );
  }
}

class RawScores {
  final double constraintPenalty;
  final double displayRankScore;
  final double totalCostUsd;

  RawScores({
    required this.constraintPenalty,
    required this.displayRankScore,
    required this.totalCostUsd,
  });

  factory RawScores.fromJson(Map<String, dynamic> json) {
    return RawScores(
      constraintPenalty: (json['constraint_penalty'] ?? 0).toDouble(),
      displayRankScore: (json['display_rank_score'] ?? 0).toDouble(),
      totalCostUsd: (json['total_cost_usd'] ?? 0).toDouble(),
    );
  }
}

class RecommendedPlan {
  final List<Allocation> allocation;
  final Cards cards;
  final RawScores rawScores;
  final String title;

  RecommendedPlan({
    required this.allocation,
    required this.cards,
    required this.rawScores,
    required this.title,
  });

  factory RecommendedPlan.fromJson(Map<String, dynamic> json) {
    var allocList = json['allocation'] as List? ?? [];
    return RecommendedPlan(
      allocation: allocList.map((e) => Allocation.fromJson(e)).toList(),
      cards: Cards.fromJson(json['cards'] ?? {}),
      rawScores: RawScores.fromJson(json['raw_scores'] ?? {}),
      title: json['title'] ?? '',
    );
  }
}

class CropOptimizeResponse {
  final double areaHa;
  final Profile profile;
  final RecommendedPlan recommendedPlan;
  final String screen;
  final String status;

  CropOptimizeResponse({
    required this.areaHa,
    required this.profile,
    required this.recommendedPlan,
    required this.screen,
    required this.status,
  });

  factory CropOptimizeResponse.fromJson(Map<String, dynamic> json) {
    return CropOptimizeResponse(
      areaHa: (json['area_ha'] ?? 0).toDouble(),
      profile: Profile.fromJson(json['profile'] ?? {}),
      recommendedPlan: RecommendedPlan.fromJson(json['recommended_plan'] ?? {}),
      screen: json['screen'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Recommendation {
  final double carbonKgco2e;
  final String carbonRiskClass;
  final String crop;
  final double expectedProductionTon;
  final double modelProbability;
  final String notes;
  final double profitUsd;
  final double score;
  final double soilHealth;
  final double sustainability;
  final String waterNeedClass;
  final double waterUseM3;

  Recommendation({
    required this.carbonKgco2e,
    required this.carbonRiskClass,
    required this.crop,
    required this.expectedProductionTon,
    required this.modelProbability,
    required this.notes,
    required this.profitUsd,
    required this.score,
    required this.soilHealth,
    required this.sustainability,
    required this.waterNeedClass,
    required this.waterUseM3,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      carbonKgco2e: (json['carbon_kgco2e'] ?? 0).toDouble(),
      carbonRiskClass: json['carbon_risk_class'] ?? '',
      crop: json['crop'] ?? '',
      expectedProductionTon: (json['expected_production_ton'] ?? 0).toDouble(),
      modelProbability: (json['model_probability'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      profitUsd: (json['profit_usd'] ?? 0).toDouble(),
      score: (json['score'] ?? 0).toDouble(),
      soilHealth: (json['soil_health'] ?? 0).toDouble(),
      sustainability: (json['sustainability'] ?? 0).toDouble(),
      waterNeedClass: json['water_need_class'] ?? '',
      waterUseM3: (json['water_use_m3'] ?? 0).toDouble(),
    );
  }
}

class CropRecommendResponse {
  final double areaHa;
  final Recommendation bestRecommendation;
  final Profile profile;
  final List<Recommendation> recommendations;
  final String screen;
  final String status;

  CropRecommendResponse({
    required this.areaHa,
    required this.bestRecommendation,
    required this.profile,
    required this.recommendations,
    required this.screen,
    required this.status,
  });

  factory CropRecommendResponse.fromJson(Map<String, dynamic> json) {
    var recList = json['recommendations'] as List? ?? [];
    return CropRecommendResponse(
      areaHa: (json['area_ha'] ?? 0).toDouble(),
      bestRecommendation: Recommendation.fromJson(json['best_recommendation'] ?? {}),
      profile: Profile.fromJson(json['profile'] ?? {}),
      recommendations: recList.map((e) => Recommendation.fromJson(e)).toList(),
      screen: json['screen'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
