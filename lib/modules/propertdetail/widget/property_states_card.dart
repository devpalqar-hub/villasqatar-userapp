import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {"icon": Icons.weekend_outlined, "title": "Spacious living and dining areas"},
      {"icon": Icons.kitchen_outlined, "title": "Fully equipped modern kitchen"},
      {"icon": Icons.pool_outlined, "title": "Private swimming pool"},
      {"icon": Icons.bedroom_parent_outlined, "title": "Maid's room and driver's room"},
      {"icon": Icons.landscape_outlined, "title": "Majlis room and terrace views"},
      {"icon": Icons.garage_outlined, "title": "Covered parking for 3 cars"},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:16.w,vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Text(
            "Overview",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 6.h),

          /// Description
          Text(
            "Experience luxury living at its finest with this stunning 5-bedroom villa located in the heart of The Pearl.",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.2,
            ),
          ),

          SizedBox(height: 15.h),

          /// Features
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 5,
            ),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 25.h,
                    width: 25.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffFCEEEF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      features[index]["icon"] as IconData,
                      size: 14.sp,
                      color: const Color(0xff9E1B32),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  Expanded(
                    child: Text(
                      features[index]["title"].toString(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xff4B5563),
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}