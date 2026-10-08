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
}