import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/home/data/dashboard_stats_model.dart';


class HomeController extends GetxController {
  final RxBool isLoading = false.obs;

  // Dummy data matching your Postman response
  final Rx<DashboardStatsModel> statsData = DashboardStatsModel(
    totalInspections: 2451,
    totalImagesAnalyzed: 1063,
    criticalDefects: 9559,
    minorDefects: 9201,
    defectRatio: 7315.70,
    categoriesBreakdown: {
      'Structural Defects': 8026.0,
      'Surface Flaws': 6308.0,
    },
    timelineTrend: [
      7752.0,
      8200.0,
      8794.79,
      8400.0,
      9559.0,
    ],
  ).obs;

  // Placeholder for when you connect the real API later
  Future<void> fetchDashboardStats() async {
    // API logic will go here
  }
}