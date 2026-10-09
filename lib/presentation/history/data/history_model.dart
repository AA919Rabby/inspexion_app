class HistoryModel {
  final int id;
  final int sessionId;
  final String reportTitle;
  final String filePath;
  final String createdAt;

  HistoryModel({
    required this.id,
    required this.sessionId,
    required this.reportTitle,
    required this.filePath,
    required this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      sessionId: json['session_id'] ?? 0,
      reportTitle: json['report_title']?.toString() ?? 'Asset Audit Report',
      filePath: json['file_path']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}