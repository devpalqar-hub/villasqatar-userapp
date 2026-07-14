import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

import '../../../Core/constants/app_colors.dart';


class WhyChooseCard extends StatelessWidget {
  const WhyChooseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.authInfoBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why choose Villas Qatar?'.tr,
                  style: AppTextStyles.medium13.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  'Wide range of verified properties'.tr,
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}