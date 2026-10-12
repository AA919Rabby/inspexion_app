import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_shimmer.dart';
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
        toolbarHeight: 96.h,
        titleSpacing: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Row(
                children: [
                  CustomShimmer.circle(size: 68.r),
                  const Gap(14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomShimmer(width: 90.w, height: 14.h),
                      const Gap(6),
                      CustomShimmer(width: 150.w, height: 20.h),
                    ],
                  ),
                ],
              ),

              // Real Header Content
              Row(
                children: [
                  // Premium Dual-Ring Circular Avatar
                  Container(
                    height: 68.r,
                    width: 68.r,
                    padding: EdgeInsets.all(2.5.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AllColor.whiteColor,
                      border: Border.all(
                        color: AllColor.yellowColor,
                        width: 3.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                            width: 68.r,
                            height: 68.r,
                            errorBuilder: (_, _, _) => _buildInitialAvatar(profileController),
                          );
                        }
                        return _buildInitialAvatar(profileController);
                      }),
                    ),
                  ),

                  const Gap(14),

                  // Commercial Header Typography & Status Badge
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Welcome back,",
                              color: AllColor.whiteColor.withValues(alpha: 0.85),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            const Gap(6),
                            Container(
                              width: 7.r,
                              height: 7.r,
                              decoration: BoxDecoration(
                                color: AllColor.yellowColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const Gap(2),
                        Obx(
                              () => CustomText(
                            text: profileController.userProfile.value?.fullName.isNotEmpty == true
                                ? profileController.userProfile.value!.fullName
                                : "Unauthorized Inspector",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AllColor.whiteColor,
                            softWrap: true,
                          ),
                        ),
                      ],
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
          backgroundColor: AllColor.whiteColor,
          onRefresh: () async {
            homeController.startStaggeredShimmer();
            await Future.delayed(const Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardStatsWidget(),
                  Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(ProfileController controller) {
    final String name = controller.userProfile.value?.fullName ?? '';
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      height: 68.r,
      width: 68.r,
      alignment: Alignment.center,
      color: AllColor.greyColor400,
      child: CustomText(
        text: initial,
        fontSize: 24,
        color: AllColor.whiteColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}