import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {

  static String get baseUrl => dotenv.get('BASE_URL');
  static String get googleAuth => "$baseUrl/api/v1/auth/google";

///
///
///
///
//
//


}