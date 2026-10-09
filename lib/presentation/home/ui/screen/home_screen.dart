import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/dashboard_stats_widget.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/header_widget.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement your refresh logic / API calls here
            await Future.delayed(const Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            // AlwaysScrollableScrollPhysics ensures the pull-to-refresh
            // gesture triggers even if content fits without scrolling.
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top header
                  HeaderWidget(),
                  const Gap(15),

                  /// stats
                  DashboardStatsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
