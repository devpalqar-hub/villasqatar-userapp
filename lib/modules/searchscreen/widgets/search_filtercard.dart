import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_textstyles.dart';

class SearchFilterCard extends StatefulWidget {
  const SearchFilterCard({super.key});

  @override
  State<SearchFilterCard> createState() => _SearchFilterCardState();
}

class _SearchFilterCardState extends State<SearchFilterCard> {
  int selectedTab = 0;

  final List<String> tabs = ["Buy".tr, "Rent".tr, "PG/Co-living".tr];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w, bottom: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// BUY RENT PG TABS
          SizedBox(
            height: 35.h,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final selected = selectedTab == index;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: AppTextStyles.title16.copyWith(
                                fontSize: 14.sp,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xff32354A),
                              ),
                            ),
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 1.5.h,
                          width: selected ? 72.w : 0,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 2.h),

          Divider(color: const Color(0xffECECEC), thickness: 1, height: 1),

          SizedBox(height: 12.h),

          Row(
            children: [
              /// Search Field
              Expanded(
                child: Container(
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xffE6E9EF),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18.sp,
                        color: const Color(0xff8E95A4),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: TextField(
                          style: AppTextStyles.body14.copyWith(
                            color: const Color(0xff32354A),
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: "Search by location or property".tr,
                            hintStyle: AppTextStyles.body13.copyWith(
                              color: const Color(0xffA5ADBA),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Current Location Button
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {},
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xffE6E9EF),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              /// Property Type
              Expanded(
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "Property Type".tr,
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: const Color(0xff7E8797),
                      ),
                      style: AppTextStyles.body13.copyWith(
                        color: const Color(0xff32354A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedItemBuilder: (context) {
                        return  [
                              Text("Property Type".tr),
                              Text("Villa".tr),
                              Text("Apartment".tr),
                              Text("Townhouse".tr),
                              Text("Commercial".tr),
                            ]
                            .map(
                              (e) => Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: e,
                                ),
                              ),
                            )
                            .toList();
                      },
                      items:  [
                        DropdownMenuItem(
                          value: "Property Type".tr,
                          child: Text("Property Type".tr),
                        ),
                        DropdownMenuItem(value: "Villa".tr, child: Text("Villa".tr)),
                        DropdownMenuItem(
                          value: "Apartment".tr,
                          child: Text("Apartment".tr),
                        ),
                        DropdownMenuItem(
                          value: "Townhouse".tr,
                          child: Text("Townhouse".tr),
                        ),
                        DropdownMenuItem(
                          value: "Commercial".tr,
                          child: Text("Commercial".tr),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// Price Range
              Expanded(
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: "Price Range".tr,
                      isExpanded: true,
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: const Color(0xff7E8797),
                      ),
                      style: AppTextStyles.body13.copyWith(
                        color: const Color(0xff32354A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedItemBuilder: (context) {
                        return [
                              Text("Price Range".tr),
                              Text("QAR 500K"),
                              Text("QAR 1M"),
                              Text("QAR 2M"),
                              Text("QAR 5M+"),
                            ]
                            .map(
                              (e) => Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: e,
                                ),
                              ),
                            )
                            .toList();
                      },
                      items:  [
                        DropdownMenuItem(
                          value: "Price Range".tr,
                          child: Text("Price Range"),
                        ),
                        DropdownMenuItem(
                          value: "QAR 500K",
                          child: Text("QAR 500K"),
                        ),
                        DropdownMenuItem(
                          value: "QAR 1M",
                          child: Text("QAR 1M"),
                        ),
                        DropdownMenuItem(
                          value: "QAR 2M",
                          child: Text("QAR 2M"),
                        ),
                        DropdownMenuItem(
                          value: "QAR 5M+",
                          child: Text("QAR 5M+"),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// Filters Button
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 7.w,
                              height: 7.w,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 6.w),

                      Text(
                        "Filters".tr,
                        style: AppTextStyles.body13.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff32354A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Search action
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, color: Colors.white, size: 20.sp),

                  SizedBox(width: 10.w),

                  Text(
                    "Search Properties".tr,
                    style: AppTextStyles.title16.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
