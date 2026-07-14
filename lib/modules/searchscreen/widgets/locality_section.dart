import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

class PopularLocalitiesSection extends StatelessWidget {
  const PopularLocalitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          children: [
            Text(
              "Popular Localities".tr,
              style: AppTextStyles.title18.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {},
              child: Row(
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
          size: 16.sp,
        ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemBuilder: (_, index) {
              final data = [
                {
                  "image": "assets/lct1.jpeg",
                  "title": "The Pearl\nQatar",
                  "count": "1.2K+",
                },
                {
                  "image": "assets/lct.jpeg",
                  "title": "West Bay\nDoha",
                  "count": "856+",
                },
                {
                  "image": "assets/lct.jpeg",
                  "title": "Lusail City\nQatar",
                  "count": "743+",
                },
              ];

              return LocalityCard(
                image: data[index]["image"]!,
                title: data[index]["title"]!,
                properties: data[index]["count"]!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class LocalityCard extends StatelessWidget {
  final String image;
  final String title;
  final String properties;

  const LocalityCard({
    super.key,
    required this.image,
    required this.title,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 80.h, // Fixed card height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Important
      child: Row(
        children: [
          /// Left Image
          SizedBox(
            width: 78.w,
            height: double.infinity,
            child: Image.asset(image, fit: BoxFit.cover),
          ),

          SizedBox(width: 12.w),

          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: AppTextStyles.title16.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            
                SizedBox(height: 4.h),
            
                Text(
                  properties,
                  style: AppTextStyles.title16.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            
                SizedBox(height: 2.h),
            
                Text(
                  "Properties",
                  style: AppTextStyles.body14.copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xff6E6E73),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
