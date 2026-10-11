import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/home/controller/home_controller.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/dashboard_stats_widget.dart';
import 'package:inspexion_ai/presentation/profile/controller/profile_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController(), permanent: true);

    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController(), permanent: true);

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

              // Live Avatar Image or Initial Circle
              Container(
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AllColor.whiteColor,
                ),
                child: ClipOval(
                  child: Obx(() {
                    final avatar = profileController.networkAvatarUrl.value.isNotEmpty
                        ? profileController.networkAvatarUrl.value
                        : (profileController.userProfile.value?.avatarUrl ?? '');

                    if (avatar.isNotEmpty) {
                      return Image.network(
                        avatar,
                        key: ValueKey(avatar),
                        fit: BoxFit.cover,
                        width: 75.w,
                        height: 75.h,
                        errorBuilder: (_, _, _) => _buildInitialAvatar(profileController),
                      );
                    }
                    return _buildInitialAvatar(profileController);
                  }),
                ),
              ),

              const Gap(10),

              // Live User Name
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
            // Only 2-second delay as requested (no fetch profile API calls here)
            await Future.delayed(const Duration(seconds: 2));
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
                  DashboardStatsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(ProfileController controller) {
    final String name = controller.userProfile.value?.fullName ?? 'U';
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      color: AllColor.greyColor400,
      alignment: Alignment.center,
      child: CustomText(
        text: initial,
        fontSize: 26,
        color: AllColor.whiteColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}