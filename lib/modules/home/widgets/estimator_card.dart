import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/pricestimator/views/price_estimator_screen.dart';

class EstimatorCard extends StatelessWidget {
  const EstimatorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 215.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFF2E8EA),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // =====================================================
          // FULL BACKGROUND IMAGE
          // =====================================================

          Image.network(
            "https://images.unsplash.com/photo-1613977257363-707ba9348227?q=80&w=1400",
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return Container(
                color: const Color(0xFFF8EFF1),
                child: Icon(
                  Icons.villa_outlined,
                  size: 45.sp,
                  color: AppColors.primary,
                ),
              );
            },
          ),

          // =====================================================
          // SOFT LIGHT OVERLAY
          //
          // Strong white on left for text.
          // Gradually transparent toward image.
          // No dark overlay.
          // =====================================================

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [
                  0.00,
                  0.38,
                  0.58,
                  0.78,
                  1.00,
                ],
                colors: [
                  Color(0xFFFFF9F9),
                  Color(0xFFFFF9F9),
                  Color(0xF5FFF9F9),
                  Color(0x55FFF9F9),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // =====================================================
          // LEFT CONTENT
          // =====================================================

          Positioned(
            left: 15.w,
            top: 16.h,
            bottom: 14.h,
            width: 185.w,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // SMART & FAST

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFFFEDB8,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20.r,
                    ),
                  ),
                  child: Text(
                    "Smart & Fast".tr,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(
                        0xFF946B12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // TITLE

                Text(
                  "Estimate your property\nprice with AI".tr,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -.25,
                    color: const Color(
                      0xFF171717,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // DESCRIPTION

                SizedBox(
                  width: 175.w,
                  child: Text(
                    "Get instant property valuation based on market trends and real data in Qatar."
                        .tr,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      height: 1.4,
                      color: const Color(
                        0xFF707070,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // ESTIMATE BUTTON

                SizedBox(
                  height: 34.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => const PriceEstimatorScreen(),
                      );
                    },
                    style:
                        ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor:
                          Colors.transparent,
                      backgroundColor:
                          AppColors.primary,
                      foregroundColor:
                          Colors.white,
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 17.w,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          9.r,
                        ),
                      ),
                    ),
                    child: Text(
                      "Estimate Now".tr,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // TIME

                Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 11.sp,
                      color: const Color(
                        0xFF777777,
                      ),
                    ),

                    SizedBox(width: 4.w),

                    Text(
                      "Takes less than 2 minutes"
                          .tr,
                      style: TextStyle(
                        fontSize: 7.3.sp,
                        color: const Color(
                          0xFF6F6F6F,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =====================================================
          // ESTIMATED VALUE FLOATING CARD
          // =====================================================

          Positioned(
            top: 31.h,
            right: 32.w,
            child: Container(
              width: 124.w,
              padding: EdgeInsets.fromLTRB(
                10.w,
                9.h,
                10.w,
                9.h,
              ),
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(.94),
                borderRadius:
                    BorderRadius.circular(
                  11.r,
                ),

                // Very light shadow only
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(
                      .045,
                    ),
                    blurRadius: 8,
                    offset:
                        const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    "Estimated Value".tr,
                    style: TextStyle(
                      fontSize: 6.2.sp,
                      color: const Color(
                        0xFF888888,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    "QAR 2,450,000",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight:
                          FontWeight.w800,
                      color: const Color(
                        0xFF171717,
                      ),
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration:
                            BoxDecoration(
                          color: const Color(
                            0xFFE3F8E9,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            4.r,
                          ),
                        ),
                        child: Text(
                          "+8.5%",
                          style: TextStyle(
                            fontSize: 5.2.sp,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                const Color(
                              0xFF2F9852,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      Text(
                        "from last month".tr,
                        style: TextStyle(
                          fontSize: 5.sp,
                          color:
                              const Color(
                            0xFF888888,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  const Row(
                    children: [
                      Expanded(
                        child: _EstimateInfo(
                          title: "Property",
                          value: "Villa",
                        ),
                      ),
                      Expanded(
                        child: _EstimateInfo(
                          title: "Area",
                          value: "500 sqm",
                        ),
                      ),
                      Expanded(
                        child: _EstimateInfo(
                          title: "Location",
                          value: "Lusail",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // AI POWERED FLOATING BADGE
          // =====================================================

          Positioned(
            right: 2.w,
            bottom: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(.94),
                borderRadius:
                    BorderRadius.circular(
                  9.r,
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    alignment:
                        Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF0F2FF,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        6.r,
                      ),
                    ),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      size: 13.sp,
                      color: const Color(
                        0xFF536BE3,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Text(
                        "AI Powered".tr,
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight:
                              FontWeight.w700,
                          color:
                              const Color(
                            0xFF222222,
                          ),
                        ),
                      ),

                      Text(
                        "Accurate & Reliable".tr,
                        style: TextStyle(
                          fontSize: 5.sp,
                          color:
                              const Color(
                            0xFF888888,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimateInfo extends StatelessWidget {
  final String title;
  final String value;

  const _EstimateInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 4.8.sp,
            color: const Color(
              0xFF999999,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 5.5.sp,
            fontWeight: FontWeight.w700,
            color: const Color(
              0xFF333333,
            ),
          ),
        ),
      ],
    );
  }
}