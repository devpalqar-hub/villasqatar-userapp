import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

class PropertyCategorySection extends StatelessWidget {
  const PropertyCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Property Categories".tr,
          style: AppTextStyles.title14.copyWith(fontWeight: FontWeight.w700),
        ),

        SizedBox(height: 14.h),

        SizedBox(
          height: 90.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:  [
              CategoryChip(title: "Villa".tr, icon: Icons.home_outlined),
              CategoryChip(title: "Apartment".tr, icon: Icons.apartment_outlined),
              CategoryChip(title: "Townhouse".tr, icon: Icons.house_outlined),
              CategoryChip(title: "Office".tr, icon: Icons.business_outlined),
              CategoryChip(
                title: "Commercial".tr,
                icon: Icons.storefront_outlined,
              ),
              CategoryChip(title: "Land".tr, icon: Icons.landscape_outlined),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryChip({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Column(
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x14000000), // ~8% black
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 28.sp),
          ),

          SizedBox(height: 8.h),

          Text(
            title,
            style: AppTextStyles.body13.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
