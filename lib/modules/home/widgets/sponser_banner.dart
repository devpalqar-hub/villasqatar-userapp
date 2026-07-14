import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvestmentBanner extends StatelessWidget {
  const InvestmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.asset(
                "assets/banner_img.png",
                fit: BoxFit.cover,
              ),
            ),

            /// Burgundy overlay (same feel as screenshot)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff8C1437).withOpacity(.12),
                ),
              ),
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 22.w,
                vertical: 22.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Investment Opportunities",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  SizedBox(
                    width: 190.w,
                    child: Text(
                      "High ROI properties in top\nlocations across Qatar",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.92),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ),

               SizedBox(height: 12.h),

                  SizedBox(
                    width: 160.w,
                    height: 40.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.white.withOpacity(.35),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        backgroundColor: Colors.white.withOpacity(.05),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Explore Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 15.sp,
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