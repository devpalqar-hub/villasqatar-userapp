import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class AgentAboutCard extends StatelessWidget {
  const AgentAboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Text(
        "Ahmed Al-Mansoori has over 8 years of experience in Qatar's real estate market. He specializes in luxury villas, apartments, townhouses, commercial buildings and investment properties. His commitment to client satisfaction has earned him excellent reviews and long-term customer relationships.",
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey.shade700,
          height: 1.6,
        ),
      ),
    );
  }
}
