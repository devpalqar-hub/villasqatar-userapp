import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Core/constants/app_colors.dart';
import '../../../Core/theme/app_textstyles.dart';
import '../../chats/service/chat_controller.dart';
import '../../chats/views/chat_startscreen.dart';
import '../../propertylist/model/myproperty_model.dart';

class MakeOfferDialog extends StatefulWidget {
  final Property property;

  const MakeOfferDialog({
    super.key,
    required this.property,
  });

  @override
  State<MakeOfferDialog> createState() => _MakeOfferDialogState();
}

class _MakeOfferDialogState extends State<MakeOfferDialog>
    with SingleTickerProviderStateMixin {
  late final TextEditingController offerController;

  String currency = "QAR";

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    offerController = TextEditingController(
      text: widget.property.price.toStringAsFixed(0),
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    scaleAnimation = Tween<double>(
      begin: .85,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      ),
    );

    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    offerController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22.w,
                10.h,
                22.w,
                10.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Close
                  Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: Get.back,
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 15.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  /// Title
                  Text(
                    "Make an Offer",
                    style: AppTextStyles.title16.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "Enter your best offer for this property.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body12.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// Property Price
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal:12.w,vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffFAF6F8),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Listed Price",
                          style: AppTextStyles.body12.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "QAR ${_formatPrice(widget.property.price)}",
                          style: AppTextStyles.title16.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// Offer Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Offer Amount",
                      style: AppTextStyles.body13.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Offer Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.fieldBg,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: offerController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: AppTextStyles.title14.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              hintText: "Enter amount",
                            ),
                          ),
                        ),

                        Container(
                          height: 32.h,
                          width: 1,
                          color: AppColors.fieldBorder,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: currency,
                              borderRadius: BorderRadius.circular(12),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              style: AppTextStyles.medium14.copyWith(
                                color: Colors.black87,
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
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  currency = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Divider(
                    color: Colors.grey.shade200,
                    height: 1,
                  ),

                  SizedBox(height: 18.h),
                                    Text(
                    "Continue the conversation with the property owner.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body12.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  Row(
                    children: [
                      ///================ Chat Button ===================
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.back();

                              if (Get.isRegistered<ChatController>()) {
                                Get.delete<ChatController>();
                              }

                              Get.put(
                                ChatController(
                                  listingId: widget.property.id!,
                                ),
                              );

                              Get.to(
                                () => ChatStartScreen(
                                  property: widget.property,
                                  showPropertyCard: false,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 15.sp,
                            ),
                            label: Text(
                              "Chat Seller",
                              style: AppTextStyles.body12.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      ///================ Send Offer ===================
                      Expanded(
                        child: SizedBox(
                          height: 50.h,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (offerController.text.trim().isEmpty) {
                                Get.snackbar(
                                  "Offer Required",
                                  "Please enter your offer amount.",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }

                              Get.back();

                              if (Get.isRegistered<ChatController>()) {
                                Get.delete<ChatController>();
                              }

                              Get.put(
                                ChatController(
                                  listingId: widget.property.id!,
                                ),
                              );

                              Get.to(
                                () => ChatStartScreen(
                                  property: widget.property,
                                  initialMessage:
                                      "I'm ready to buy this property for $currency ${offerController.text}",
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.send_rounded,
                              size: 15.sp,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Send Offer",
                              style: AppTextStyles.body12.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(num? price) {
    if (price == null) return "0";

    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ",",
        );
  }
}