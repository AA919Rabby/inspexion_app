class InspectionResultModel {
  final int sessionId;
  final int sessionNumber;
  final int processedCount;
  final int criticalDefects;
  final int minorDefects;
  final bool hasCriticalIssue;
  final List<InspectionImageResult> results;

  InspectionResultModel({
    required this.sessionId,
    required this.sessionNumber,
    required this.processedCount,
    required this.criticalDefects,
    required this.minorDefects,
    required this.hasCriticalIssue,
    required this.results,
  });

  factory InspectionResultModel.fromJson(Map<String, dynamic> json) {
    return InspectionResultModel(
      sessionId: json['session_id'] ?? 0,
      sessionNumber: json['session_number'] ?? (json['session_id'] ?? 1),
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
  final String description;
  final List<DamageBox> boxes;

  InspectionImageResult({
    required this.filename,
    required this.category,
    required this.confidence,
    required this.isCritical,
    this.description = 'Visual diagnostic complete.',
    this.boxes = const [],
  });

  factory InspectionImageResult.fromJson(Map<String, dynamic> json) {
    final rawBoxes = json['boxes'] as List<dynamic>? ?? [];
    final List<DamageBox> parsedBoxes = [];

    for (var b in rawBoxes) {
      if (b is Map<String, dynamic>) {
        parsedBoxes.add(DamageBox.fromJson(b));
      }
    }

    return InspectionImageResult(
      filename: json['filename']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Asset',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      isCritical: json['is_critical'] ?? false,
      description: json['description']?.toString() ?? 'Visual scan complete.',
      boxes: parsedBoxes,
    );
  }
}

class DamageBox {
  final double ymin;
  final double xmin;
  final double ymax;
  final double xmax;
  final String label;

  DamageBox({
    required this.ymin,
    required this.xmin,
    required this.ymax,
    required this.xmax,
    required this.label,
  });

  factory DamageBox.fromJson(Map<String, dynamic> json) {
    final boxList = json['box'] as List<dynamic>? ?? [0.15, 0.15, 0.85, 0.85];
    return DamageBox(
      ymin: ((boxList.isNotEmpty ? boxList[0] : 0.15) as num).toDouble(),
      xmin: ((boxList.length > 1 ? boxList[1] : 0.15) as num).toDouble(),
      ymax: ((boxList.length > 2 ? boxList[2] : 0.85) as num).toDouble(),
      xmax: ((boxList.length > 3 ? boxList[3] : 0.85) as num).toDouble(),
      label: json['label']?.toString() ?? 'Defect Area',
    );
  }
}