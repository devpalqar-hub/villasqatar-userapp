import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

class PropertySummaryCard extends StatelessWidget {
  const PropertySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:16.w,vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xffECECEC),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Property Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.asset(
              "assets/villa.jpg",
              width: 110.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Featured
               

                Text(
                  "Luxury Villa in The Pearl",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body13.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                ),

                SizedBox(height: 6.h),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15.sp,
                      color: AppColors.primary
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "The Pearl, Doha",
                        style: AppTextStyles.body13.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                Text(
                  "QAR 3,250,000",
                  style: AppTextStyles.title16.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 10.h),

                Row(
                  children: [
                    _feature(Icons.bed_outlined, "5"),
                    SizedBox(width: 14.w),
                    _feature(Icons.bathtub_outlined, "6"),
                    SizedBox(width: 14.w),
                    _feature(Icons.square_foot_outlined, "450 sqm"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15.sp,
          color: Colors.grey.shade600,
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: AppTextStyles.body13.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}