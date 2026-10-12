import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/config/app_url.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';
import 'package:inspexion_ai/presentation/home/data/dashboard_stats_model.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();
  final RxBool isLoading = false.obs;

  // Staggered One-By-One Shimmer States
  final RxBool shimmerHeader = true.obs;
  final RxBool shimmerMetrics = true.obs;
  final RxBool shimmerChart = true.obs;
  final RxBool shimmerBreakdown = true.obs;

  // Reactive state initialized with safe zeros
  final Rx<DashboardStatsModel> statsData = DashboardStatsModel(
    totalInspections: 0,
    totalImagesAnalyzed: 0,
    criticalDefects: 0,
    minorDefects: 0,
    defectRatio: 0.0,
    categoriesBreakdown: {'Clean': 1.0},
    timelineTrend: [0.0, 0.0],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    startStaggeredShimmer();
    fetchDashboardStats();
  }

  // One-by-one sequential reveal reaching exactly 3 seconds
  void startStaggeredShimmer() {
    shimmerHeader.value = true;
    shimmerMetrics.value = true;
    shimmerChart.value = true;
    shimmerBreakdown.value = true;

    // 1. Header stops shimmering at 1.0s
    Future.delayed(const Duration(milliseconds: 1000), () => shimmerHeader.value = false);

    // 2. Metric cards stop shimmering at 1.7s
    Future.delayed(const Duration(milliseconds: 1700), () => shimmerMetrics.value = false);

    // 3. Line chart stops shimmering at 2.4s
    Future.delayed(const Duration(milliseconds: 2400), () => shimmerChart.value = false);

    // 4. Pie chart breakdown stops shimmering at 3.0s
    Future.delayed(const Duration(milliseconds: 3000), () => shimmerBreakdown.value = false);
  }

  // Fetch real analytics data from FastAPI backend
  Future<void> fetchDashboardStats() async {
    final token = AuthServices.getAccessToken();
    if (token == null || token.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _dio.get(
        AppUrl.dashboardStats,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        statsData.value = DashboardStatsModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      log('Dio Error fetching dashboard stats: ${e.response?.data ?? e.message}');
    } catch (e) {
      log('Error fetching dashboard stats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}