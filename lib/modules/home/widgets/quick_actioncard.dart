import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": Icons.home_work_outlined,
        "title": "Buy".tr,
        "subtitle": "Properties".tr,
      },
      {
        "icon": Icons.apartment_outlined,
        "title": "Rent".tr,
        "subtitle": "Properties".tr,
      },
      {
        "icon": Icons.location_city_outlined,
        "title": "New".tr,
        "subtitle": "Launches".tr,
      },
      {
        "icon": Icons.business_outlined,
        "title": "Luxury".tr,
        "subtitle": "Collection".tr,
      },
      {
        "icon": Icons.favorite_border,
        "title": "Shortlist".tr,
        "subtitle": "0 Saved",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          items.length,
          (index) => Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index]["icon"] as IconData,
                        color:AppColors.primary,
                        size: 24.sp,
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        items[index]["title"].toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff202124),
                          height: 1,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        items[index]["subtitle"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff707070),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                if (index != items.length - 1)
                  Container(
                    width: 1,
                    height: 50.h,
                    color: const Color(0xffECECEC),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}