import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class OverviewCard extends StatelessWidget {
  final Property property;

  const OverviewCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final features = <Map<String, dynamic>>[
      ...property.amenities.map(
        (e) => {"icon": Icons.check_circle_outline, "title": e},
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Text(
            "Overview".tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 6.h),

          /// Description
          Text(
            property.description,
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
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.h,
              childAspectRatio: 5,
            ),
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      features[index]["title"].toString(),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 10.sp,
                        height: 1.3,
                        color: Colors.black,
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
