import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class PropertyLocationCard extends StatelessWidget {
  const PropertyLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 14.w),
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
          /// Heading
          Text(
            "Location",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 12.h),

          /// Map
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  "https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1200",
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.45),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color:AppColors.primary,
                      size: 20.sp,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        "The Pearl, Doha",
                        style: TextStyle(
                          color:AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 6.h),

          _locationItem(
            Icons.flight_takeoff_outlined,
            "12 min",
            "to Hamad International Airport",
          ),

          SizedBox(height: 6.h),

          _locationItem(
            Icons.school_outlined,
            "2.1 km",
            "to International School",
          ),

          SizedBox(height: 6.h),

          _locationItem(
            Icons.train_outlined,
            "1.3 km",
            "to Nearest Metro Station",
          ),

          SizedBox(height: 14.h),

          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xffA61E3D),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.map_outlined,
                color: const Color(0xffA61E3D),
                size: 22.sp,
              ),
              label: Text(
                "View on Maps",
                style: TextStyle(
                  color: const Color(0xffA61E3D),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationItem(
      IconData icon,
      String value,
      String subtitle,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: const Color(0xff444444),
        ),
        SizedBox(width: 14.w),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xff666666),
            ),
            children: [
              TextSpan(
                text: "$value ",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              TextSpan(text: subtitle),
            ],
          ),
        ),
      ],
    );
  }
}