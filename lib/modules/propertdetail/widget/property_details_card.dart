import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyDetailsCard extends StatelessWidget {
  const PropertyDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final details = [
      {
        "icon": Icons.square_foot_outlined,
        "title": "Built-up Area",
        "value": "450 sqm",
      },
      {
        "icon": Icons.crop_square_outlined,
        "title": "Plot Size",
        "value": "620 sqm",
      },
      {
        "icon": Icons.adjust_outlined,
        "title": "Ownership",
        "value": "Freehold",
      },
      {
        "icon": Icons.verified_user_outlined,
        "title": "Completion",
        "value": "May 15, 2024",
      },
      {
        "icon": Icons.explore_outlined,
        "title": "Facing",
        "value": "North East",
      },
      {
        "icon": Icons.chair_outlined,
        "title": "Furnishing",
        "value": "Fully Furnished",
      },
      {
        "icon": Icons.home_work_outlined,
        "title": "Property Type",
        "value": "Villa",
      },
      {
        "icon": Icons.sell_outlined,
        "title": "Purpose",
        "value": "For Sale",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:16.w,vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xffECECEC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Property Details",
            style: TextStyle(
              fontSize:16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 18.h),

          ...details.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    item["icon"] as IconData,
                    color: const Color(0xff3D3D3D),
                    size: 16.sp,
                  ),

                  SizedBox(width: 14.w),

                  Expanded(
                    child: Text(
                      item["title"].toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff222222),
                      ),
                    ),
                  ),

                  Text(
                    item["value"].toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff666666),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "View All Details",
                  style: TextStyle(
                    color: const Color(0xffA61E3D),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward,
                  color: const Color(0xffA61E3D),
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}