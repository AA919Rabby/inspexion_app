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
      backgroundColor: AllColor.greyColor400,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AllColor.whiteColor,
          ),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          text: 'About Us',
          fontSize: 25,
          color: AllColor.whiteColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo and Header
                Center(
                  child: Column(
                    children: [
                      CustomText(
                        text: 'Inspexion AI',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AllColor.blackColor,
                      ),
                      const Gap(4),
                      CustomText(
                        text: 'Version 1.0.0',
                        fontSize: 14,
                        color: AllColor.greyColor400,
                      ),
                    ],
                  ),
                ),
                const Gap(32),

                // About Description
                Card(
                  color: AllColor.whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'About Inspexion AI',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AllColor.blackColor,
                        ),
                        const Gap(12),
                        CustomText(
                          text:
                              'Inspexion AI is an intelligent inspection and analysis platform powered by artificial intelligence. Our mission is to make inspection processes faster, smarter, and more accurate.',
                          fontSize: 14,
                          color: AllColor.blackColor,
                          maxLines: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),

                // Key Features
                CustomText(
                  text: 'Key Features',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                _buildFeatureItem(
                  icon: Icons.camera_alt,
                  title: 'AI-Powered Analysis',
                  description: 'Advanced computer vision for accurate inspections',
                ),
                const Gap(12),
                _buildFeatureItem(
                  icon: Icons.assessment,
                  title: 'Instant Reports',
                  description:
                      'Generate comprehensive PDF reports in seconds',
                ),
                const Gap(12),
                _buildFeatureItem(
                  icon: Icons.history,
                  title: 'Inspection History',
                  description:
                      'Keep track of all your inspections in one place',
                ),
                const Gap(12),
                _buildFeatureItem(
                  icon: Icons.security,
                  title: 'Secure & Private',
                  description:
                      'Your data is encrypted and protected with industry standards',
                ),
                Gap(32.h),

                // Company Info
                Card(
                  color: AllColor.whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Company',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AllColor.blackColor,
                        ),
                        const Gap(12),
                        _buildInfoRow(
                          icon: Icons.business,
                          label: 'Company Name',
                          value: 'Inspexion Technologies',
                        ),
                        const Gap(12),
                        _buildInfoRow(
                          icon: Icons.language,
                          label: 'Website',
                          value: 'www.inspexion.ai',
                        ),
                        const Gap(12),
                        _buildInfoRow(
                          icon: Icons.email,
                          label: 'Email',
                          value: 'support@inspexion.ai',
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),

                // Follow Us
                // Card(
                //   color: AllColor.whiteColor,
                //   elevation: 2,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(12.r),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.all(16.r),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         CustomText(
                //           text: 'Follow Us',
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //           color: AllColor.blackColor,
                //         ),
                //         const Gap(12),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             _buildSocialButton(
                //               icon: Icons.facebook,
                //               label: 'Facebook',
                //             ),
                //             _buildSocialButton(
                //               icon: Icons.language,
                //               label: 'Twitter',
                //             ),
                //             _buildSocialButton(
                //               icon: Icons.photo_camera,
                //               label: 'Instagram',
                //             ),
                //             _buildSocialButton(
                //               icon: Icons.linked_camera,
                //               label: 'LinkedIn',
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Gap(20.h),

                // Terms and Privacy
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to terms
                        },
                        child: CustomText(
                          text: 'Terms of Service',
                          fontSize: 13,
                          color: AllColor.blueColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () {
                          // Navigate to privacy
                        },
                        child: CustomText(
                          text: 'Privacy Policy',
                          fontSize: 13,
                          color: AllColor.blueColor,
                          decoration: TextDecoration.underline,
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
    return Card(
      color: AllColor.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AllColor.blueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AllColor.blueColor, size: 24.r),
            ),
            const Gap(12),
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
                  const Gap(4),
                  CustomText(
                    text: description,
                    fontSize: 12,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
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
        Icon(icon, color: AllColor.blueColor, size: 20.r),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                fontSize: 12,
              ),
              const Gap(4),
              CustomText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AllColor.blackColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildSocialButton({
  //   required IconData icon,
  //   required String label,
  // }) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Handle social media tap
  //     },
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(10.r),
  //           decoration: BoxDecoration(
  //             color: AllColor.blueColor.withValues(alpha: 0.1),
  //             borderRadius: BorderRadius.circular(8.r),
  //           ),
  //           child: Icon(icon, color: AllColor.blueColor, size: 24.r),
  //         ),
  //         const Gap(4),
  //         CustomText(
  //           text: label,
  //           fontSize: 11,
  //           color: AllColor.blackColor,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
