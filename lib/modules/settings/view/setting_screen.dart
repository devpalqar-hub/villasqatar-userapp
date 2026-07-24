import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/PlansandFeatures/views/my_featuresscreen.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';
import 'package:villas_qatar/modules/settings/view/language_screen.dart';
import 'package:villas_qatar/modules/support/views/supports_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Settings".tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff222222),
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // PROFILE
              // ==================================================
              _profileCard(),

              SizedBox(height: 26.h),

              // ==================================================
              // ACCOUNT
              // ==================================================
              _sectionTitle("Account".tr),

              SizedBox(height: 10.h),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.person_outline_rounded,
                    title: "Edit Profile".tr,
                    onTap: () {},
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.favorite_border_rounded,
                    title: "Saved Properties".tr,
                    onTap: () {},
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.home_work_outlined,
                    title: "My Featured Properties".tr,
                    onTap: () {
                      Get.to(
                        () => const MyFeaturedPropertiesScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // PREFERENCES
              // ==================================================
              _sectionTitle("Preferences".tr),

              SizedBox(height: 10.h),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.language_rounded,
                    title: "Language".tr,
                    onTap: () {
                      Get.to(
                        () => const LanguageScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications".tr,
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // ==================================================
              // SUPPORT
              // ==================================================
              _sectionTitle("Support".tr),

              SizedBox(height: 10.h),

              _settingsCard(
                children: [
                  _settingTile(
                    icon: Icons.help_outline_rounded,
                    title: "Help Center".tr,
                    onTap: () {},
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.headset_mic_outlined,
                    title: "Contact Us".tr,
                    onTap: () {},
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.support_agent_rounded,
                    title: "Support".tr,
                    onTap: () {
                      Get.to(
                        () => const SupportScreen(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 250),
                      );
                    },
                  ),

                  _divider(),

                  _settingTile(
                    icon: Icons.info_outline_rounded,
                    title: "About".tr,
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              // ==================================================
              // LOGOUT
              // ==================================================
              _logoutButton(context),

              SizedBox(height: 18.h),

              // ==================================================
              // VERSION
              // ==================================================
              Center(
                child: Text(
                  "Villas Qatar • Version 1.0.0",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget _profileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // PROFILE IMAGE
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(.12)),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 28.sp,
            ),
          ),

          SizedBox(width: 14.w),

          // USER DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ahmed Al-Mansoori",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff242424),
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  "ahmed@email.com",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 7.h),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.07),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "View Profile".tr,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // EDIT BUTTON
          Material(
            color: AppColors.primary.withOpacity(.07),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                // Navigate to Edit Profile
              },
              child: SizedBox(
                width: 38.w,
                height: 38.w,
                child: Icon(
                  Icons.edit_outlined,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: .2,
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Column(children: children),
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // ICON
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.07),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 19.sp),
              ),

              SizedBox(width: 13.w),

              // TITLE
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff303030),
                  ),
                ),
              ),

              // ARROW
              Container(
                width: 28.w,
                height: 28.w,
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13.sp,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(left: 65.w, right: 14.w),
      child: Divider(
        height: 1,
        thickness: .7,
        color: AppColors.fieldBorder.withOpacity(.7),
      ),
    );
  }

  // ============================================================
  // LOGOUT BUTTON
  // ============================================================

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade200),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18.sp),

            SizedBox(width: 9.w),

            Text(
              "Logout".tr,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ICON
              Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.07),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 27.sp,
                ),
              ),

              SizedBox(height: 16.h),

              // TITLE
              Text(
                "Logout".tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),

              SizedBox(height: 8.h),

              // MESSAGE
              Text(
                "Are you sure you want to logout from your account?".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 22.h),

              // ACTIONS
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.fieldBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          "Cancel".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Close dialog
                          Get.back();

                          if (Get.isRegistered<AuthController>()) {
                            await Get.find<AuthController>().logout();
                          } else {
                            await StorageService.logout();

                            Get.offAll(() => WelcomeScreen());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          "Logout".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
