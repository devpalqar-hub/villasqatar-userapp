import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/propertdetail/propertydetailscreen.dart';

import '../../../core/constants/app_colors.dart';

class PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String distance;
  final String price;
  final String sqm;
  // final String timeAgo;
  // final String views;
  final String beds;
  final bool verified;
  final String tag;

  const PropertyCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.distance,
    required this.price,
    required this.sqm,
    // required this.timeAgo,
    // required this.views,
    required this.beds,
    this.verified = true,
    this.tag = 'Featured',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (_, animation, secondaryAnimation) =>
                const PropertyDetailsScreen(),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Right
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: 168.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.r),
                  ),
                  child: Image.asset(
                    image,
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// TAG
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.medium13.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),

                /// FAVORITE
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_border, size: 18.sp),
                  ),
                ),

                /// BOTTOM INFO
                Positioned(
                  bottom: 8.h,
                  left: 10.w,
                  right: 10.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                beds,
                                style: AppTextStyles.medium13.copyWith(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              // Text(
                              //   views,
                              //   style:
                              //       AppTextStyles.medium13.copyWith(
                              //     color: Colors.white,
                              //     fontSize: 11.sp,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Icon(
                            verified
                                ? Icons.verified
                                : Icons.warning_amber_rounded,
                            color: verified
                                ? const Color(0xFF22C55E)
                                : Colors.orange,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            verified ? 'Verified' : 'Not Verified',
                            style: AppTextStyles.medium13.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title16.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// LOCATION
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body13.copyWith(
                            fontSize: 8.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        distance,
                        style: AppTextStyles.medium13.copyWith(
                          fontSize: 8.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  /// PRICE
                  Text(
                    price,
                    style: AppTextStyles.bold14.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  /// FOOTER
                  Row(
                    children: [
                      Text(
                        "5 Beds",
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "6 Baths",
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "450 sqm",
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                    ],
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
