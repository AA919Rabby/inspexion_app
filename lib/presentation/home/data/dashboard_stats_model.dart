class DashboardStatsModel {
  final int totalInspections;
  final int totalImagesAnalyzed;
  final int criticalDefects;
  final int minorDefects;
  final double defectRatio;
  final Map<String, double> categoriesBreakdown;
  final List<double> timelineTrend;

  DashboardStatsModel({
    required this.totalInspections,
    required this.totalImagesAnalyzed,
    required this.criticalDefects,
    required this.minorDefects,
    required this.defectRatio,
    required this.categoriesBreakdown,
    required this.timelineTrend,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    // 1. Parse category counts into percentages/weights
    final rawCategories = json['categories_breakdown'] as Map<String, dynamic>? ?? {};
    final Map<String, double> categories = {};
    rawCategories.forEach((key, value) {
      if (value != null) {
        categories[key.toString()] = (value as num).toDouble();
      }
    });

    // 2. Parse timeline progression
    final rawTimeline = json['timeline_trend'] as List<dynamic>? ?? [];
    final List<double> timeline = [];
    for (var item in rawTimeline) {
      if (item is Map) {
        // Plot total defects identified per inspection session
        final double defects = (((item['critical'] ?? 0) as num) + ((item['minor'] ?? 0) as num)).toDouble();
        timeline.add(defects);
      } else if (item is num) {
        timeline.add(item.toDouble());
      }
    }

    return DashboardStatsModel(
      totalInspections: json['total_inspections'] ?? 0,
      totalImagesAnalyzed: json['total_images_analyzed'] ?? 0,
      criticalDefects: json['critical_defects'] ?? 0,
      minorDefects: json['minor_defects'] ?? 0,
      defectRatio: (json['defect_ratio'] as num?)?.toDouble() ?? 0.0,
      categoriesBreakdown: categories.isNotEmpty ? categories : {'Clean': 1.0},
      timelineTrend: timeline.isNotEmpty ? timeline : [0.0, 0.0],
    );
  }
}