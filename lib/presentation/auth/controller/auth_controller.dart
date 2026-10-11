import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '1018837083142-djl6au9ver94edknnou7gb981ftj5qgs.apps.googleusercontent.com',
  );

  // 1. Google Login
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
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

        // Save token to AuthServices so the user never has to see onboarding again
        await AuthServices.setAccessToken(accessToken);
        await AuthServices.setIsLoggedIn(true);

        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
    } on DioException catch (dioError) {
      log('Dio Error in googleLogin: ${dioError.response?.data ?? dioError.message}');

      final dynamic serverData = dioError.response?.data;
      String errorMessage = 'Server error (${dioError.response?.statusCode ?? 'Unknown'})';

      if (serverData is Map) {
        errorMessage = serverData['detail']?.toString() ??
            serverData['message']?.toString() ??
            serverData['error']?.toString() ??
            serverData.toString();
      } else if (serverData != null) {
        errorMessage = serverData.toString();
      } else if (dioError.message != null) {
        errorMessage = dioError.message!;
      }

      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Backend Error (${dioError.response?.statusCode ?? 'Failed'})',
          message: errorMessage,
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
              : 'Google Sign-In failed: ${e.message ?? e.code}',
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

  Future<void> appleLogin() async {
    // Only available on iOS devices
    if (!Platform.isIOS) return;

    isLoading.value = true;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw Exception("Apple authorization failed: Identity token is null.");
      }

      // Build name if provided by Apple on initial sign in
      String? fullName;
      if (credential.givenName != null || credential.familyName != null) {
        fullName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
      }

      // Call FastAPI Apple endpoint
      final response = await _dio.post(
        AppUrl.appleAuth,
        data: {
          'identity_token': identityToken,
          'email': credential.email,
          'full_name': fullName,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final String accessToken = response.data['access_token'] ?? '';

        await AuthServices.setAccessToken(accessToken);
        await AuthServices.setIsLoggedIn(true);

        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
    } on DioException catch (dioError) {
      log('Dio Error in appleLogin: ${dioError.response?.data ?? dioError.message}');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Sign In Failed',
          message: dioError.response?.data?['detail']?.toString() ?? 'Server error',
          isError: true,
        );
      }
    } catch (e) {
      log('Apple Sign In Error: $e');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Apple Sign-In Error',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }


  // 2. Logout (Clears tokens & returns to Onboarding Screen)
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _googleSignIn.signOut();
      await AuthServices.clearAll();


      // Send logged-out user to OnboardingScreen
      Get.offAllNamed(AllRoute.onboardingScreen);
    } catch (e) {
      log('Error during logout: $e');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Logout Error',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}