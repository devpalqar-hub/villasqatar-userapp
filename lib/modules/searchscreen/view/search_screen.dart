import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/searchscreen/widgets/category_section.dart';

import 'package:villas_qatar/modules/searchscreen/widgets/properties_section..dart';
import 'package:villas_qatar/modules/searchscreen/widgets/featured_properties.dart';
import 'package:villas_qatar/modules/searchscreen/widgets/search_filtercard.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_textstyles.dart';

class SearchScreen extends StatelessWidget {
 

  SearchScreen({super.key, });

  final PropertySearchController controller = Get.put(
    PropertySearchController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      body: GetBuilder<PropertySearchController>(
        builder: (controller) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshProperties,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Doha, Qatar".tr,
                            style: AppTextStyles.medium13.copyWith(
                              color: const Color(0xff3D3D3D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: AppColors.primary,
                          ),

                          const Spacer(),

                          // Stack(
                          //   clipBehavior: Clip.none,
                          //   children: [
                          //     Container(
                          //       width: 42.w,
                          //       height: 42.w,
                          //       decoration: const BoxDecoration(
                          //         color: Colors.white,
                          //         shape: BoxShape.circle,
                          //       ),
                          //       child: Icon(
                          //         Icons.notifications_none_outlined,
                          //         color: AppColors.primary,
                          //         size: 23.sp,
                          //       ),
                          //     ),

                          //     Positioned(
                          //       right: 4,
                          //       top: 5,
                          //       child: Container(
                          //         width: 16.w,
                          //         height: 16.w,
                          //         decoration: const BoxDecoration(
                          //           color: Colors.red,
                          //           shape: BoxShape.circle,
                          //         ),
                          //         alignment: Alignment.center,
                          //         child: Text(
                          //           "2",
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 8.sp,
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),

                      /// HERO SECTION
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: SizedBox(
                          height: 180.h,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              /// Background Image
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Image.asset(
                                  "assets/build.png",
                                  height: 150.h,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              /// Text Content
                              Positioned(
                                left: 0,
                                top: 15.h,
                                child: SizedBox(
                                  width: 180.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Find Your".tr,
                                        style: AppTextStyles.title18.copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.15,
                                        ),
                                      ),

                                      Text(
                                        "Dream Property".tr,
                                        style: AppTextStyles.title18.copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.15,
                                        ),
                                      ),

                                      SizedBox(height: 12.h),

                                      Text(
                                        "Buy, rent and discover the best properties around you"
                                            .tr,

                                        style: AppTextStyles.body14.copyWith(
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SearchFilterCard(
                        controller: controller,
                       
                      ),

                      SizedBox(height: 24.h),
                      PropertyCategorySection(controller: controller),
                      SizedBox(height: 18.h),

                      FeaturedProperties(),
                      SizedBox(height: 18.h),

                      PropertiesSection(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
