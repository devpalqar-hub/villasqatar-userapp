import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';


class PropertyCategorySection extends StatelessWidget {
  PropertyCategorySection({super.key,required this.controller,});

 final PropertySearchController controller;

  final List<Map<String, dynamic>> categories = [
    {
      "title": "Villa",
      "type": "VILLA",
      "icon": Icons.home_outlined,
    },
    {
      "title": "Apartment",
      "type": "APARTMENT",
      "icon": Icons.apartment_outlined,
    },
    {
      "title": "Townhouse",
      "type": "TOWNHOUSE",
      "icon": Icons.house_outlined,
    },
    {
      "title": "Penthouse",
      "type": "PENTHOUSE",
      "icon": Icons.apartment,
    },
    {
      "title": "Studio",
      "type": "STUDIO",
      "icon": Icons.king_bed_outlined,
    },
    {
      "title": "Commercial",
      "type": "COMMERCIAL",
      "icon": Icons.storefront_outlined,
    },
    {
      "title": "Land",
      "type": "LAND",
      "icon": Icons.landscape_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertySearchController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Property Categories".tr,
              style: AppTextStyles.title14.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 14.h),

            SizedBox(
              height: 90.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final item = categories[index];

                  final bool selected =
                      controller.type == item["type"];

                  return CategoryChip(
                    title: item["title"],
                    icon: item["icon"],
                    selected: selected,
                    onTap: () {
                      controller.applyFilters(
                        type: item["type"],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
class CategoryChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x14000000),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 28.sp,
                color: selected
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              title.tr,
              style: AppTextStyles.body13.copyWith(
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}