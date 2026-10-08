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

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final data = homeController.statsData.value;

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
              Gap(12.w),
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
          Gap(12.h),
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
              Gap(12.w),
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
          Gap(24.h),

          // 2. Timeline Trend Section
          CustomText(
            text: "Inspection Timeline Trend",
            //color: AllColor.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          Gap(12.h),
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
                    minY: 7000,
                    maxY: 10000,
                    // FIX 1: Custom Tooltip and Selected Circle Highlight
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (touchedSpot) => AllColor.blackColor,
                       // tooltipRoundedRadius: 8.r,
                        tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              spot.y.toInt().toString(),
                              TextStyle(
                                color: AllColor.whiteColor, // Pure white text
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
                                    color: AllColor.whiteColor, // White circle when clicked
                                    strokeWidth: 3,
                                    strokeColor: AllColor.blackColor, // Black border
                                  ),
                            ),
                          );
                        }).toList();
                      },
                    ),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.15),
                        strokeWidth: 1,
                      ),
                    ),

                    // FIX 2: Fixed Y-axis interval (Eliminates 9.6K & 9.5K overlapping)
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 38.w,
                          interval: 1000, // Exact 1000 step so labels never collide
                          getTitlesWidget: (value, meta) {
                            if (value < 7000 || value > 10000 || value % 1000 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              '${(value / 1000).toInt()}K',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
          Gap(24.h),

          // 3. Category Breakdown Section
          CustomText(
            text: "Categories Breakdown",
            //color: AllColor.,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          Gap(12.h),
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
                  Gap(20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          color: AllColor.blueColor,
                          label: "Structural",
                          value: "8,026",
                        ),
                        Gap(12.h),
                        _buildLegendItem(
                          color: AllColor.yellowColor,
                          label: "Surface",
                          value: "6,308",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(20.h),
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
            Gap(12.h),
            CustomText(
              text: value,
              color: AllColor.blackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            Gap(4.h),
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
    final colors = [AllColor.blueColor, AllColor.yellowColor];
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

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        Gap(8.w),
        Expanded(
          child: CustomText(
            text: label,
            color: AllColor.blackColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomText(
          text: value,
          color: AllColor.blackColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}