import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

class FeaturedPropertySection extends StatelessWidget {
  const FeaturedPropertySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Featured Properties".tr,
              style: AppTextStyles.title18.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Spacer(),

            Row(
              children: [
                Text(
                  "See All".tr,
                  style: AppTextStyles.body14.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 16.sp
                  
                ),
               
              ],
            ),
          ],
        ),

        SizedBox(height: 14.h),

        const FeaturedPropertyCard(),

        const FeaturedPropertyCard(),
      ],
    );
  }
}

class FeaturedPropertyCard extends StatelessWidget {
  const FeaturedPropertyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
                child: Image.asset(
                  "assets/villa.jpg",
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                left: 14.w,
                top: 14.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    "FEATURED".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 14.w,
                top: 14.h,
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),

              Positioned(
                bottom: 14.h,
                right: 14.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "12",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Luxury Villa in The Pearl",
                  style: AppTextStyles.title14.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 4.h),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: Colors.grey,
                    ),

                    SizedBox(width: 4.w),

                    Text(
                      "The Pearl, Doha",
                      style: AppTextStyles.body13.copyWith(color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                Row(
                  children: const [
                    PropertyFeatureChip(
                      icon: Icons.king_bed_outlined,
                      value: "5",
                    ),
                    PropertyFeatureChip(
                      icon: Icons.bathtub_outlined,
                      value: "6",
                    ),
                    PropertyFeatureChip(
                      icon: Icons.square_foot_outlined,
                      value: "450 sqm",
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    Text(
                      "QAR 4,900,000",
                      style: AppTextStyles.title16.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF4F6),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Text(
                        "For Sale".tr,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyFeatureChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const PropertyFeatureChip({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 18.w),
      child: Row(
        children: [
          Icon(icon, size: 17.sp, color: const Color(0xff7A7A7A)),

          SizedBox(width: 5.w),

          Text(
            value,
            style: AppTextStyles.body13.copyWith(
              color: const Color(0xff555555),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
