import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import '../../controller/home_controller.dart';

class DashboardStatsWidget extends StatelessWidget {
  const DashboardStatsWidget({super.key});

  // Helper to remove underscores and format text cleanly
  String _formatCategory(String raw) {
    if (raw.isEmpty) return 'General';
    return raw.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final data = homeController.statsData.value;

      // Dynamic Y-axis
      final double maxYValue = data.timelineTrend.isEmpty
          ? 10.0
          : data.timelineTrend.reduce(max);
      final double calculatedMaxY = maxYValue == 0 ? 10.0 : (maxYValue * 1.3).ceilToDouble();
      final double yInterval = (calculatedMaxY / 4).clamp(1.0, double.infinity);

      // FIX: Dynamically space X-axis so numbers NEVER overlap (#1#2#3 eliminated)
      final int totalPoints = data.timelineTrend.length;
      final double xInterval = (totalPoints > 5) ? (totalPoints / 4).ceilToDouble() : 1.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Metric Cards Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: "Total Inspections",
                  value: data.totalInspections.toString(),
                  icon: Icons.assignment_outlined,
                  accentColor: AllColor.blueColor,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildMetricCard(
                  title: "Analyzed Images",
                  value: data.totalImagesAnalyzed.toString(),
                  icon: Icons.image_search_outlined,
                  accentColor: const Color(0xFF00B4D8),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: "Critical Defects",
                  value: data.criticalDefects.toString(),
                  icon: Icons.warning_amber_rounded,
                  accentColor: Colors.redAccent,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _buildMetricCard(
                  title: "Minor Defects",
                  value: data.minorDefects.toString(),
                  icon: Icons.info_outline_rounded,
                  accentColor: AllColor.yellowColor,
                ),
              ),
            ],
          ),
          const Gap(24),

          // 2. Timeline Trend Chart
          CustomText(
            text: "Inspection Timeline Trend",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const Gap(12),
          Card(
            elevation: 3,
            color: AllColor.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: SizedBox(
                height: 210.h,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: calculatedMaxY,
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AllColor.blackColor,
                        tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              "${spot.y.toInt()} Defects",
                              TextStyle(
                                color: AllColor.whiteColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                        return spotIndexes.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(
                              color: AllColor.blackColor.withValues(alpha: 0.3),
                              strokeWidth: 2,
                              dashArray: [4, 4],
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 6,
                                    color: AllColor.whiteColor,
                                    strokeWidth: 3,
                                    strokeColor: AllColor.blackColor,
                                  ),
                            ),
                          );
                        }).toList();
                      },
                    ),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: yInterval,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.15),
                        strokeWidth: 1,
                      ),
                    ),

                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32.w,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) {
                            return CustomText(text: value.toInt().toString(),);
                          },
                        ),
                      ),
                      // CLEAN X-AXIS: No squished #1#2#3 numbers
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: xInterval,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value >= totalPoints) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: CustomText(text: value.toInt().toString(),),
                            );
                          },
                        ),
                      ),
                    ),

                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          data.timelineTrend.length,
                              (index) => FlSpot(index.toDouble(), data.timelineTrend[index]),
                        ),
                        isCurved: true,
                        color: AllColor.blueColor,
                        barWidth: 3.5,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AllColor.blueColor.withValues(alpha: 0.12),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 4,
                                color: AllColor.yellowColor,
                                strokeWidth: 2,
                                strokeColor: AllColor.blueColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Gap(24),

          // 3. Category Breakdown (Underscores Removed)
          CustomText(
            text: "Categories Breakdown",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const Gap(12),
          Card(
            elevation: 3,
            color: AllColor.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  SizedBox(
                    width: 130.w,
                    height: 130.h,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 28.r,
                        sections: _buildPieSections(data.categoriesBreakdown),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildDynamicLegends(data.categoriesBreakdown),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(20),
        ],
      );
    });
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Card(
      elevation: 3,
      color: AllColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 22.r),
                ),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Gap(12),
            CustomText(
              text: value,
              color: AllColor.blackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            const Gap(4),
            CustomText(
              text: title,
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, double> categories) {
    final colors = [
      AllColor.blueColor,
      AllColor.yellowColor,
      Colors.redAccent,
      const Color(0xFF00B4D8),
      Colors.teal,
    ];
    int index = 0;
    return categories.entries.map((entry) {
      final sectionColor = colors[index % colors.length];
      index++;
      return PieChartSectionData(
        color: sectionColor,
        value: entry.value,
        title: "",
        radius: 26.r,
      );
    }).toList();
  }

  List<Widget> _buildDynamicLegends(Map<String, double> categories) {
    final colors = [
      AllColor.blueColor,
      AllColor.yellowColor,
      Colors.redAccent,
      const Color(0xFF00B4D8),
      Colors.teal,
    ];
    int index = 0;

    return categories.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      final cleanLabel = _formatCategory(entry.key); // Strips underscores

      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            const Gap(8),
            Expanded(
              child: CustomText(
                text: cleanLabel,
                color: AllColor.blackColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                softWrap: true,
              ),
            ),
            CustomText(
              text: entry.value.toInt().toString(),
              color: AllColor.blackColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
    }).toList();
  }
}