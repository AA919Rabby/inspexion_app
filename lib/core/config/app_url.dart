import 'package:flutter_dotenv/flutter_dotenv.dart';


class AppUrl {
  static String get baseUrl => dotenv.get('BASE_URL');
  static String get googleAuth => "$baseUrl/api/v1/auth/google";
  //
  static String get getProfile => "$baseUrl/api/v1/users/me";
  static String get updateProfile => "$baseUrl/api/v1/users/me";


  // History & Upload API Endpoints
  static String get getHistory => "$baseUrl/api/v1/inspections/reports/history";
  static String get createSession => "$baseUrl/api/v1/inspections/sessions";
  static String uploadPhotos(int sessionId) => "$baseUrl/api/v1/inspections/sessions/$sessionId/upload-photos";
  static String generateDocument(int sessionId) => "$baseUrl/api/v1/inspections/sessions/$sessionId/generate-document";
  static String downloadReport(int reportId) => "$baseUrl/api/v1/inspections/reports/$reportId/download";
}