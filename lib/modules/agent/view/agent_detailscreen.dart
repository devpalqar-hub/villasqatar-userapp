import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/agent/widgets/agent_about_card.dart';
import 'package:villas_qatar/modules/agent/widgets/agent_bottombar.dart';
import 'package:villas_qatar/modules/agent/widgets/agent_contact_button.dart';
import 'package:villas_qatar/modules/agent/widgets/agent_profile_card.dart';
import 'package:villas_qatar/modules/agent/widgets/agent_status_card.dart';
import 'package:villas_qatar/modules/agent/widgets/agnet_Specilaization_chip.dart';
import 'package:villas_qatar/modules/agent/widgets/agnet_langauge_chip.dart';
import 'package:villas_qatar/modules/agent/widgets/agnet_review_card.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';

// your existing property card

class AgentDetailScreen extends StatelessWidget {
  const AgentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Agent Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: AppColors.primary),
          ),
        ],
      ),

      bottomNavigationBar: const AgentBottomBar(),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 18.h,
          bottom: 120.h,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile
            const AgentProfileCard(),

            SizedBox(height: 20.h),

            AgentContactButtons(
              onCall: () => _makeCall("+97455123456"),
              onWhatsApp: () => _openWhatsApp("+97455123456"),
              onEmail: () => _sendEmail("agent@villasqatar.com"),
            ),

            SizedBox(height: 22.h),

            _title("About"),

            SizedBox(height: 10.h),

            const AgentAboutCard(),

            SizedBox(height: 22.h),

            _title("Professional Statistics"),

            SizedBox(height: 12.h),

            Row(
              children: [
                const Expanded(
                  child: AgentStatsCard(
                    icon: Icons.home_work_outlined,
                    value: "126",
                    title: "Properties",
                  ),
                ),

                SizedBox(width: 12.w),

                const Expanded(
                  child: AgentStatsCard(
                    icon: Icons.workspace_premium_outlined,
                    value: "8+",
                    title: "Years",
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                const Expanded(
                  child: AgentStatsCard(
                    icon: Icons.handshake_outlined,
                    value: "450+",
                    title: "Deals",
                  ),
                ),

                SizedBox(width: 12.w),

                const Expanded(
                  child: AgentStatsCard(
                    icon: Icons.star_outline,
                    value: "4.9",
                    title: "Rating",
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            _title("Languages"),

            SizedBox(height: 12.h),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                AgentLanguageChip(title: "English"),
                AgentLanguageChip(title: "Arabic"),
                AgentLanguageChip(title: "Hindi"),
                AgentLanguageChip(title: "Urdu"),
              ],
            ),

            SizedBox(height: 24.h),

            _title("Specializations"),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                AgentSpecializationChip(title: "Luxury Villas"),
                AgentSpecializationChip(title: "Apartments"),
                AgentSpecializationChip(title: "Townhouses"),
                AgentSpecializationChip(title: "Commercial"),
                AgentSpecializationChip(title: "Offices"),
                AgentSpecializationChip(title: "Land"),
              ],
            ),

            SizedBox(height: 28.h),

            _title("Featured Properties"),

            SizedBox(height: 14.h),

            SizedBox(
              height: 225.h,

              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  PropertyCard(
                    image: 'assets/villa.jpg',
                    title: 'Luxury Villa',
                    location: 'The Pearl',
                    distance: '2 km',
                    price: 'QAR 5,250,000',
                    sqm: '220 SQM',
                    beds: '5',
                  ),

                  PropertyCard(
                    image: 'assets/villa1.webp',
                    title: 'Modern Apartment',
                    location: 'West Bay',
                    distance: '4 km',
                    price: 'QAR 2,150,000',
                    sqm: '150 SQM',
                    beds: '3',
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            _title("Customer Reviews"),

            SizedBox(height: 12.h),

            const AgentReviewCard(),

            SizedBox(height: 12.h),

            const AgentReviewCard(),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,

      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final number = phone.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri uri = Uri.parse('https://wa.me/$number');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Property Inquiry',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
