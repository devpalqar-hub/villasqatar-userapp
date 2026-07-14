import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class AgentContactCard extends StatelessWidget {
  const AgentContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xffECECEC)),
      ),
      child: Row(
        children: [
          /// Profile
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              "assets/agent.png",
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: const BoxDecoration(
                    color: Color(0xffF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 25.sp,
                    color: Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),

          SizedBox(width: 14.w),

          /// Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ahmed Al Thani",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff202124),
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                "Property Consultant",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xff666666),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 6.h),

              Row(
                children: [
                  Icon(Icons.star, color: const Color(0xffF5B400), size: 12.sp),
                  SizedBox(width: 4.w),
                  Text(
                    "4.9",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " (150 Reviews)",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xff666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 14.w),

          /// Actions
         Row(
  children: [
    GestureDetector(
      onTap: _makeCall,
      child: _actionButton(
        color: AppColors.primary,
        icon: const Icon(
          Icons.call_outlined,
          color: Colors.white,
        ),
        label: "Call",
      ),
    ),

    SizedBox(width: 4.w),

    GestureDetector(
      onTap: _openWhatsApp,
      child: _actionButton(
        color: const Color(0xff25D366),
        icon: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
        ),
        label: "WhatsApp",
      ),
    ),
  ],
),
        ],
      ),
    );
  }
Widget _actionButton({
  required Color color,
  required Widget icon,
  required String label,
  Border? border,
}) {
  return Column(
    children: [
      Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Center(child: icon),
      ),
      SizedBox(height: 6.h),
      Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xff333333),
        ),
      ),
    ],
  );
}


Future<void> _makeCall() async {
  const phone = "+97455123456";

  final Uri uri = Uri(
    scheme: 'tel',
    path: phone,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> _openWhatsApp() async {
  const phone = "97455123456"; // No '+' for wa.me

  final Uri uri = Uri.parse(
    "https://wa.me/$phone",
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
}
