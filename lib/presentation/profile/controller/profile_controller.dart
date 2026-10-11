import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:image_picker/image_picker.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:inspexion_ai/presentation/profile/data/user_profile_model.dart';

class ProfileController extends GetxController {
  final Dio _dio = Dio();
  final ImagePicker _picker = ImagePicker();

  final nameClt = TextEditingController();
  final numberClt = TextEditingController();
  final cityClt = TextEditingController();
  final addressClt = TextEditingController();
  final ageClt = TextEditingController();
  final profileKey = GlobalKey<FormState>();

  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString networkAvatarUrl = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedFormFields();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameClt.dispose();
    numberClt.dispose();
    cityClt.dispose();
    addressClt.dispose();
    ageClt.dispose();
    super.onClose();
  }

  void _loadSavedFormFields() {
    numberClt.text = AuthServices.getString('user_phone') ?? '';
    cityClt.text = AuthServices.getString('user_city') ?? '';
    addressClt.text = AuthServices.getString('user_address') ?? '';
    ageClt.text = AuthServices.getString('user_age') ?? '';
  }

  // 1. GET User Profile from Backend using UserProfileModel
  Future<void> fetchUserProfile() async {
    final token = AuthServices.getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      final response = await _dio.get(
        AppUrl.getProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final model = UserProfileModel.fromJson(response.data);
        userProfile.value = model;
        nameClt.text = model.fullName;

        if (model.avatarUrl.isNotEmpty) {
          networkAvatarUrl.value = '${model.avatarUrl}?t=${DateTime.now().millisecondsSinceEpoch}';
        } else {
          networkAvatarUrl.value = '';
        }

        userProfile.refresh();
        networkAvatarUrl.refresh();
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    }
  }

  // 2. Pick Profile Photo for Preview
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      log('Error picking image: $e');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Picker Error',
          message: e.toString(),
          isError: true,
        );
      }
    }
  }

  // 3. Update Profile & Fetch fresh Profile Data from Backend
  Future<void> updateProfile() async {
    if (!profileKey.currentState!.validate()) return;

    final token = AuthServices.getAccessToken();
    if (token == null || token.isEmpty) {
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Unauthorized',
          message: 'Please log in again.',
          isError: true,
        );
      }
      return;
    }

    isLoading.value = true;

    // Save extra fields
    await AuthServices.setString('user_phone', numberClt.text.trim());
    await AuthServices.setString('user_city', cityClt.text.trim());
    await AuthServices.setString('user_address', addressClt.text.trim());
    await AuthServices.setString('user_age', ageClt.text.trim());

    try {
      final Map<String, dynamic> dataMap = {
        'full_name': nameClt.text.trim(),
      };

      if (selectedImage.value != null) {
        dataMap['avatar'] = await MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
      }

      final formData = FormData.fromMap(dataMap);

      final response = await _dio.patch(
        AppUrl.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        log('Server returned profile update: ${response.data}');

        // Clear local temporary file preview
        selectedImage.value = null;

        // Fetch fresh profile from backend to ensure networkAvatarUrl is updated correctly
        await fetchUserProfile();

        if (Get.context != null) {
          customSnackbar(
            Get.context!,
            title: 'Profile Updated',
            message: 'Profile image saved successfully!',
            isError: false,
          );
        }
      }
    } on DioException catch (e) {
      log('Dio Error: ${e.response?.data ?? e.message}');
      _showErrorSnackbar(e);
    } catch (e) {
      log('Error: $e');
      if (Get.context != null) {
        customSnackbar(
          Get.context!,
          title: 'Update Failed',
          message: e.toString(),
          isError: true,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(DioException dioError) {
    final dynamic serverData = dioError.response?.data;
    String errorMessage = 'Server error (${dioError.response?.statusCode ?? 'Unknown'})';

    if (serverData is Map) {
      errorMessage = serverData['detail']?.toString() ??
          serverData['message']?.toString() ??
          serverData.toString();
    } else if (dioError.message != null) {
      errorMessage = dioError.message!;
    }

    if (Get.context != null) {
      customSnackbar(
        Get.context!,
        title: 'Backend Error',
        message: errorMessage,
        isError: true,
      );
    }
  }
}