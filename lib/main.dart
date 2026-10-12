import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/core/services/network_controller.dart'; // IMPORT
import 'package:inspexion_ai/firebase_options.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'app.dart';


// Fire-and-forget function using Dio
void wakeUpServerBackground() {
  try {
    log('Pinging server to wake it up...');
    Dio().get('${AppUrl.baseUrl}/health');
  } catch (e) {
    log('Background ping error (normal if waking up): $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthServices.init();

  // 1. Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully.');
  } catch (e) {
    log('Firebase initialization failed: $e');
  }

  // 2. Load .env variables
  try {
    await dotenv.load(fileName: '.env');

    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl != null && baseUrl.isNotEmpty) {
      log('==========================================');
      log('✅ SUCCESS: .env file loaded successfully!');
      log(' baseUrl found, starts with: ${baseUrl.length >= 3 ? baseUrl.substring(0, 3) : baseUrl}');
      log('==========================================');
    } else {
      log('==========================================');
      log('❌ ERROR: .env file loaded, but baseUrl is empty!');
      log('==========================================');
    }
  } catch (e) {
    log('==========================================');
    log('🛑 CRITICAL ERROR: Could not load .env file!');
    log('Error details: $e');
    log('==========================================');
  }

  // 3. START LIVE NETWORK MONITORING
  Get.put(NetworkController(), permanent: true);

  // 4. Wake up server in background
  wakeUpServerBackground();

  // 5. Run App
  runApp(const MyApp(home: IntroScreen()));
}