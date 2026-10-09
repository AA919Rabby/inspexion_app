import 'dart:developer';
import 'package:dio/dio.dart';
// 1. FIX: Hide conflicting classes from GetX so Dio's FormData works
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:image_picker/image_picker.dart';
// 2. FIX: Add missing imports for downloading and opening PDFs
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:inspexion_ai/presentation/history/data/history_model.dart';
import 'package:inspexion_ai/presentation/history/data/inspection_result_model.dart';

class HistoryController extends GetxController {
  final Dio _dio = Dio();
  final ImagePicker _picker = ImagePicker();

  // States
  final RxBool isLoading = false.obs;
  final RxBool isInspecting = false.obs;
  final RxBool isGeneratingPdf = false.obs;

  // Data Models
  final RxList<HistoryModel> reports = <HistoryModel>[].obs;
  final Rx<InspectionResultModel?> currentInspection = Rx<InspectionResultModel?>(null);

  // Camera Staging Photos
  final RxList<XFile> stagedImages = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  // 1. GET API call using Model
  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      final token = AuthServices.getAccessToken();
      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      final response = await _dio.get(
        AppUrl.getHistory,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        reports.value = data.map((json) => HistoryModel.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      log('Dio Error in fetchHistory: ${e.response?.data ?? e.message}');
      _showErrorSnackbar(e);
    } catch (e) {
      log('Error in fetchHistory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Initial Picker (Gallery direct analysis vs Camera to staging)
  Future<void> pickAndInspectImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        // GALLERY: Multiple selection, direct analysis
        final List<XFile> galleryPhotos = await _picker.pickMultiImage(imageQuality: 85);
        if (galleryPhotos.isNotEmpty) {
          await _runInspectionPipeline(galleryPhotos);
        }
      } else {
        // CAMERA: Take one photo, go to Staging Screen
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
        if (photo != null) {
          stagedImages.clear();
          stagedImages.add(photo);
          Get.toNamed(AllRoute.cameraStagingScreen);
        }
      }
    } catch (e) {
      log('Error picking images: $e');
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Picker Error', message: e.toString(), isError: true);
      }
    }
  }

  // 3. Add more photos from camera (Used in Staging Screen)
  Future<void> addMoreFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (photo != null) {
        stagedImages.add(photo);
      }
    } catch (e) {
      log('Error adding camera image: $e');
    }
  }

  // 4. Trigger Analysis from Staging Screen
  Future<void> analyzeStagedImages() async {
    if (stagedImages.isEmpty) return;
    await _runInspectionPipeline(stagedImages.toList());
    stagedImages.clear(); // Clear memory after sending
  }

  // 5. The Core Pipeline
  Future<void> _runInspectionPipeline(List<XFile> files) async {
    final token = AuthServices.getAccessToken();
    if (token == null) {
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Unauthorized', message: 'Please log in again.', isError: true);
      }
      return;
    }

    isInspecting.value = true;

    try {
      final sessionResponse = await _dio.post(
        AppUrl.createSession,
        data: {'title': 'Asset Damage Inspection', 'asset_type': 'Physical Machinery'},
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
      );

      final int sessionId = sessionResponse.data['id'];

      final formData = FormData();
      for (var file in files) {
        formData.files.add(MapEntry('photos', await MultipartFile.fromFile(file.path, filename: file.name)));
      }

      final uploadResponse = await _dio.post(
        AppUrl.uploadPhotos(sessionId),
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'}),
      );

      if (uploadResponse.statusCode == 200 && uploadResponse.data != null) {
        currentInspection.value = InspectionResultModel.fromJson(uploadResponse.data);
        isInspecting.value = false;

        // Navigate using Route Name (No constructors)
        Get.toNamed(AllRoute.inspectionResultScreen);
      }

      await fetchHistory();
    } on DioException catch (e) {
      isInspecting.value = false;
      _showErrorSnackbar(e);
    } catch (e) {
      isInspecting.value = false;
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Inspection Failed', message: e.toString(), isError: true);
      }
    } finally {
      isInspecting.value = false;
    }
  }

  // 6. Generate & Open PDF
  Future<void> generateAndOpenCurrentReport() async {
    final model = currentInspection.value;
    final token = AuthServices.getAccessToken();
    if (model == null || token == null) return;

    isGeneratingPdf.value = true;
    try {
      final response = await _dio.post(
        AppUrl.generateDocument(model.sessionId),
        options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
      );

      final int reportId = response.data['id'];
      await downloadAndOpenReport(reportId, 'Inspection_Report_${model.sessionId}');
    } on DioException catch (e) {
      _showErrorSnackbar(e);
    } catch (e) {
      log('Error generating report: $e');
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  // 7. Download PDF
  Future<void> downloadAndOpenReport(int reportId, String reportTitle) async {
    try {
      final token = AuthServices.getAccessToken();
      if (token == null) return;

      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Downloading', message: 'Downloading PDF...', isError: false);
      }

      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$reportTitle.pdf';

      await _dio.download(
        AppUrl.downloadReport(reportId),
        savePath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      await OpenFilex.open(savePath);
    } on DioException catch (e) {
      _showErrorSnackbar(e);
    } catch (e) {
      log('Error opening PDF: $e');
    }
  }

  void _showErrorSnackbar(DioException dioError) {
    final dynamic serverData = dioError.response?.data;
    String errorMessage = 'Server error (${dioError.response?.statusCode ?? 'Unknown'})';

    if (serverData is Map) {
      errorMessage = serverData['detail']?.toString() ?? serverData['message']?.toString() ?? serverData.toString();
    } else if (dioError.message != null) {
      errorMessage = dioError.message!;
    }

    if (Get.context != null) {
      customSnackbar(Get.context!, title: 'Backend Error', message: errorMessage, isError: true);
    }
  }
}