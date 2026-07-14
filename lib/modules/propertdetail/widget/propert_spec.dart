import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertySpecsCard extends StatelessWidget {
  const PropertySpecsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final specs = [
      {
        "icon": Icons.bed_outlined,
        "value": "5",
        "label": "Bedrooms",
      },
      {
        "icon": Icons.bathtub_outlined,
        "value": "6",
        "label": "Bathrooms",
      },
      {
        "icon": Icons.crop_square_outlined,
        "value": "450 sqm",
        "label": "Area",
      },
      {
        "icon": Icons.directions_car_outlined,
        "value": "4",
        "label": "Parking",
      },
      {
        "icon": Icons.stairs_outlined,
        "value": "2",
        "label": "Floors",
      },
      {
        "icon": Icons.calendar_month_outlined,
        "value": "2024",
        "label": "Year Built",
      },
    ];

    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specs.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final item = specs[index];

          return Container(
            width: 105.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xffECECEC),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Icon + Value
                Row(
                  children: [
                    Icon(
                      item["icon"] as IconData,
                      color: const Color(0xffA61E3D),
                      size: 20.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        item["value"].toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                /// Label
                Text(
                  item["label"].toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}