import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:inspexion_ai/presentation/history/data/history_model.dart';
import 'package:inspexion_ai/presentation/history/data/inspection_result_model.dart';

class HistoryController extends GetxController {
  // FIX: Added explicit timeouts. It will wait up to 3 minutes for heavy AI processing
  // but will NEVER spin infinitely if the server hangs.
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 3),
  ));

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

  // 1. GET API call
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
        options: Options(headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'}),
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

  // 2. Initial Picker
  Future<void> pickAndInspectImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> galleryPhotos = await _picker.pickMultiImage(
          imageQuality: 60,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        if (galleryPhotos.isNotEmpty) {
          await _runInspectionPipeline(galleryPhotos);
        }
      } else {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 60,
          maxWidth: 1024,
          maxHeight: 1024,
        );
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

  // 3. Add more photos from camera
  Future<void> addMoreFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (photo != null) {
        stagedImages.add(photo);
      }
    } catch (e) {
      log('Error adding camera image: $e');
    }
  }

  // 4. Trigger Analysis
  Future<void> analyzeStagedImages() async {
    if (stagedImages.isEmpty) return;
    await _runInspectionPipeline(stagedImages.toList());
    stagedImages.clear();
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
      log('Step 1: Creating Session...');
      final sessionResponse = await _dio.post(
        AppUrl.createSession,
        data: {'title': 'Asset Damage Inspection', 'asset_type': 'Physical Machinery'},
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
      );

      final int sessionId = sessionResponse.data['id'];

      log('Step 2: Preparing ${files.length} files for upload...');
      final formData = FormData();
      for (var file in files) {
        formData.files.add(MapEntry('photos', await MultipartFile.fromFile(file.path, filename: file.name)));
      }

      log('Step 3: Uploading & Running AI (This may take up to 2 minutes)...');
      final uploadResponse = await _dio.post(
        AppUrl.uploadPhotos(sessionId),
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'multipart/form-data'}),
      );

      if (uploadResponse.statusCode == 200 && uploadResponse.data != null) {
        currentInspection.value = InspectionResultModel.fromJson(uploadResponse.data);
        isInspecting.value = false;
        Get.toNamed(AllRoute.inspectionResultScreen);
      }

      await fetchHistory();
    } on DioException catch (e) {
      log('Dio Error in Inspection: ${e.response?.data ?? e.message}');
      _showErrorSnackbar(e);
    } catch (e) {
      log('Unexpected Error: $e');
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Inspection Failed', message: 'System error: $e', isError: true);
      }
    } finally {
      // GUARANTEES the loading spinner turns off no matter what happens
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
    String errorMessage = 'Network error or Timeout (${dioError.response?.statusCode ?? 'Try again'})';

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