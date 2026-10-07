import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'app.dart';
import 'dart:developer';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load Base url
    await dotenv.load(fileName: ".env");

    // 2. CHECK IF KEY LOADED AND PRINT TO TERMINAL
    final baseUrl = dotenv.env['BASE_URL'];

    if (baseUrl != null && baseUrl.isNotEmpty) {
      log("==========================================");
      log("✅ SUCCESS: .env file loaded successfully!");
      // Print just the first 3 characters for security
      log(" baseUrl found, starts with: ${baseUrl.length >= 3 ? baseUrl.substring(0, 3) : baseUrl}");
      log("==========================================");
    } else {
      log("==========================================");
      log("❌ ERROR: .env file loaded, but baseUrl is empty!");
      log("==========================================");
    }
  } catch (e) {
    log("==========================================");
    log("🛑 CRITICAL ERROR: Could not load .env file!");
    log("Error details: $e");
    log("==========================================");
  }

  runApp(const MyApp(
    home: IntroScreen(),
  ));
}