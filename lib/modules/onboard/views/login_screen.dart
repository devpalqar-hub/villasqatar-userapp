
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/primary_button.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';

import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset("assets/auth_bg.png", fit: BoxFit.cover),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),

                      Image.asset("assets/Logo/homeLogo.png", width: 120.w),

                      SizedBox(height: 20.h),

                      /// Title
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Login with ".tr,
                              style: AppTextStyles.bold16.copyWith(
                                fontSize: 21.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: "WhatsApp".tr,
                              style: AppTextStyles.bold16.copyWith(
                                fontSize: 21.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      /// Subtitle
                      Text(
                        "Enter your WhatsApp number to\nreceive an OTP".tr,
                        style: AppTextStyles.body13.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Container(
  height: 52.h,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.r),
    border: Border.all(color: AppColors.border),
  ),
  child: Row(
    children: [
      SizedBox(
        width: 110.w,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCountry,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            items: ["QA", "IN", "AE", "US"]
                .map((code) {
                  final country =
                      CountryPickerUtils.getCountryByIsoCode(code);

                  return DropdownMenuItem<String>(
                    value: code,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22.w,
                            height: 16.h,
                            child: CountryPickerUtils
                                .getDefaultFlagImage(country),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "+${country.phoneCode}",
                            style: AppTextStyles.body13,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList(),
            onChanged: (value) {
              if (value == null) return;

              controller.selectedCountry = value;

              controller.phoneNumber =
                  "${controller.selectedCountryCode}${controller.phoneController.text.trim()}";

              controller.update();
            },
          ),
        ),
      ),

      Container(
        width: 1,
        height: 28.h,
        color: AppColors.border,
      ),

      Expanded(
        child: TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          style: AppTextStyles.body14,
          onChanged: (value) {
            controller.phoneNumber =
                "${controller.selectedCountryCode}${value.trim()}";
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            hintText: "WhatsApp Number".tr,
            hintStyle: AppTextStyles.body14.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ),
      ),
    ],
  ),
),

                      SizedBox(height: 25.h),

                      PrimaryButton(
                        title: controller.isLoading
                            ? "Sending..."
                            : "Send OTP".tr,
                        suffix: controller.isLoading
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                        onTap: controller.isLoading
                            ? null
                            : () async {
                                final success = await controller.sendOtp();

                                if (success) {
                                  Get.to(() => OtpScreen());
                                }
                              },
                      ),

                      SizedBox(height: 55.h),

                      /// Info Card
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.authInfoBackground,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 42.w,
                              width: 42.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.authIconBackground,
                              ),
                              child: Icon(
                                Icons.shield_outlined,
                                color: AppColors.primary,
                                size: 22.sp,
                              ),
                            ),

                            SizedBox(width: 14.w),

                            Expanded(
                              child: Text(
                                "We will send an OTP to your WhatsApp to verify your account"
                                    .tr,
                                style: AppTextStyles.body13.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
