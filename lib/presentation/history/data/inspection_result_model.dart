class InspectionResultModel {
  final int sessionId;
  final int processedCount;
  final int criticalDefects;
  final int minorDefects;
  final bool hasCriticalIssue;
  final List<InspectionImageResult> results;

  InspectionResultModel({
    required this.sessionId,
    required this.processedCount,
    required this.criticalDefects,
    required this.minorDefects,
    required this.hasCriticalIssue,
    required this.results,
  });

  factory InspectionResultModel.fromJson(Map<String, dynamic> json) {
    return InspectionResultModel(
      sessionId: json['session_id'] ?? 0,
      processedCount: json['processed_count'] ?? 0,
      criticalDefects: json['critical_defects'] ?? 0,
      minorDefects: json['minor_defects'] ?? 0,
      hasCriticalIssue: json['has_critical_issue'] ?? false,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => InspectionImageResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class InspectionImageResult {
  final String filename;
  final String category;
  final double confidence;
  final bool isCritical;

  InspectionImageResult({
    required this.filename,
    required this.category,
    required this.confidence,
    required this.isCritical,
  });

  factory InspectionImageResult.fromJson(Map<String, dynamic> json) {
    return InspectionImageResult(
      filename: json['filename']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Asset',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      isCritical: json['is_critical'] ?? false,
    );
  }
}