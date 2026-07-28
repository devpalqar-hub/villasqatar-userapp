import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/complete_profile_screen.dart';
import 'package:villas_qatar/modules/onboard/views/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: Image.asset('assets/bg1.png', fit: BoxFit.cover),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.h),

                      /// Logo
                      Image.asset('assets/Logo/homeLogo.png', width: 180.w),

                      SizedBox(height: 10.h),

                      /// Heading
                      // Text(
                      //   'Find your dream villa'.tr,
                      //   style: AppTextStyles.title18.copyWith(
                      //     color: const Color(0xFF222222),
                      //     fontSize: 21.sp,
                      //   ),
                      // ),

                      // Text(
                      //   'in Qatar'.tr,
                      //   style: AppTextStyles.title18.copyWith(
                      //     color: AppColors.primary,
                      //     fontSize: 21.sp,
                      //   ),
                      // ),
                      SizedBox(height: 10.h),

                      Container(
                        width: 55.w,
                        height: 1.h,
                        color: AppColors.primary,
                      ),

                      SizedBox(height: 20.h),

                      /// Description
                      Text(
                        'Premium living Prime locations\nThe lifestyle you deserve'
                            .tr,
                        style: AppTextStyles.body14.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// WhatsApp Button
                      _buildWhatsAppButton(),

                      SizedBox(height: 20.h),

                      /// Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              'or continue with'.tr,
                              style: AppTextStyles.body14.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      /// Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              image: "assets/google.png",
                              text: "Google",
                              onTap: () async {
                                final success = await controller
                                    .signInWithGoogle();

                                debugPrint("Google Success: $success");
                                debugPrint(
                                  "Is New User: ${controller.isNewUser}",
                                );

                                if (success) {
                                  if (controller.isNewUser) {
                                    Get.off(() => CompleteProfileScreen());
                                  } else {
                                    Get.off(() => MainScreen());
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildSocialButton(
                              image: "assets/mac.png",
                              text: "Apple",
                              onTap: () async {
                                final success = await controller
                                    .signInWithApple();

                                if (success) {
                                  if (controller.isNewUser) {
                                    // Get.offNamed(AppRoutes.completeProfile);
                                  } else {
                                    // Get.offNamed(AppRoutes.home);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25.h),

                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'By continuing, you agree to our\n'.tr,
                            style: AppTextStyles.body13.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Use'.tr,
                                style: AppTextStyles.medium13.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              TextSpan(text: ' and '.tr),
                              TextSpan(
                                text: 'Privacy Policy'.tr,
                                style: AppTextStyles.medium13.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30.h),
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

  Widget _buildWhatsAppButton() {
    return InkWell(
      onTap: () {
        Get.to(() => LoginScreen());
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: const Color(0xFF8A1538),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.chat, color: Colors.white, size: 16.sp),

            SizedBox(width: 15.w),

            Expanded(
              child: Text(
                'Continue with WhatsApp'.tr,
                style: AppTextStyles.body14.copyWith(color: Colors.white),
              ),
            ),

            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String image,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: 24.w),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body13.copyWith(
                    color: const Color(0xFF222222),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
