import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
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
              Positioned.fill(
                child: Image.asset('assets/bg1.png', fit: BoxFit.cover),
              ),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLanguageToggle(),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                            ),
                            onPressed: () {
                              Get.offAll(() => MainScreen());
                            },
                            iconAlignment: IconAlignment.end,
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18.sp,
                            ),
                            label: Text(
                              "Skip".tr,
                              style: AppTextStyles.medium14.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      /// Logo
                      Image.asset('assets/Logo/homeLogo.png', width: 180.w),
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
                      _buildWhatsAppButton(),
                      SizedBox(height: 20.h),
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
                              text: "Google".tr,
                              onTap: () async {
                                final success = await controller
                                    .signInWithGoogle();

                                debugPrint("Google Success: $success");
                                debugPrint(
                                  "Is New User: ${controller.isNewUser}",
                                );

                                // Google already gives us name + email, so
                                // there's nothing left to collect - skip
                                // Complete Profile even for new users.
                                if (success) {
                                  Get.off(() => MainScreen());
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildSocialButton(
                              image: "assets/mac.png",
                              text: "Apple".tr,
                              onTap: () async {
                                final success = await controller
                                    .signInWithApple();

                                debugPrint("Apple Success: $success");
                                debugPrint(
                                  "Is New User: ${controller.isNewUser}",
                                );

                                // Apple already gives us name + email (on
                                // first sign-in), so there's nothing left
                                // to collect - skip Complete Profile even
                                // for new users.
                                if (success) {
                                  Get.off(() => MainScreen());
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

  // ============================================================
  // LANGUAGE TOGGLE (EN / AR)
  // ============================================================
  //
  // Switches Get's locale immediately (GetMaterialApp rebuilds the
  // whole app, so every `.tr` string and the RTL/LTR direction set
  // in main.dart's Directionality both update right away) and
  // persists the choice so it survives an app restart.

  Widget _buildLanguageToggle() {
    final bool isArabic = (Get.locale?.languageCode ?? 'en') == 'ar';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withOpacity(.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _langOption(
            label: 'EN',
            selected: !isArabic,
            onTap: () => _changeLanguage('en'),
          ),
          _langOption(
            label: 'عربي',
            selected: isArabic,
            onTap: () => _changeLanguage('ar'),
          ),
        ],
      ),
    );
  }

  Widget _langOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.medium13.copyWith(
            color: selected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  void _changeLanguage(String code) {
    final Locale locale = code == 'ar'
        ? const Locale('ar', 'QA')
        : const Locale('en', 'US');

    Get.updateLocale(locale);

    StorageService.saveLanguage(code);
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

            Text(
              'Continue with WhatsApp'.tr,
              style: AppTextStyles.body14.copyWith(color: Colors.white),
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
