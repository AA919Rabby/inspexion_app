import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_shimmer.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import '../../controller/home_controller.dart';



class DashboardStatsWidget extends StatelessWidget {
  const DashboardStatsWidget({super.key});

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

      final double maxYValue = data.timelineTrend.isEmpty
          ? 10.0
          : data.timelineTrend.reduce(max);
      final double calculatedMaxY = maxYValue == 0 ? 10.0 : (maxYValue * 1.3).ceilToDouble();
      final double yInterval = (calculatedMaxY / 4).clamp(1.0, double.infinity);

      final int totalPoints = data.timelineTrend.length;
      final double xInterval = (totalPoints > 5) ? (totalPoints / 4).ceilToDouble() : 1.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Overview Analytics",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AllColor.blackColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AllColor.blueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, size: 14.r, color: AllColor.blueColor),
                    const Gap(3),
                    CustomText(
                      text: "Live Sync",
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AllColor.blueColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(14),
          if (homeController.shimmerMetrics.value)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: CustomShimmer(height: 112.h)),
                    const Gap(12),
                    Expanded(child: CustomShimmer(height: 112.h)),
                  ],
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(child: CustomShimmer(height: 112.h)),
                    const Gap(12),
                    Expanded(child: CustomShimmer(height: 112.h)),
                  ],
                ),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: "Total Audits",
                    value: data.totalInspections.toString(),
                    icon: Icons.inventory_2_outlined,
                    accentColor: AllColor.blueColor,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildMetricCard(
                    title: "Analyzed Images",
                    value: data.totalImagesAnalyzed.toString(),
                    icon: Icons.camera_alt_outlined,
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
                    title: "Critical Hazards",
                    value: data.criticalDefects.toString(),
                    icon: Icons.warning_amber_rounded,
                    accentColor: AllColor.redColor,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildMetricCard(
                    title: "Minor Issues",
                    value: data.minorDefects.toString(),
                    icon: Icons.info_outline_rounded,
                    accentColor: AllColor.yellowColor,
                  ),
                ),
              ],
            ),
          ],
          const Gap(28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Inspection Timeline Trend",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AllColor.blackColor,
              ),
              Icon(Icons.trending_up_rounded, color: AllColor.blueColor, size: 22.r),
            ],
          ),
          const Gap(12),

          if (homeController.shimmerChart.value)
            CustomShimmer(height: 250.h)
          else
            Card(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              color: AllColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: Colors.white, width: 1.5.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: SizedBox(
                  height: 220.h,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: calculatedMaxY,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => AllColor.blackColor,
                          tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          getTooltipItems: (List<LineBarSpot> touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                "${spot.y.toInt()} Defects Found",
                                TextStyle(
                                  color: AllColor.whiteColor,
                                  fontSize: 12.sp,
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
                                color: AllColor.blueColor.withValues(alpha: 0.4),
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
                                      strokeColor: AllColor.blueColor,
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
                          color: Colors.grey.withValues(alpha: 0.12),
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
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: xInterval,
                            getTitlesWidget: (value, meta) {
                              if (value < 0 || value >= totalPoints) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
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
                          curveSmoothness: 0.35,
                          color: AllColor.blueColor,
                          barWidth: 3.5,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AllColor.blueColor.withValues(alpha: 0.28),
                                AllColor.blueColor.withValues(alpha: 0.0),
                              ],
                            ),
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
          const Gap(28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Categories Breakdown",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AllColor.blackColor,
              ),
              Icon(Icons.pie_chart_outline_rounded, color: AllColor.blueColor, size: 22.r),
            ],
          ),
          const Gap(12),

          if (homeController.shimmerBreakdown.value)
            CustomShimmer(height: 180.h)
          else
            Card(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              color: AllColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
                side: BorderSide(color: Colors.white, width: 1.5.w),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.r),
                child: Row(
                  children: [
                    SizedBox(
                      width: 125.w,
                      height: 125.h,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 28.r,
                          sections: _buildPieSections(data.categoriesBreakdown),
                        ),
                      ),
                    ),
                    const Gap(18),
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
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      color: AllColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Colors.white, width: 1.5.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(9.r),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 20.r),
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
            const Gap(14),
            CustomText(
              text: value,
              color: AllColor.blackColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const Gap(3),
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
      AllColor.redColor,
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
      AllColor.redColor,
      const Color(0xFF00B4D8),
      Colors.teal,
    ];
    int index = 0;

    return categories.entries.map((entry) {
      final color = colors[index % colors.length];
      index++;
      final cleanLabel = _formatCategory(entry.key);

      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const Gap(8),
            Expanded(
              child: CustomText(
                text: cleanLabel,
                color: Colors.grey.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(
                text: entry.value.toInt().toString(),
                color: color == AllColor.yellowColor ? Colors.amber.shade900 : color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}