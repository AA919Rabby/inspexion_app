import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();

  // ✅ FIXED: Directly passed without String.fromEnvironment
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '1018837083142-djl6au9ver94edknnou7gb981ftj5qgs.apps.googleusercontent.com',
  );

  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        if (Get.context != null) {
          customSnackbar(
            Get.context!,
            title: 'Google Sign-In Not Configured',
            message: 'Missing Google ID token. Add the correct Web Client ID and SHA-1 to Firebase for this build.',
            isError: true,
          );
        }
        isLoading.value = false;
        return;
      }

      final response = await _dio.post(
        AppUrl.googleAuth,
        data: {
          'id_token': idToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final String accessToken = response.data['access_token'] ?? '';

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);

        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
    } on DioException catch (dioError) {
      log('Dio Error in googleLogin: ${dioError.response?.data ?? dioError.message}');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Authentication Failed',
          message: dioError.response?.data?['message'] ?? 'Could not verify Google token with server',
          isError: true,
        );
      }
    } on PlatformException catch (e) {
      log('Google Sign-In PlatformException: ${e.code} / ${e.message}');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Google Sign-In Error',
          message: e.message?.contains('SHA') == true || e.message?.contains('client') == true
              ? 'Google Sign-In is not configured for this APK. Add the correct SHA-1 and Web Client ID to Firebase.'
              : 'Google Sign-In failed. Please check your Firebase/Google configuration.',
          isError: true,
        );
      }
    } catch (e) {
      log('Error in googleLogin: $e');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Error',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}