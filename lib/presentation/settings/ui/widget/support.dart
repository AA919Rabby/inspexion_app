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
          'Inspexion AI works on Android devices running Android 8.0 or higher. iOS support is coming soon!',
    },
    {
      'question': 'How accurate is the AI analysis?',
      'answer':
          'Our AI model has been trained on thousands of images and achieves over 95% accuracy. However, we recommend professional verification for critical inspections.',
    },
    {
      'question': 'Do I need internet for inspections?',
      'answer':
          'Yes, an active internet connection is required for real-time AI analysis and report generation.',
    },
    {
      'question': 'How much does the app cost?',
      'answer':
          'Inspexion AI is free to download and use. Premium features may be available in the future.',
    },
  ];

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
          text: 'Help & Support',
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
                // Support Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AllColor.blueColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.support_agent,
                          size: 50.r,
                          color: AllColor.blueColor,
                        ),
                      ),
                       const Gap(12),
                       CustomText(
                         text: 'We\'re Here to Help',
                         fontSize: 22,
                         fontWeight: FontWeight.bold,
                         color: AllColor.blackColor,
                       ),
                       const Gap(8),
                       CustomText(
                         text:
                             'Find answers to common questions or contact our support team',
                         fontSize: 14,
                         textAlign: TextAlign.center,
                       ),
                    ],
                  ),
                ),
                const Gap(28),

                // Contact Methods
                CustomText(
                  text: 'Contact Us',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                _buildContactCard(
                  icon: Icons.email,
                  title: 'Email Support',
                  subtitle: 'support@inspexion.ai',
                  onTap: () {
                    // Handle email
                  },
                ),
                Gap(12.h),
                _buildContactCard(
                  icon: Icons.phone,
                  title: 'Phone Support',
                  subtitle: '+8801402977919',
                  onTap: () {
                    // Handle phone
                  },
                ),
                const Gap(12),
                _buildContactCard(
                  icon: Icons.chat_bubble,
                  title: 'Live Chat',
                  subtitle: 'Available 24/7',
                  onTap: () {
                    // Handle live chat
                  },
                ),
                const Gap(28),

                // Frequently Asked Questions
                CustomText(
                  text: 'Frequently Asked Questions',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faqItems.length,
                  separatorBuilder: (_, _) => const Gap(8),
                  itemBuilder: (context, index) {
                    return _buildFAQItem(
                      index: index,
                      question: faqItems[index]['question']!,
                      answer: faqItems[index]['answer']!,
                    );
                  },
                ),
                const Gap(28),

                // Resources
                CustomText(
                  text: 'Resources',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(12),
                _buildResourceCard(
                  icon: Icons.school,
                  title: 'User Guide',
                  description: 'Learn how to use Inspexion AI',
                  onTap: () {
                    // Navigate to user guide
                  },
                ),
                const Gap(12),
                _buildResourceCard(
                  icon: Icons.video_library,
                  title: 'Video Tutorials',
                  description: 'Watch step-by-step tutorials',
                  onTap: () {
                    // Navigate to video tutorials
                  },
                ),
                const Gap(12),
                _buildResourceCard(
                  icon: Icons.bug_report,
                  title: 'Report a Bug',
                  description: 'Help us improve the app',
                  onTap: () {
                    // Navigate to bug report
                  },
                ),
                const Gap(12),
                _buildResourceCard(
                  icon: Icons.lightbulb,
                  title: 'Feature Request',
                  description: 'Suggest a new feature',
                  onTap: () {
                    // Navigate to feature request
                  },
                ),
                const Gap(28),

                // Additional Help
                Card(
                  color: AllColor.blueColor.withValues(alpha: 0.05),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: AllColor.blueColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: AllColor.blueColor,
                              size: 24.r,
                            ),
                            Gap(12.w),
                            Expanded(
                              child: CustomText(
                                text: 'Didn\'t find what you\'re looking for?',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AllColor.blackColor,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        CustomText(
                          text:
                              'Our support team is ready to help. Reach out to us via email or live chat and we\'ll get back to you as soon as possible.',
                          fontSize: 13,
                          color: AllColor.blackColor,
                          maxLines: 5,
                        ),
                      ],
                    ),
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
      child: Card(
        color: AllColor.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
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
                      text: subtitle,
                      fontSize: 12,
                      color: AllColor.greyColor400,
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.arrow_forward_ios,
              //   color: AllColor.blueColor,
              //   size: 16.r,
              // ),
            ],
          ),
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

    return Card(
      color: AllColor.whiteColor,
      elevation: isExpanded ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              expandedIndex = expanded ? index : -1;
            });
          },
          backgroundColor: AllColor.whiteColor,
          collapsedBackgroundColor: AllColor.whiteColor,
           title: CustomText(
             text: question,
             fontSize: 13,
             fontWeight: FontWeight.bold,
             color: AllColor.blackColor,
           ),
           iconColor: AllColor.blueColor,
           collapsedIconColor: AllColor.greyColor400,
           children: [
             Padding(
               padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.r),
               child: Divider(color: AllColor.greyColor300, height: 1),
             ),
             Padding(
               padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.r),
               child: CustomText(
                 text: answer,
                 fontSize: 12,
                 color: AllColor.blackColor,
                 maxLines: 20,
               ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AllColor.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
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
                      color: AllColor.greyColor400,
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.arrow_forward_ios,
              //   color: AllColor.blueColor,
              //   size: 16.r,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
