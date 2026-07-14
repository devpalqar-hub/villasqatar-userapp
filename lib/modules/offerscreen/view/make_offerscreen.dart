import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/modules/offerscreen/service/offer_controller.dart';
import 'package:villas_qatar/modules/offerscreen/widget/offer_inputfield.dart';
import 'package:villas_qatar/modules/offerscreen/widget/offer_sucessdailogue.dart';
import 'package:villas_qatar/modules/offerscreen/widget/offer_textfield.dart';
import 'package:villas_qatar/modules/offerscreen/widget/property_summarycard.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_textstyles.dart';

class MakeOfferScreen extends StatelessWidget {
  MakeOfferScreen({super.key});
  final controller = Get.put(MakeOfferController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),

      body: Stack(
        children: [
            Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: IgnorePointer(
          child: Image.asset(
            "assets/bg2.png",
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  
                  /// App Bar
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => Get.back(),
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  
                      Expanded(
                        child: Center(
                          child: Text(
                            "Make an Offer".tr,
                            style: AppTextStyles.title18.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 18.h),
                  
                  /// Property Card
                  const PropertySummaryCard(),
                  
                  SizedBox(height: 18.h),
                  
                  /// Offer Details Title
                  Text(
                    "Your Offer Details".tr,
                    style: AppTextStyles.title16.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: 10.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Offer Amount
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 60.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Offer Amount",
                                style: AppTextStyles.body13.copyWith(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                  
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: "QAR  4,900,000",
                                style: AppTextStyles.title14.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                      SizedBox(width: 12.w),
                  
                      /// Currency
                      Expanded(
                        child: Container(
                          height: 60.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Currency",
                                style: AppTextStyles.body13.copyWith(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                  
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  itemHeight: 48,
                                  value: "QAR",
                                  style: AppTextStyles.title14.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16.sp,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "QAR",
                                      child: Text("QAR"),
                                    ),
                                    DropdownMenuItem(
                                      value: "USD",
                                      child: Text("USD"),
                                    ),
                                    DropdownMenuItem(
                                      value: "AED",
                                      child: Text("AED"),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xffE8E8E8)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Message to Seller",
                          style: AppTextStyles.body13.copyWith(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  
                        SizedBox(height: 6.h),
                  
                        TextFormField(
                          maxLines: 5,
                          maxLength: 500,
                          style: AppTextStyles.body14.copyWith(
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            counterStyle: AppTextStyles.body13.copyWith(
                              color: Colors.grey,
                            ),
                            hintText:
                                "I'm interested in this property and would like to make an offer. Looking forward to your response."
                                    .tr,
                            hintStyle: AppTextStyles.body14.copyWith(
                              color: Colors.grey.shade500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 22.h),
                  
                  // /// Information Card
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(16.w),
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xffFFF8EA),
                  //     borderRadius: BorderRadius.circular(14.r),
                  //     border: Border.all(color: const Color(0xffF5D98C)),
                  //   ),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: 34.w,
                  //         height: 34.w,
                  //         decoration: const BoxDecoration(
                  //           color: Color(0xffFFE9A6),
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: Icon(
                  //           Icons.info_outline,
                  //           color: Color(0xffC79200),
                  //           size: 18.sp,
                  //         ),
                  //       ),
                  
                  //       SizedBox(width: 12.w),
                  
                  //       Expanded(
                  //         child: Text(
                  //           "Your offer will be sent directly to the property owner or their authorized agent. You'll receive a notification once they respond."
                  //               .tr,
                  //           style: AppTextStyles.body13.copyWith(
                  //             color: const Color(0xff735500),
                  //             height: 1.55,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  
                  SizedBox(height: 28.h),
                  
                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const OfferSuccessDialog(),
                        );
                      },
                      child: Text(
                        "Submit Offer".tr,
                        style: AppTextStyles.bold16.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 180.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
