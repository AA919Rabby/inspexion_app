import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/dashboard_stats_widget.dart';
import 'package:inspexion_ai/presentation/profile/controller/profile_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find ProfileController
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 90.h,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            children: [
              const Gap(15),

              // Dynamic Avatar Image Container
              Container(
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AllColor.yellowColor, width: 5.w),
                  shape: BoxShape.circle,
                  color: AllColor.whiteColor,
                ),
                child: ClipOval(
                  child: Obx(() {
                    final avatar = profileController.userProfile.value?.avatarUrl ?? '';
                    if (avatar.isNotEmpty) {
                      return Image.network(
                        avatar,
                        fit: BoxFit.cover,
                        width: 75.w,
                        height: 75.h,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.person,
                          color: AllColor.blueColor,
                          size: 40.r,
                        ),
                      );
                    }
                    return Icon(
                      Icons.person,
                      color: AllColor.blueColor,
                      size: 40.r,
                    );
                  }),
                ),
              ),

              const Gap(10),

              // Dynamic Name Column
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Welcome,",
                    color: AllColor.whiteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                  Obx(
                        () => CustomText(
                      text: profileController.userProfile.value?.fullName.isNotEmpty == true
                          ? profileController.userProfile.value!.fullName
                          : "User",
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: AllColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AllColor.blueColor,
          onRefresh: () async {
            // Refreshes profile data on pull-to-refresh
            await profileController.fetchUserProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(15),

                  // Dashboard Stats Cards & Chart
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