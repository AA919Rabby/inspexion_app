import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inspexion_ai/firebase_options.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully.');
  } catch (e) {
    log('Firebase initialization failed: $e');
  }

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

  runApp(const MyApp(home: IntroScreen()));
}