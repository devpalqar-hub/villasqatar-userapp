import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class AgentContactButtons extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onEmail;

  const AgentContactButtons({
    super.key,
     required this.onCall,
    required this.onWhatsApp,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: _button(
            Icons.call_outlined,
            "Call",
          ),
        ),

        SizedBox(width: 12.w),

       Expanded(
  child: _button(
    FontAwesomeIcons.whatsapp,
    "WhatsApp",
  ),
),
        SizedBox(width: 12.w),

        Expanded(
          child: _button(
            Icons.email_outlined,
            "Email",
          ),
        ),
      ],
    );
  }

  Widget _button(
    IconData icon,
    String text,
  ) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.fieldBorder,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            icon,
            color: AppColors.primary,
            size: 20.sp,
          ),

          SizedBox(height: 4.h),

          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}