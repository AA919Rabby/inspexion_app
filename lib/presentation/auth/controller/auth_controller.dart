import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();

  // Stable constructor for google_sign_in
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      // 1. Show Google Account selection popup
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled popup
        isLoading.value = false;
        return;
      }

      // 2. Retrieve authentication token
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        if (Get.context != null) {
          customSnackbar(
            Get.context!,
            title: 'Google Error',
            message: 'Failed to retrieve Google token. Ensure SHA-1/Web Client ID is configured.',
            isError: true,
          );
        }
        isLoading.value = false;
        return;
      }

      // 3. Send id_token to backend API using AppUrl.googleAuth
      final response = await _dio.post(
        AppUrl.googleAuth,
        data: {
          'id_token': idToken,
        },
      );

      // 4. Handle 200 OK Response
      if (response.statusCode == 200 && response.data != null) {
        final String accessToken = response.data['access_token'] ?? '';

        // Save access token to local storage
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);

        // 5. Navigate to BottomNavScreen
        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
    } on DioException catch (dioError) {
      log('Dio Error in googleLogin: ${dioError.response?.data ?? dioError.message}');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Authentication Failed',
          message: dioError.response?.data?['message'] ?? 'Could not verify token with server',
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