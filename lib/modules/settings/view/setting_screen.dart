import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/auth_screen.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';
import 'package:villas_qatar/modules/settings/view/language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Settings".tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileCard(),

            const SizedBox(height: 24),

            _sectionTitle("Account"),

            _settingsCard([
              _settingTile(Icons.person_outline, "Edit Profile".tr, () {}),
              _settingTile(Icons.favorite_border, "Saved Properties".tr, () {}),
              _settingTile(Icons.home_work_outlined, "My Listings".tr, () {}),
            ]),

            const SizedBox(height: 20),

            _sectionTitle("Preferences"),

            _settingsCard([
              _settingTile(Icons.language, "Language".tr, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                );
              }),
              _settingTile(Icons.notifications_none, "Notifications".tr, () {}),
            ]),

            const SizedBox(height: 20),

            _sectionTitle("Support".tr),

            _settingsCard([
              _settingTile(Icons.help_outline, "Help Center".tr, () {}),
              _settingTile(Icons.phone_outlined, "Contact Us".tr, () {}),
              _settingTile(Icons.info_outline, "About".tr, () {}),
            ]),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: Icon(Icons.logout),
                label: Text("Logout".tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _profileCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.fieldBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primarySoft,
          child: Icon(Icons.person, color: AppColors.primary, size: 30),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ahmed Al-Mansoori",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "ahmed@email.com",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
      ],
    ),
  );
}

Widget _settingsCard(List<Widget> children) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.fieldBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.03),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

Widget _settingTile(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.primary.withOpacity(.08),
      child: Icon(icon, color: AppColors.primary, size: 20),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
    onTap: onTap,
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.only(top: 24),
        title: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(.1),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Logout".tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to logout from your account?".tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary.withOpacity(.4)),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    "Cancel".tr,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    "Logout".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
