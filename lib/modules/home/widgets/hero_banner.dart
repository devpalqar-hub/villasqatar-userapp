import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.asset(
                "assets/auth_bg 1.png", // Your asset image
                fit: BoxFit.cover,
              ),
            ),

            /// White Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(.75),
                      Colors.white.withOpacity(.75),
                      Colors.white.withOpacity(.25),
                    ],
                    stops: const [0, .45, .75, 1],
                  ),
                ),
              ),
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Find your".tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    "dream villa".tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffA61E3D),
                    ),
                  ),

                  Text(
                    "in Qatar".tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  SizedBox(
                    width: 220.w,
                    child: Text(
                      "Discover premium villas and properties in the best locations across Qatar"
                          .tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade700,
                        height: 1.4.h,
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// Search Bar
                  Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),

                          Icon(Icons.search, color: Colors.grey, size: 18.sp),

                          SizedBox(width: 10.w),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    "Search location, property name or type".tr,
                                isDense: true,
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Container(
                              width: 35.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffA61E3D),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
