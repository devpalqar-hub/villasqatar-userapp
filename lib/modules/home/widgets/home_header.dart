import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

import '../../../Core/constants/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: Row(
        children: [
          Icon(Icons.menu, color: AppColors.primary, size: 24.sp),
          SizedBox(width: 40.w),

          Image.asset('assets/logo.png', width: 60.w, fit: BoxFit.contain),
          Spacer(),
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8.w),
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 14.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Doha, Qatar'.tr,
                  style: AppTextStyles.body13.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.keyboard_arrow_down, size: 16.sp),
                SizedBox(width: 4.w),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none, size: 24.sp),

              Positioned(
                right: -2.w,
                top: -2.h,
                child: CircleAvatar(
                  radius: 8.r,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '3',
                    style: AppTextStyles.body13.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
