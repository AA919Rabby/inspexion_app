import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  int expandedIndex = -1;

  final List<Map<String, String>> faqItems = [
    {
      'question': 'How do I take an inspection?',
      'answer':
      'Simply open the app, tap on "New Inspection", point your camera at the object, and let AI analyze it. You\'ll get instant results and a detailed PDF report.',
    },
    {
      'question': 'How can I download my inspection reports?',
      'answer':
      'Go to "History" from the settings menu, find your inspection, and tap "Download & View PDF". The report will be saved to your device.',
    },
    {
      'question': 'Is my data secure?',
      'answer':
      'Yes, all your data is encrypted using industry-standard SSL/TLS protocols. We never share your personal information with third parties.',
    },
    {
      'question': 'Can I share my inspection reports?',
      'answer':
      'Yes, after downloading your PDF report, you can share it via email, messaging apps, or any other sharing method available on your device.',
    },
    {
      'question': 'What devices are supported?',
      'answer':
      'Inspexion AI works on Android devices running Android 8.0 or higher, with full iOS support enabled.',
    },
    {
      'question': 'How accurate is the AI analysis?',
      'answer':
      'Our AI model has been trained on thousands of industrial images and achieves over 95% accuracy. However, we recommend professional verification for critical inspections.',
    },
    {
      'question': 'Do I need internet for inspections?',
      'answer':
      'Yes, an active internet connection is required for real-time AI analysis and report generation.',
    },
    {
      'question': 'How much does the app cost?',
      'answer':
      'Inspexion AI is free to download and use. Enterprise tiers with high-volume scanning are also supported.',
    },
  ];

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
          text: 'Help & Support',
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
                // Support Agent Banner Card
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: AllColor.whiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 46.r,
                          color: AllColor.blueColor,
                        ),
                      ),
                      const Gap(14),
                      CustomText(
                        text: "We're Here to Help",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AllColor.blackColor,
                      ),
                      const Gap(6),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomText(
                          text: 'Find quick solutions or contact our 24/7 technical desk',
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(28),

                // Contact Methods Header
                CustomText(
                  text: 'Direct Contact Desk',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                _buildContactCard(
                  icon: Icons.alternate_email_rounded,
                  title: 'Email Support',
                  subtitle: 'support@inspexion.ai',
                  onTap: () {},
                ),
                const Gap(10),
                _buildContactCard(
                  icon: Icons.phone_in_talk_rounded,
                  title: 'Phone Helpline',
                  subtitle: '+8801402977919',
                  onTap: () {},
                ),
                const Gap(28),

                // FAQ Header
                CustomText(
                  text: 'Frequently Asked Questions',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faqItems.length,
                  separatorBuilder: (_, _) => const Gap(10),
                  itemBuilder: (context, index) {
                    return _buildFAQItem(
                      index: index,
                      question: faqItems[index]['question']!,
                      answer: faqItems[index]['answer']!,
                    );
                  },
                ),
                const Gap(28),

                // Additional Notice Card
                Container(
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AllColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AllColor.blueColor.withValues(alpha: 0.15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AllColor.blueColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.info_outline_rounded, color: AllColor.blueColor, size: 20.r),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Still need assistance?",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AllColor.blackColor,
                            ),
                            const Gap(4),
                            CustomText(
                              text: 'Our specialized field engineering support team typically responds within 2-4 business hours.',
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              maxLines: 4,
                            ),
                          ],
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

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AllColor.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AllColor.blackColor,
                  ),
                  const Gap(2),
                  CustomText(
                    text: subtitle,
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AllColor.greyColor400, size: 14.r),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final isExpanded = expandedIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: AllColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isExpanded ? AllColor.blueColor.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isExpanded ? 0.06 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          onExpansionChanged: (expanded) {
            setState(() {
              expandedIndex = expanded ? index : -1;
            });
          },
          backgroundColor: AllColor.whiteColor,
          collapsedBackgroundColor: AllColor.whiteColor,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          title: CustomText(
            text: question,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isExpanded ? AllColor.blueColor : AllColor.blackColor,
          ),
          iconColor: AllColor.blueColor,
          collapsedIconColor: AllColor.greyColor400,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: AllColor.greyColor300, height: 1),
                  const Gap(12),
                  CustomText(
                    text: answer,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    maxLines: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}