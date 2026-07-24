import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/core/constants/app_colors.dart';
import 'package:villas_qatar/modules/searchscreen/view/search_screen.dart';

class HomeBanner extends StatefulWidget {
  final void Function(String propertyName) onSearch;
  const HomeBanner({super.key, required this.onSearch});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final TextEditingController searchController = TextEditingController();

  void _searchProperty() {
    final propertyName = searchController.text.trim();

    if (propertyName.isEmpty) return;

    FocusScope.of(context).unfocus();

    // Pass search value first
    widget.onSearch(propertyName);

    // Then clear TextField
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.asset("assets/auth_bg 1.png", fit: BoxFit.cover),
            ),

            /// White Gradient
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
                  Row(
                    children: [
                      Text(
                        "Find your".tr + " dream villa".tr,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      // Text(
                      //   ,
                      //   style: TextStyle(
                      //     fontSize: 22.sp,
                      //     fontWeight: FontWeight.w700,
                      //     color: const Color(0xffA61E3D),
                      //   ),
                      // ),
                    ],
                  ),

                  Text(
                    "in Qatar".tr,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  SizedBox(
                    width: 240.w,
                    child: Text(
                      "Discover premium villas and properties in the best locations across Qatar"
                          .tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.black.withOpacity(.9),
                        // height: 1.4,
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// Search Bar
                  ///
                  // Container(
                  //   child: Row(children: [],),
                  // )
                  SizedBox(height: 20),

                  // Row(
                  //   children: [
                  //     SizedBox(width: 20),
                  //     Container(
                  //       width: 80.w,
                  //       height: 30.w,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: AppColors.primary,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 4),
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
                              controller: searchController,

                              /// Keyboard search/enter
                              textInputAction: TextInputAction.search,

                              onSubmitted: (_) {
                                _searchProperty();
                              },

                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search property name".tr,
                                isDense: true,
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          /// Arrow Button
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: GestureDetector(
                              onTap: _searchProperty,
                              child: Container(
                                width: 35.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffA61E3D),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
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
