import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/global/custom_snackbar.dart';
import 'package:inspexion_ai/presentation/history/data/history_model.dart';
import 'package:inspexion_ai/presentation/history/data/inspection_result_model.dart';
import 'package:inspexion_ai/presentation/home/controller/home_controller.dart';



class HistoryController extends GetxController {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 45),
    receiveTimeout: const Duration(minutes: 5),
  ));

  final ImagePicker _picker = ImagePicker();
  WebSocketChannel? _wsChannel;

  final RxBool isLoading = false.obs;
  final RxBool isInspecting = false.obs;
  final RxBool isGeneratingPdf = false.obs;

  final RxString liveStatusMessage = ''.obs;

  final RxList<HistoryModel> reports = <HistoryModel>[].obs;
  final Rx<InspectionResultModel?> currentInspection = Rx<InspectionResultModel?>(null);

  final RxList<XFile> stagedImages = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  @override
  void onClose() {
    _closeWebSocket();
    super.onClose();
  }

  void _closeWebSocket() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }

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

  Future<void> pickAndInspectImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> galleryPhotos = await _picker.pickMultiImage(
          imageQuality: 50,
          maxWidth: 640,
          maxHeight: 640,
        );
        if (galleryPhotos.isNotEmpty) {
          stagedImages.assignAll(galleryPhotos);
          stagedImages.refresh();
          await _runInspectionPipeline(galleryPhotos);
        }
      } else {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxWidth: 640,
          maxHeight: 640,
        );
        if (photo != null) {
          stagedImages.assignAll([photo]);
          stagedImages.refresh();

          await Future.delayed(const Duration(milliseconds: 60));
          Get.toNamed(AllRoute.cameraStagingScreen);
        }
      }
    } catch (e) {
      log('Error picking images: $e');
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Error', message: "Unable to upload photo.", isError: true);
      }
    }
  }

  Future<void> addMoreFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 640,
        maxHeight: 640,
      );
      if (photo != null) {
        stagedImages.add(photo);
        stagedImages.refresh();
      }
    } catch (e) {
      log('Error adding camera image: $e');
    }
  }

  Future<void> analyzeStagedImages() async {
    if (stagedImages.isEmpty) return;
    await _runInspectionPipeline(stagedImages.toList());
  }

  Future<void> _runInspectionPipeline(List<XFile> files) async {
    final token = AuthServices.getAccessToken();
    if (token == null) {
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Unauthorized', message: 'Please log in again.', isError: true);
      }
      return;
    }

    isInspecting.value = true;
    liveStatusMessage.value = "Starting inspection session...";

    try {
      final sessionResponse = await _dio.post(
        AppUrl.createSession,
        data: {'title': 'Asset Damage Inspection', 'asset_type': 'Physical Machinery'},
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
      );

      final int sessionId = sessionResponse.data['id'];

      final wsUrl = AppUrl.liveInspectionWs(sessionId);
      try {
        _wsChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
        _wsChannel?.stream.listen((message) {
          try {
            final data = jsonDecode(message.toString());
            if (data['event'] == 'IMAGE_ANALYZED') {
              final int index = data['index'] ?? 0;
              final int total = data['total'] ?? files.length;
              final String category = data['category'] ?? 'Component';
              final double conf = ((data['confidence'] ?? 0.0) as num).toDouble() * 100;
              liveStatusMessage.value = "Analyzing $index of $total\n$category (${conf.toStringAsFixed(0)}%)";
            }
          } catch (_) {}
        });
      } catch (wsErr) {
        log('WebSocket connection error: $wsErr');
      }

      liveStatusMessage.value = "Uploading ${files.length} photo(s)...";

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
        Get.toNamed(AllRoute.inspectionResultScreen);
      }

      await fetchHistory();
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchDashboardStats();
      }
    } on DioException catch (e) {
      isInspecting.value = false;
      log('Dio Error in Inspection: ${e.response?.data ?? e.message}');
      _showErrorSnackbar(e);
    } catch (e) {
      isInspecting.value = false;
      log('Unexpected Error: $e');
      if (Get.context != null) {
        customSnackbar(Get.context!, title: 'Inspection Failed', message: "Something went wrong", isError: true);
      }
    } finally {
      isInspecting.value = false;
      liveStatusMessage.value = "";
      _closeWebSocket();
    }
  }

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
      await fetchHistory();
      await downloadAndOpenReport(reportId, 'Inspection_Report_${model.sessionId}');
    } on DioException catch (e) {
      _showErrorSnackbar(e);
    } catch (e) {
      log('Error generating report: $e');
    } finally {
      isGeneratingPdf.value = false;
    }
  }

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
    String errorMessage = 'Server error (${dioError.response?.statusCode ?? 'Timeout'})';

    if (serverData is Map) {
      errorMessage = serverData['detail']?.toString() ?? serverData['message']?.toString() ?? serverData.toString();
    } else if (dioError.message != null) {
      errorMessage = dioError.message!;
    }

    if (Get.context != null) {
      customSnackbar(Get.context!, title: 'Server Error', message: "Unable to connect.", isError: true);
    }
  }
}