import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: AllColor.whiteColor, size: 20.r),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
        title: CustomText(
          text: 'About InspeXion AI',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AllColor.whiteColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo and Header Badge
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AllColor.whiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset("asset/image/logo.png", height: 80.h, width: 80.w),
                      ),
                      const Gap(14),
                      CustomText(
                        text: 'InspeXion AI',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AllColor.blackColor,
                      ),
                      const Gap(4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AllColor.blueColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CustomText(
                          text: 'Version 1.0.0 • Enterprise Edition',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AllColor.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(28),

                // About Description Card
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AllColor.whiteColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Our Mission',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AllColor.blackColor,
                      ),
                      const Gap(8),
                      CustomText(
                        text:
                        'InspeXion AI is an intelligent visual inspection and physical asset analysis platform powered by next-generation computer vision. We empower field engineers and adjusters to identify defects faster, smarter, and with verified precision.',
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        maxLines: 10,
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // Key Features Header
                CustomText(
                  text: 'Key Platform Capabilities',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                _buildFeatureItem(
                  icon: Icons.camera_enhance_rounded,
                  title: 'AI Computer Vision',
                  description: 'Automated defect detection and severity risk classification',
                ),
                const Gap(10),
                _buildFeatureItem(
                  icon: Icons.picture_as_pdf_rounded,
                  title: 'Instant PDF Generation',
                  description: 'Generate comprehensive audit reports and download in seconds',
                ),
                const Gap(10),
                _buildFeatureItem(
                  icon: Icons.history_rounded,
                  title: 'Cloud Audit Logs',
                  description: 'Persistent inspection history with real-time analytics',
                ),
                const Gap(10),
                _buildFeatureItem(
                  icon: Icons.shield_rounded,
                  title: 'Enterprise Security',
                  description: 'Biometric authorization with SSL/TLS encrypted cloud storage',
                ),
                const Gap(28),

                // Company Info Card
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AllColor.whiteColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Corporate Details',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AllColor.blackColor,
                      ),
                      const Gap(14),
                      _buildInfoRow(
                        icon: Icons.business_rounded,
                        label: 'Organization',
                        value: 'InspeXion Technologies Inc.',
                      ),
                      const Gap(12),
                      _buildInfoRow(
                        icon: Icons.email_rounded,
                        label: 'Inquiries Desk',
                        value: 'support@inspexion.ai',
                      ),
                    ],
                  ),
                ),
                const Gap(28),

                // Terms and Privacy Buttons
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CustomText(
                          text: 'Terms of Service',
                          fontSize: 12,
                          color: AllColor.blueColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(width: 4.r, height: 4.r, decoration: BoxDecoration(color: AllColor.greyColor400, shape: BoxShape.circle)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CustomText(
                          text: 'Privacy Policy',
                          fontSize: 12,
                          color: AllColor.blueColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AllColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AllColor.blueColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AllColor.blueColor, size: 22.r),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(2),
                CustomText(
                  text: description,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(7.r),
          decoration: BoxDecoration(
            color: AllColor.blueColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AllColor.blueColor, size: 16.r),
        ),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: label, fontSize: 11, color: Colors.grey.shade500),
            CustomText(
              text: value,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AllColor.blackColor,
            ),
          ],
        ),
      ],
    );
  }
}