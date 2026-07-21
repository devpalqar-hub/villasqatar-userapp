import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/wishlist/view/whishlist_screen.dart';

class QuickActionsCard extends StatelessWidget {
  final void Function(String purpose) onPurposeSelected;

  const QuickActionsCard({
    super.key,
    required this.onPurposeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": Icons.home_work_outlined,
        "title": "Buy".tr,
        "subtitle": "Properties".tr,
        "onTap": () {
          onPurposeSelected("SALE");
        },
      },
      {
        "icon": Icons.apartment_outlined,
        "title": "Rent".tr,
        "subtitle": "Properties".tr,
        "onTap": () {
          onPurposeSelected("RENT");
        },
      },
      {
        "icon": Icons.favorite_border,
        "title": "Wishlist".tr,
        "subtitle": "Saved".tr,
        "onTap": () {
          Get.to(
            () => WishlistScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(
              milliseconds: 250,
            ),
          );
        },
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(8.r),
                      onTap:
                          item["onTap"] as VoidCallback,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                        ),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              item["icon"] as IconData,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              item["title"].toString(),
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight:
                                    FontWeight.w600,
                                color: const Color(
                                  0xff202124,
                                ),
                                height: 1,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              item["subtitle"]
                                  .toString(),
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight:
                                    FontWeight.w400,
                                color: const Color(
                                  0xff707070,
                                ),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (index != items.length - 1)
                    Container(
                      width: 1,
                      height: 50.h,
                      color:
                          const Color(0xffECECEC),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}