import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';
import 'package:villas_qatar/modules/settings/service/profile_controller.dart';
import 'package:villas_qatar/modules/settings/widget/editprofile_bottomsheet.dart';

import 'package:villas_qatar/modules/wishlist/view/whishlist_screen.dart';
import 'package:villas_qatar/modules/PlansandFeatures/views/my_featuresscreen.dart';
import 'package:villas_qatar/modules/settings/view/language_screen.dart';
import 'package:villas_qatar/modules/support/views/supports_screen.dart';

class SettingsScreen extends StatelessWidget {
 SettingsScreen({super.key});
final ProfileController controller = Get.put(ProfileController());
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Settings".tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        children: [
          /// Profile
          const ProfileHeader(),
          SizedBox(height: 30.h),

          /// Account
          SettingsSection(title: "Account".tr, items: accountItems),

          SizedBox(height: 20.h),

          /// Preferences
          SettingsSection(title: "Preferences".tr, items: preferenceItems),

          SizedBox(height: 20.h),
          SettingsSection(title: "Support".tr, items: supportItems),

          SizedBox(height: 20.h),

          const LogoutButton(),

          SizedBox(height: 24.h),

          Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  //==================== DATA ====================//

  List<SettingItem> get accountItems => [
    SettingItem(
      icon: Icons.person_outline,
      title: "Edit Profile".tr,
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const EditProfileBottomSheet(),
        );
      },
    ),
    SettingItem(
      icon: Icons.favorite_outline,
      title: "Saved Properties".tr,
      onTap: () => Get.to(() => WishlistScreen()),
    ),
    SettingItem(
      icon: Icons.home_work_outlined,
      title: "My Featured Properties".tr,
      onTap: () => Get.to(() => const MyFeaturedPropertiesScreen()),
    ),
  ];

  List<SettingItem> get preferenceItems => [
    SettingItem(
      icon: Icons.language,
      title: "Language".tr,
      onTap: () => Get.to(() => const LanguageScreen()),
    ),
    SettingItem(
      icon: Icons.notifications_none,
      title: "Notifications".tr,
      onTap: () {},
    ),
  ];

  List<SettingItem> get supportItems => [
    SettingItem(
      icon: Icons.help_outline,
      title: "Help Center".tr,
      onTap: () {},
    ),
    SettingItem(
      icon: Icons.headset_mic_outlined,
      title: "Contact Us".tr,
      onTap: () {},
    ),
    SettingItem(
      icon: Icons.support_agent,
      title: "Support".tr,
      onTap: () => Get.to(() => const SupportScreen()),
    ),
    SettingItem(icon: Icons.info_outline, title: "About".tr, onTap: () {}),
  ];
}

class SettingItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingItem> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (_, __) =>
                Divider(indent: 68.w, endIndent: 16.w, height: 1),
            itemBuilder: (_, index) {
              return SettingTile(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class SettingTile extends StatelessWidget {
  final SettingItem item;

  const SettingTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, color: AppColors.primary, size: 20.sp),
            ),

            SizedBox(width: 14.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  if (item.subtitle != null) ...[
                    SizedBox(height: 3.h),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
    
      builder: (controller) {
        if (controller.isLoading) {
          return Container(
            height: 95.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final profile = controller.profile;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.white.withOpacity(.2),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name.isNotEmpty == true
                          ? profile!.name
                          : "Guest",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      profile?.email.isNotEmpty == true
                          ? profile!.email
                          : "No Email",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),

                    SizedBox(height: 8.h),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Text(
                        profile?.role ?? "USER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () async {
                  // final updated = await Get.to(
                  // //  () => EditProfileScreen(),
                  // );

                  // if (updated == true) {
                  //   controller.fetchProfile();
                  // }
                },
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.18),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 18.sp,
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

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22.sp),
              ),

              SizedBox(height: 10.h),

              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(),
        icon: Icon(
          Icons.logout_rounded,
          color: Colors.red.shade600,
          size: 20.sp,
        ),
        label: Text(
          "Logout".tr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.red.shade600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.red.shade100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 34.sp,
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                "Logout".tr,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              Text(
                "Are you sure you want to logout from your account?".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        "Cancel".tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();

                        if (Get.isRegistered<AuthController>()) {
                          await Get.find<AuthController>().logout();
                        } else {
                          await StorageService.logout();
                          Get.offAll(() => WelcomeScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(48.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        "Logout".tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
