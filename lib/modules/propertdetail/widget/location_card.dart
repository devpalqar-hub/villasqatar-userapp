import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required String title, required String distance, required String image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:20.w,vertical:10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Title
          Row(
            children: [

              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: const Color(0xff8E123E).withOpacity(.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.location_on,
                  color:AppColors.primary,
                  size: 15.sp,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      "The Pearl, Doha, Qatar",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        

          /// Map Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [

                Image.network(
                  "https://images.unsplash.com/photo-1524661135-423995f22d0b",
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                ),

                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.35),
                      ],
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff8E123E),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 22.h),

          /// Nearby Places
          Row(
            children: [

              Expanded(
                child: _NearbyItem(
                  icon: Icons.flight_takeoff,
                  title: "Airport",
                  value: "18 km",
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _NearbyItem(
                  icon: Icons.train,
                  title: "Metro",
                  value: "700 m",
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [

              Expanded(
                child: _NearbyItem(
                  icon: Icons.school,
                  title: "School",
                  value: "2.5 km",
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: _NearbyItem(
                  icon: Icons.shopping_bag,
                  title: "Mall",
                  value: "1.2 km",
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          /// Button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff8E123E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.map_outlined,
                color: Colors.white,
              ),
              label: Text(
                "View on Maps",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _NearbyItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xff8E123E).withOpacity(.08),
              borderRadius: BorderRadius.circular(1.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xff8E123E),
              size: 20.sp,
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
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